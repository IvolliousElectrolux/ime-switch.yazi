# ime-switch.yazi

Auto-switch Microsoft Pinyin between Chinese and English based on Yazi UI layer:

- `input` layer (rename / create / filter / find / shell prompt, etc.) → Chinese
- other layers → English

Windows only. Uses `cx.layer` via a `Status` render hook.

## Requirements

- Yazi >= 26.9.1
- Microsoft Pinyin
- PowerShell (Windows built-in)

## Install

```sh
ya pack -a IvolliousElectrolux/ime-switch
```

Or copy this folder to your Yazi plugins directory as `ime-switch.yazi`.

Then in `init.lua`:

```lua
require("ime-switch"):setup()
```

## Notes

- Only touches files inside this plugin directory.
- Switches IME conversion mode of the foreground window (中/英), not the keyboard layout.
- If it does nothing in your terminal, the Imm default IME window may be unavailable for that host; open an issue with your terminal name.
