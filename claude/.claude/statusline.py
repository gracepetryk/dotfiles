#!/usr/bin/env python3
"""Claude Code status line.

Shows: model | cwd | context used (% + tokens) | cache TTL countdown | session cost

Cache TTL is not provided by Claude Code directly. The prompt cache lifetime is
1h (ENABLE_PROMPT_CACHING_1H) and its expiry refreshes on every API call, so we
approximate expiry as (last transcript timestamp + 3600s). To avoid parsing the
transcript on every render, the expiry epoch is cached per session and only
recomputed every 10s; the countdown itself is computed cheaply each render from
that cached value.
"""
import json
import os
import sys
import time
from datetime import datetime, timezone

CACHE_TTL_SECONDS = 3600
REFRESH_INTERVAL = 10

# ANSI colors
RESET = "\033[0m"
DIM = "\033[2m"
BOLD = "\033[1m"
CYAN = "\033[36m"
BLUE = "\033[34m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
RED = "\033[31m"
MAGENTA = "\033[35m"
SEP = f"{DIM} | {RESET}"


def color(text, c):
    return f"{c}{text}{RESET}"


def usage_color(pct):
    """Green when there's headroom, yellow getting full, red when nearly full."""
    if pct is None:
        return DIM
    if pct < 50:
        return GREEN
    if pct < 80:
        return YELLOW
    return RED


def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        data = {}

    now = time.time()

    model = (data.get("model") or {}).get("display_name") or "?"
    effort = data.get("effort")
    if isinstance(effort, dict):
        effort = effort.get("level") or effort.get("name")
    model_label = color(model, BOLD + CYAN)
    if effort:
        model_label += " " + color(effort, DIM)
    ws = data.get("workspace") or {}
    cwd = ws.get("current_dir") or data.get("cwd") or ""
    dir_name = os.path.basename(cwd.rstrip("/")) if cwd else ""
    cost = (data.get("cost") or {}).get("total_cost_usd") or 0
    cw = data.get("context_window") or {}
    ctx_pct = cw.get("used_percentage")
    used_tokens = cw.get("total_input_tokens")
    window_size = cw.get("context_window_size")
    session_id = data.get("session_id") or "default"
    transcript = data.get("transcript_path")

    parts = [
        model_label,
        color(dir_name, BLUE),
        context_segment(ctx_pct, used_tokens, window_size),
        cache_segment(session_id, transcript, now),
        cost_segment(cost),
    ]
    print(SEP.join(parts), end="")


def context_segment(ctx_pct, used_tokens, window_size):
    """e.g. 'ctx 42% (84k/200k)' colored by fullness."""
    if ctx_pct is None:
        return color("ctx --", DIM)
    label = f"ctx {ctx_pct:.0f}%"
    if used_tokens and window_size:
        label += f" ({fmt_k(used_tokens)}/{fmt_k(window_size)})"
    elif used_tokens:
        label += f" ({fmt_k(used_tokens)})"
    return color(label, usage_color(ctx_pct))


def fmt_k(n):
    if n >= 1_000_000:
        return f"{n / 1_000_000:.1f}M"
    if n >= 1000:
        return f"{n / 1000:.0f}k"
    return str(n)


def cache_segment(session_id, transcript, now):
    """Live cache TTL countdown, minutes only, recomputed at most every 10s."""
    cache_file = os.path.join(
        os.environ.get("TMPDIR", "/tmp"), f"cc_cache_expiry_{session_id}"
    )
    expiry = read_cached_expiry(cache_file, now)
    if expiry is None:
        expiry = compute_expiry(transcript)
        if expiry is not None:
            try:
                with open(cache_file, "w") as f:
                    f.write(str(expiry))
            except OSError:
                pass

    if expiry is None:
        return color("cache --", DIM)

    remaining = int(expiry - now)
    if remaining <= 0:
        return color("cache expired", RED)
    minutes = max(1, round(remaining / 60))
    c = GREEN if minutes > 20 else YELLOW if minutes > 5 else RED
    return color(f"cache {minutes}m", c)


def cost_segment(cost):
    return color(f"${cost:.2f}", MAGENTA)


def read_cached_expiry(cache_file, now):
    """Return the cached expiry epoch if the cache file is fresh (<10s), else None."""
    try:
        if now - os.path.getmtime(cache_file) < REFRESH_INTERVAL:
            with open(cache_file) as f:
                return float(f.read().strip())
    except (OSError, ValueError):
        pass
    return None


def compute_expiry(transcript):
    """Derive cache expiry from the last timestamp in the transcript JSONL."""
    if not transcript or not os.path.isfile(transcript):
        return None
    last_ts = None
    try:
        with open(transcript) as f:
            for line in f:
                try:
                    ts = json.loads(line).get("timestamp")
                except (ValueError, AttributeError):
                    continue
                if ts:
                    last_ts = ts
    except OSError:
        return None
    if not last_ts:
        return None
    try:
        dt = datetime.fromisoformat(last_ts.replace("Z", "+00:00"))
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        return dt.timestamp() + CACHE_TTL_SECONDS
    except ValueError:
        return None


if __name__ == "__main__":
    main()
