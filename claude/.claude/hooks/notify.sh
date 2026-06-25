#!/usr/bin/env bash
# Claude Code "Notification" hook.
#
# Shows a macOS notification via `kitten notify` when a session needs attention
# (permission prompts / idle nudges), but only when this session is NOT the
# currently focused kitty window/tab. The OSC-99 escape is written directly to
# this window's pts device, so kitty associates it with this window and clicking
# the notification focuses this exact session. The title is the session name.
#
# Requires `preferredNotifChannel: notifications_disabled` in settings.json so
# Claude Code's own (generic "Claude Code") notification doesn't double up.
# Wired up from ~/.claude/settings.json -> hooks.Notification.

KITTY=/Applications/kitty.app/Contents/MacOS/kitty
KITTEN=/Applications/kitty.app/Contents/MacOS/kitten
ICON="$HOME/.claude/claude-icon.png"

in=$(cat)

# Only notify for attention-worthy types: permission prompts and idle nudges.
# Ignore auth_success / elicitation_* and anything else.
ntype=$(printf '%s' "$in" | jq -r '.notification_type // empty')
case "$ntype" in
  permission_prompt|idle_prompt) ;;
  *) exit 0 ;;
esac

msg=$(printf '%s' "$in" | jq -r '.message // "Claude Code needs your attention"')
tpath=$(printf '%s' "$in" | jq -r '.transcript_path // empty')
sid=$(printf '%s' "$in" | jq -r '.session_id // empty')

# Fall back to locating the transcript by session id if the payload omits it.
if { [ -z "$tpath" ] || [ ! -f "$tpath" ]; } && [ -n "$sid" ]; then
  tpath=$(ls -t "$HOME"/.claude/projects/*/"$sid".jsonl 2>/dev/null | head -1)
fi

# Resolve the session name the same way /status does: prefer the latest non-empty
# custom name (/rename), otherwise fall back to the latest auto-generated AI title.
# Both live in the transcript jsonl as custom-title/ai-title records.
sname=""
if [ -n "$tpath" ] && [ -f "$tpath" ]; then
  sname=$(jq -r 'select(.type=="custom-title") | .customTitle' "$tpath" 2>/dev/null | tail -1)
  [ -z "$sname" ] && sname=$(jq -r 'select(.type=="ai-title") | .aiTitle' "$tpath" 2>/dev/null | tail -1)
fi
title="Claude Code"
[ -n "$sname" ] && title="$sname"

wid=${KITTY_WINDOW_ID:-0}
ls=$("$KITTY" @ ls 2>/dev/null)

# Suppress the notification if this session is the focused kitty window/tab.
front=$(osascript -e 'tell application "System Events" to name of first process whose frontmost is true' 2>/dev/null)
if [ "$front" = "kitty" ]; then
  on_active=$(printf '%s' "$ls" | jq --argjson wid "$wid" 'any(.[]; .is_focused and any(.tabs[]; .is_active and any(.windows[]; .id == $wid)))' 2>/dev/null)
  [ "$on_active" = "true" ] && exit 0
fi

# Deliver by writing the OSC-99 escape to this window's pts device. The hook has
# no controlling terminal, so kitten's own tty access (and >> /dev/tty) fails;
# instead we find the window's pid from `kitty @ ls`, map it to its tty, and
# write the escape there. kitty associates it with this window so clicking the
# notification focuses this exact session.
pid=$(printf '%s' "$ls" | jq -r --argjson wid "$wid" '.[].tabs[].windows[] | select(.id==$wid) | .pid')
[ -n "$pid" ] && dev="/dev/$(ps -o tty= -p "$pid" | tr -d ' ')" || dev=""
if [ -n "$dev" ] && [ -w "$dev" ]; then
  "$KITTEN" notify --only-print-escape-code --identifier "claude-${sid:-session}" --expire-after 5m --sound-name silent --icon-path "$ICON" "$title" "$msg" > "$dev" 2>/dev/null
fi
exit 0
