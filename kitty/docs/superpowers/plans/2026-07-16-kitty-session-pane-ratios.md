# Kitty Session Pane Ratios Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make both Kitty development-layout entry points start with a 70:30 left/right split and an equal 50:50 split in the right column.

**Architecture:** Keep the existing `splits` layout and encode proportions at pane creation time with Kitty's `launch --bias` option. Apply identical values to the startup-session file and the remote-control helper script so both entry points remain behaviorally equivalent.

**Tech Stack:** Kitty 0.47.4 startup sessions, Kitty remote control, Bash

## Global Constraints

- Preserve the existing three-pane structure and shell commands.
- Preserve `--cwd=current` and final focus behavior in the helper script.
- Do not change Kitty's OS-window size, key mappings, or layout type.
- Use `--bias=30` for the new right column and `--bias=50` for the new lower-right pane.

---

### Task 1: Persist the Current Pane Proportions

**Files:**
- Modify: `sessions/dev.conf:18-22`
- Modify: `sessions/dev-layout.sh:17-21`

**Interfaces:**
- Consumes: Kitty `splits` layout semantics, where `launch --bias=N` gives the newly created pane `N` percent of the pane being split.
- Produces: Two equivalent layout entry points with right-column bias `30` and lower-right bias `50`.

- [x] **Step 1: Run the layout-consistency check and verify it fails**

Run:

```bash
rg -n -- '--location=vsplit --bias=30|--location=hsplit --bias=50' sessions/dev.conf sessions/dev-layout.sh
```

Expected: no matches and exit status `1`, because neither entry point currently specifies a bias.

- [x] **Step 2: Add explicit bias values to the startup session**

Change the two pane launches in `sessions/dev.conf` to:

```conf
# 右上窗格（垂直分割，右侧占 30%）
launch --location=vsplit --bias=30 zsh

# 右下窗格（对右上做水平分割，上下各占 50%）
launch --location=hsplit --bias=50 zsh
```

- [x] **Step 3: Add the same bias values to the helper script**

Change the two pane launches in `sessions/dev-layout.sh` to:

```bash
# 右上窗格（对当前窗格做垂直分割，右侧占 30%）
kitty @ launch --location=vsplit --bias=30 --cwd=current

# 右下窗格（对右上窗格做水平分割，上下各占 50%）
kitty @ launch --location=hsplit --bias=50 --cwd=current
```

- [x] **Step 4: Verify both entry points contain identical bias values**

Run:

```bash
rg -n -- '--location=vsplit --bias=30|--location=hsplit --bias=50' sessions/dev.conf sessions/dev-layout.sh
```

Expected: four matches total: one vertical and one horizontal split in each file.

- [x] **Step 5: Validate session parsing and shell syntax**

Run:

```bash
kitty +runpy 'from pathlib import Path; from kitty.config import load_config; from kitty.session import parse_session; raw=Path("sessions/dev.conf").read_text(); sessions=tuple(parse_session(raw, load_config())); print(f"parsed {len(sessions)} session(s)")'
bash -n sessions/dev-layout.sh
git diff --check -- sessions/dev.conf sessions/dev-layout.sh
```

Expected: the parser prints `parsed 1 session(s)` and the remaining commands exit with status `0` and no output.

- [x] **Step 6: Commit the implementation**

```bash
git add kitty/sessions/dev.conf kitty/sessions/dev-layout.sh kitty/docs/superpowers/plans/2026-07-16-kitty-session-pane-ratios.md
git commit -m "config: preserve kitty session pane ratios"
```
