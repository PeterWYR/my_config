# Kitty Session Pane Ratios Design

## Goal

Make the default three-pane Kitty development session reproduce the current pane proportions when it starts:

- Left pane: approximately 70% of the available width
- Right column: approximately 30% of the available width
- Right-top and right-bottom panes: 50% each of the available height

The observed pane sizes are `94x24` for the left pane and `39x11` for each right pane. The design preserves their proportions rather than fixed character dimensions so it remains useful when the OS window is resized.

## Configuration Changes

Update both layout entry points so they remain consistent:

1. In `sessions/dev.conf`, add `--bias=30` to the vertical split that creates the right column and `--bias=50` to the horizontal split that creates the lower-right pane.
2. Apply the same bias values to the corresponding `kitty @ launch` commands in `sessions/dev-layout.sh`.

Kitty interprets `--bias` in the splits layout as the percentage of the original pane assigned to the newly created pane. Therefore:

- `--location=vsplit --bias=30` gives the new right pane 30% and leaves the original left pane 70%.
- `--location=hsplit --bias=50` divides the right column equally between its original top pane and the new bottom pane.

## Scope

Only initial pane proportions change. Shell commands, working directories, focus behavior, layout type, key mappings, and OS-window size remain unchanged.

## Verification

- Check that both layout entry points use the same `30` and `50` bias values.
- Validate the startup session with Kitty's session parser.
- Run a shell syntax check on `sessions/dev-layout.sh`.
