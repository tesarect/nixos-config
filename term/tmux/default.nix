# term/tmux/default.nix

# { pkgs, ... }:
# let
#   tmux-super-fingers = pkgs.tmuxPlugins.mkTmuxPlugin
#     {
#       pluginName = "tmux-super-fingers";
#       version = "unstable-2023-01-06";
#       src = pkgs.fetchFromGitHub {
#         owner = "artemave";
#         repo = "tmux_super_fingers";
#         rev = "2c12044984124e74e21a5a87d00f844083e4bdf7";
#         sha256 = "sha256-cPZCV8xk9QpU49/7H8iGhQYK6JwWjviL29eWabuqruc=";
#       };
#     };
# in
# {
#   programs.tmux = {
#     enable = true;
#     shell = "${pkgs.fish}/bin/fish";
#     terminal = "tmux-256color";
#     historyLimit = 100000;
#     plugins = with pkgs;
#       [
#         {
#           plugin = tmux-super-fingers;
#           extraConfig = "set -g @super-fingers-key f";
#         }
#         tmuxPlugins.better-mouse-mode
#       ];
#     extraConfig = ''
#     '';
#   };
# }

{ config, pkgs, ... }: {
    imports = [ ./theme.nix ]; # ----A1------ also need to remove if not working

    programs.tmux = {
        enable = true;
        terminal = "tmux-256color";
        shell = "${pkgs.zsh}/bin/zsh";
        prefix = "C-Space";
        mouse = true;
        keyMode = "vi";
        baseIndex = 1;
        historyLimit = 100000;
        plugins = with pkgs; [
            tmuxPlugins.better-mouse-mode
#             modern-tmux-theme
#             tmuxPlugins.catppuccin
            tmuxPlugins.sensible
            tmuxPlugins.vim-tmux-navigator
            tmuxPlugins.power-theme
#             {
#                 plugin = tmuxPlugins.catppuccin;
#                 extraConfig = ''
#                     set -g status-position top
#                     set -g @catppuccin_flavor 'macchiato' # latte, frappe, macchiato or mocha
#                     set -g @catppuccin_window_status_style "rounded"
#                     set -g @catppuccin_window_number_position "right"
#
#                     set -g @catppuccin_window_default_fill "number"
#                     set -g @catppuccin_window_default_text "#W"
#
#                     set -g @catppuccin_window_current_fill "number"
#                     set -g @catppuccin_window_current_text "#W"
#
#                     set -g @catppuccin_status_left_separator  " "
#                     set -g @catppuccin_status_right_separator ""
#                     set -g @catppuccin_status_fill "icon"
#                     set -g @catppuccin_status_connect_separator "no"
#                 '';
#             }
#             tmuxPlugins.tmux-snazzy
#             tmuxPlugins-power-unstable
            # must be before continuum edits right status bar
#             {
#                 plugin = tmuxPlugins.catppuccin;
#                 extraConfig = ''
#                 set -g @catppuccin_flavour 'frappe'
#                 set -g @catppuccin_window_tabs_enabled on
#                 set -g @catppuccin_date_time "%H:%M"
#                 '';
#             }
            {
                plugin = tmuxPlugins.resurrect;
                extraConfig = ''
                set -g @resurrect-strategy-vim 'session'
                set -g @resurrect-strategy-nvim 'session'
                set -g @resurrect-capture-pane-contents 'on'
                '';
            }
            {
                plugin = tmuxPlugins.continuum;
                extraConfig = ''
                set -g @continuum-restore 'on'
                set -g @continuum-boot 'on'
                set -g @continuum-save-interval '10'
                '';
            }
        ];
#         extraConfig = ''
#             bind c new-window -c "#{pane_current_path}"
#             bind '"' split-window -v -c "#{pane_current_path}"
#             bind % split-window -h -c "#{pane_current_path}"
#         '';

        extraConfig = with config.theme; with pkgs.tmuxPlugins;
        ''
            set-option -g status-right ' #{prefix_highlight} "#{=21:pane_title}" %H:%M %d-%b-%y'
            set-option -g status-left-length 20
            set-option -g @prefix_highlight_fg '${colors.background}'
            set-option -g @prefix_highlight_bg '${colors.dominant}'
            run-shell '${prefix-highlight}/share/tmux-plugins/prefix-highlight/prefix_highlight.tmux'

            # Be faster switching windows
            bind C-n next-window
            bind C-p previous-window

            set-option -g set-titles on

            bind C-y run-shell ' \
                ${pkgs.tmux}/bin/tmux show-buffer > /dev/null 2>&1 \
                && ${pkgs.tmux}/bin/tmux show-buffer | ${pkgs.xsel}/bin/xsel -ib'

            # Force true colors
            set-option -ga terminal-overrides ",*:Tc"

            set-option -g mouse on
            set-option -g focus-events on

            # Stay in same directory when split
            bind % split-window -h -c "#{pane_current_path}"
            bind '"' split-window -v -c "#{pane_current_path}"

            # Colorscheme
            set-option -g status-style 'fg=${colors.dimForeground}, bg=${colors.background}'

            set-option -g window-status-current-style 'fg=${colors.dominant}'

            set-option -g pane-border-style 'fg=${colors.background}'
            set-option -g pane-active-border-style 'fg=${colors.dominant}'

            set-option -g message-style 'fg=${colors.background}, bg=${colors.dimForeground}'

            set-option -g mode-style    'fg=${colors.background}, bg=${colors.dominant}'

            set-option -g display-panes-active-colour '${colors.dominant}'
            set-option -g display-panes-colour '${colors.dimForeground}'

            set-option -g clock-mode-colour '${colors.dominant}'
        '';
    };
}


