#!/usr/bin/env python3
"""Claude Code status line.

Shows: model | context used (% + tokens) | billing

The billing segment adapts to how the session is paying:
- API-key billing: session cost in USD (as before).
- Subscription (Pro/Max) with headroom left: % of the 5-hour session limit
  remaining and when it resets. Detected via the `rate_limits` field, which
  Claude Code only sends for claude.ai subscribers.
- Subscription with the session limit exhausted: pinned at 100%, plus the
  reset time and the session cost, now labeled as usage credits since that's
  what's being drawn on past the plan's included usage.
"""
import colorsys
import json
import os
import re
import sys
from datetime import datetime

ANSI_RE = re.compile(r"\033\[[0-9;]*m")

# ANSI colors
RESET = "\033[0m"
DIM = "\033[2m"
BOLD = "\033[1m"
CYAN = "\033[36m"
MAGENTA = "\033[35m"
SEP = f"{DIM} | {RESET}"


def color(text, c):
    return f"{c}{text}{RESET}"


# Anchored on kitty's theme green (color2, #23d18b - see
# kitty/.config/kitty/current-theme.conf), which reads nicer than a flat
# (0, 220, 0). Its hue/saturation/value carry through the whole gradient
# down to red (hue 0) so the low end stays this same green. Interpolating
# hue (through yellow) rather than mixing RGB directly keeps the midpoint
# from dimming into a muddy brown. Value ramps up toward the red end since
# the theme green's own brightness reads as a dim red at the same value.
_GREEN_HUE, USAGE_SATURATION, USAGE_VALUE_GREEN = colorsys.rgb_to_hsv(
    0x23 / 255, 0xD1 / 255, 0x8B / 255
)
USAGE_HUE_GREEN = _GREEN_HUE * 360
USAGE_HUE_RED = 0
USAGE_VALUE_RED = 245 / 255
USAGE_BAND_COUNT = 10


def usage_color(pct):
    """Gradient from theme green to a brighter red, one shade per 10% band."""
    if pct is None:
        return DIM
    band = min(int(pct) // 10, USAGE_BAND_COUNT - 1)
    t = band / (USAGE_BAND_COUNT - 1)
    hue = USAGE_HUE_GREEN + t * (USAGE_HUE_RED - USAGE_HUE_GREEN)
    value = USAGE_VALUE_GREEN + t * (USAGE_VALUE_RED - USAGE_VALUE_GREEN)
    r, g, b = colorsys.hsv_to_rgb(hue / 360, USAGE_SATURATION, value)
    return f"\033[38;2;{round(r * 255)};{round(g * 255)};{round(b * 255)}m"


def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        data = {}

    model = (data.get("model") or {}).get("display_name") or "?"
    effort = data.get("effort")
    if isinstance(effort, dict):
        effort = effort.get("level") or effort.get("name")
    model_label = color(model, BOLD + CYAN)
    if effort:
        model_label += " " + color(effort, DIM)
    cost = (data.get("cost") or {}).get("total_cost_usd") or 0
    cw = data.get("context_window") or {}
    ctx_pct = cw.get("used_percentage")
    used_tokens = cw.get("total_input_tokens")
    window_size = cw.get("context_window_size")
    rate_limits = data.get("rate_limits")

    parts = [
        model_label,
        context_segment(ctx_pct, used_tokens, window_size),
        billing_segment(rate_limits, cost),
    ]
    columns = int(os.environ.get("COLUMNS") or 0)
    print("\n".join(wrap_segments(parts, columns)), end="")


def visible_len(s):
    return len(ANSI_RE.sub("", s))


def wrap_segments(parts, width):
    """Pack whole segments onto lines that fit `width`, wrapping instead of
    letting the terminal truncate. Falls back to one line when width is
    unknown (COLUMNS is only set by Claude Code v2.1.153+)."""
    if width <= 0:
        return [SEP.join(parts)]

    sep_width = visible_len(SEP)
    lines = []
    current = []
    current_width = 0
    for part in parts:
        part_width = visible_len(part)
        added_width = part_width + (sep_width if current else 0)
        if current and current_width + added_width > width:
            lines.append(SEP.join(current))
            current = [part]
            current_width = part_width
        else:
            current.append(part)
            current_width += added_width
    if current:
        lines.append(SEP.join(current))
    return lines


# Models with extended (e.g. 1M) context windows shouldn't have to fill the
# whole thing before the status line warns you - 200k is where things
# typically start degrading, so that's the practical /compact or /clear
# reminder point regardless of the nominal window size.
CONTEXT_COMPACT_THRESHOLD = 200_000


def context_color(used_tokens, window_size):
    if used_tokens is None:
        return DIM
    cap = min(CONTEXT_COMPACT_THRESHOLD, window_size or CONTEXT_COMPACT_THRESHOLD)
    return usage_color(100 * used_tokens / cap)


def context_segment(ctx_pct, used_tokens, window_size):
    """e.g. 'ctx 42% (84k/200k)' colored by fullness, parens dimmed."""
    if ctx_pct is None:
        return color("ctx --", DIM)
    label = color(f"ctx {ctx_pct:.0f}%", context_color(used_tokens, window_size))
    if used_tokens and window_size:
        label += " " + color(f"({fmt_k(used_tokens)}/{fmt_k(window_size)})", DIM)
    elif used_tokens:
        label += " " + color(f"({fmt_k(used_tokens)})", DIM)
    return label


def fmt_k(n):
    if n >= 1_000_000:
        return f"{n / 1_000_000:.1f}M"
    if n >= 1000:
        return f"{n / 1000:.0f}k"
    return str(n)


def billing_segment(rate_limits, cost):
    """Session limit % used on a subscription plan, or $ cost on API billing.

    `rate_limits` is only present for claude.ai (Pro/Max) subscribers, so its
    presence is what distinguishes the two billing modes.
    """
    five_hour = (rate_limits or {}).get("five_hour") or {}
    seven_day = (rate_limits or {}).get("seven_day") or {}
    used_pct = five_hour.get("used_percentage")
    if used_pct is None:
        return cost_segment(cost)

    # Either window can independently block further usage - the weekly cap
    # can hit while the 5-hour window still has headroom, so check both.
    exhausted = [
        w for w in (five_hour, seven_day) if (w.get("used_percentage") or 0) >= 100
    ]
    if exhausted:
        binding = max(exhausted, key=lambda w: w.get("resets_at") or 0)
        reset_label = fmt_resets(binding.get("resets_at"))
        label = "usg 100%"
        if reset_label:
            label += f" ({reset_label})"
        return f"{color(label, DIM)} {color(f'${cost:.2f}', BOLD + usage_color(100))}"

    reset_label = fmt_resets(five_hour.get("resets_at"))
    label = color(f"usg {used_pct:.0f}%", usage_color(used_pct))
    if reset_label:
        label += " " + color(f"({reset_label})", DIM)
    return label


def fmt_resets(epoch_seconds):
    """e.g. '12:30AM', in local time. None if epoch_seconds is missing."""
    if not epoch_seconds:
        return None
    try:
        dt = datetime.fromtimestamp(epoch_seconds).astimezone()
        return dt.strftime("%-I:%M%p")
    except (OSError, OverflowError, ValueError):
        return None


def cost_segment(cost):
    return color(f"${cost:.2f}", MAGENTA)


if __name__ == "__main__":
    main()
