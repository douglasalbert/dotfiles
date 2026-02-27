{ ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    terminal = "screen-256color";

    extraConfig = ''
      # Split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Don't rename windows automatically
      set-option -g allow-rename off

      # Pane borders
      set -g pane-border-style fg=colour238,bg=colour235
      set -g pane-active-border-style fg=colour51,bg=colour236

      # Status bar
      set -g status-justify left
      set -g status-interval 2
      set -g status-position bottom
      set -g status-style bg=colour234,fg=colour137,dim
      set -g status-left ""
      set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
      set -g status-right-length 50
      set -g status-left-length 20

      # Window status
      setw -g window-status-current-style fg=colour81,bg=colour238,bold
      setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '
      setw -g window-status-style fg=colour138,bg=colour235,none
      setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
      setw -g window-status-bell-style fg=colour255,bg=colour1,bold

      # Messages
      set -g message-style fg=colour232,bg=colour166,bold

      # Modes
      setw -g clock-mode-colour colour135
      setw -g mode-style fg=colour196,bg=colour238,bold

      # Quiet
      set-option -g visual-activity off
      set-option -g visual-bell off
      set-option -g visual-silence off
      set-window-option -g monitor-activity off
      set-option -g bell-action none
    '';
  };
}
