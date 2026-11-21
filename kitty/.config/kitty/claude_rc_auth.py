"""Remote control auth for the nvim send-to-claude actions (nvim/lua/gpetryk/claude.lua).

Referenced by `remote_control_password` in local.conf. Only allows the commands
those actions use, and only lets send-text deliver a single file reference of the
form `@path:123` or `@path:123-456`.

See: https://sw.kovidgoyal.net/kitty/remote-control/#rc-custom-auth
"""

import base64
import re

# `@<path>:<line>` or `@<path>:<start>-<end>`, optionally followed by one space.
# The path may not contain whitespace or control characters, so the text can't
# carry newlines (which would submit a prompt) or escape sequences.
FILE_REF = re.compile(r"@[^\x00-\x20\x7f]+:\d+(?:-\d+)? ?")
WINDOW_ID = re.compile(r"id:\d+")


def _decode(data):
    """Returns the text a send-text payload delivers, or None if it can't be decoded."""
    if not isinstance(data, str):
        return None
    kind, sep, rest = data.partition(":")
    if not sep:
        return None
    if kind == "text":
        return rest
    if kind == "base64":
        try:
            return base64.standard_b64decode(rest).decode("utf-8")
        except ValueError:
            return None
    return None


def _targets_one_window(payload):
    return (
        isinstance(payload.get("match"), str)
        and WINDOW_ID.fullmatch(payload["match"]) is not None
        and not payload.get("match_tab")
        and not payload.get("all")
    )


def _send_text_allowed(payload):
    if not _targets_one_window(payload):
        return False
    text = _decode(payload.get("data"))
    return text is not None and FILE_REF.fullmatch(text) is not None


def is_cmd_allowed(pcmd, window, from_socket, extra_data):
    cmd = pcmd.get("cmd")
    payload = pcmd.get("payload") or {}

    if cmd in ("ls", "focus-window"):
        return True
    if cmd == "send-text":
        return _send_text_allowed(payload)
    return False