# extraConfig = with config.theme; with pkgs.tmuxPlugins;
#         ''
#             # Plugins
# #             run-shell '${copycat}/share/tmux-plugins/copycat/copycat.tmux'
# #             run-shell '${sensible}/share/tmux-plugins/sensible/sensible.tmux'
# #             run-shell '${urlview}/share/tmux-plugins/urlview/urlview.tmux'
# #
# #             bind-key R run-shell ' \
# #                 tmux source-file /etc/tmux.conf > /dev/null; \
# #                 tmux display-message "sourced /etc/tmux.conf"'
# #
# #             if -F "$SSH_CONNECTION" "source-file '${remoteConf}'"
#
#             set-option -g status-right ' #{prefix_highlight} "#{=21:pane_title}" %H:%M %d-%b-%y'
#             set-option -g status-left-length 20
#             set-option -g @prefix_highlight_fg '${colors.background}'
#             set-option -g @prefix_highlight_bg '${colors.dominant}'
#             run-shell '${prefix-highlight}/share/tmux-plugins/prefix-highlight/prefix_highlight.tmux'
#
#             # Be faster switching windows
#             bind C-n next-window
#             bind C-p previous-window
#
# #             # Send the bracketed paste mode when pasting
# #             bind ] paste-buffer -p
#
#             set-option -g set-titles on
#
#             bind C-y run-shell ' \
#                 ${pkgs.tmux}/bin/tmux show-buffer > /dev/null 2>&1 \
#                 && ${pkgs.tmux}/bin/tmux show-buffer | ${pkgs.xsel}/bin/xsel -ib'
#
#             # Force true colors
#             set-option -ga terminal-overrides ",*:Tc"
#
#             set-option -g mouse on
#             set-option -g focus-events on
#
#             # Stay in same directory when split
#             bind % split-window -h -c "#{pane_current_path}"
#             bind '"' split-window -v -c "#{pane_current_path}"
#
#             # Colorscheme
#             set-option -g status-style 'fg=${colors.dimForeground}, bg=${colors.background}'
#
#             set-option -g window-status-current-style 'fg=${colors.dominant}'
#
#             set-option -g pane-border-style 'fg=${colors.background}'
#             set-option -g pane-active-border-style 'fg=${colors.dominant}'
#
#             set-option -g message-style 'fg=${colors.background}, bg=${colors.dimForeground}'
#
#             set-option -g mode-style    'fg=${colors.background}, bg=${colors.dominant}'
#
#             set-option -g display-panes-active-colour '${colors.dominant}'
#             set-option -g display-panes-colour '${colors.dimForeground}'
#
#             set-option -g clock-mode-colour '${colors.dominant}'
#         '';
