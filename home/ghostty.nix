{ ... }:

{
  home.file.".config/ghostty/config".text = ''
    theme = light:light-ergo,dark:dark-ergo
    window-theme = system
    font-family = "SF Mono Powerline"
    keybind = shift+enter=text:\n
    font-thicken = true
    minimum-contrast = 1.1
    window-padding-x = 12
    window-padding-y = 12
    macos-titlebar-style = hidden
    background-opacity = 0.95
    background-blur-radius = 20
    mouse-hide-while-typing = true
    scrollback-limit = 100000
    macos-option-as-alt = true
    clipboard-read = allow
    clipboard-write = allow
    clipboard-paste-protection = true
  '';

  home.file.".config/ghostty/themes/dark-ergo".text = ''
    palette = 0=#51576d
    palette = 1=#e78284
    palette = 2=#a6d189
    palette = 3=#e5c890
    palette = 4=#8caaee
    palette = 5=#f4b8e4
    palette = 6=#81c8be
    palette = 7=#a5adce
    palette = 8=#626880
    palette = 9=#e78284
    palette = 10=#a6d189
    palette = 11=#e5c890
    palette = 12=#8caaee
    palette = 13=#f4b8e4
    palette = 14=#81c8be
    palette = 15=#b5bfe2
    background = 303446
    foreground = c6d0f5
    cursor-color = f2d5cf
    cursor-text = 232634
    selection-background = 44495d
    selection-foreground = c6d0f5
    split-divider-color = 414559
    unfocused-split-fill = #232634
    unfocused-split-opacity = 0.7
  '';

  home.file.".config/ghostty/themes/light-ergo".text = ''
    palette = 0=#5c5f77
    palette = 1=#d20f39
    palette = 2=#40a02b
    palette = 3=#df8e1d
    palette = 4=#1e66f5
    palette = 5=#ea76cb
    palette = 6=#179299
    palette = 7=#acb0be
    palette = 8=#6c6f85
    palette = 9=#d20f39
    palette = 10=#40a02b
    palette = 11=#df8e1d
    palette = 12=#1e66f5
    palette = 13=#ea76cb
    palette = 14=#179299
    palette = 15=#bcc0cc
    background = eff1f5
    foreground = 4c4f69
    cursor-color = dc8a78
    cursor-text = eff1f5
    selection-background = d8dae1
    selection-foreground = 4c4f69
    split-divider-color = ccd0da
    unfocused-split-fill = #dce0e8
    unfocused-split-opacity = 0.8
  '';
}
