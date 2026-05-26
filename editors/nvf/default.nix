# editors/nvf/default.nix
{ config, pkgs, ... }:

{
  vim = {

    enableLuaLoader = true;

    # Theme settings
    theme = {
      enable = true;
      transparent = true;
      name = "catppuccin";
      style = "macchiato"; # latte", "frappe", "macchiato", "mocha"
    };

    lineNumberMode = "relNumber";
    visuals.nvim-cursorline = {
      enable = true;
      setupOpts = {
        cursorline = {
          enable = true;
          timeout = 500;
#           cursorword.hl.underline = true;
        };
      };
    };

    # dashboard.dashboard-nvim.enable = true;

    # UI enhancements
    statusline.lualine = {
      enable = true;
      theme = "palenight";
    };

    binds.whichKey = {
        enable = true;
        setupOpts.notify = true;
        setupOpts.preset = "helix"; # classic, modern, helix
        setupOpts.win.border = "rounded";
    };

    tabline.nvimBufferline = {
      enable = true;
      mappings = {
        cycleNext = " bn";
        cyclePrevious = " bp";
        pick = " bc";
      };
      setupOpts.options = {
        mode = "buffers";  # tabs, buffers
        close_icon = "";
        color_icons = true ;
        indicator.style = "icon"; # icon, underline, none
      };
    };

    telescope = {
      enable = true;
      setupOpts = {
        defaults.color_devicons = true;
#         pickers.find_files.find_command = ["h" "j" "k" "l" ";" "u" "n"];
        pickers.find_files.find_command = ["${pkgs.fd}/bin/fd" "--type=file"];
      };
    };

#     filetree.nvimTree = {
#       enable = true;
#       mappings.toggle = " t";
#       setupOpts = {
#         hijack_cursor = true;
#         actions.open_file.window_picker = {
#           enable = true;
#           chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
#           exclude.buftype = [
#             "nofile"
#             "terminal"
#             "help"
#           ];
#           exclude.filetype = [
#             "notify"
#             "packer"
#             "qf"
#             "diff"
#             "fugitive"
#             "fugitiveblame"
#           ];
#
#         };
#       };
#     };

#     Oil------------------------
#     utility.oil-nvim = {
#       enable = true;
#     };

    # yazi ----------------------
    utility.yazi-nvim = {
      enable = true;
    };

    # Notify
    notify.nvim-notify = {
      enable = true;
      setupOpts = {
        timeout = 2500;
        render = "compact";     # “default”, “minimal”, “simple”, “compact”, “wrapped-compact” or (luaInline)
        position = "top_right"; # “top_left”, “top_right”, “bottom_left”, “bottom_right”
        icons = {
          DEBUG = "";
          ERROR = "";
          INFO = "";
          TRACE = "";
          WARN = "";
        };
        background_colour = "background_colour"; # try to find any other values
        stages = "fade_in_slide_out";
      };
    };

    # Fidgit
    visuals.fidget-nvim = {
      enable = true;
    };

    # Editor features
    autopairs.nvim-autopairs.enable = true;
    comments.comment-nvim.enable = true;

    clipboard = {
      enable = true;
    };

    autocomplete.blink-cmp = {
      enable = true;
      friendly-snippets.enable = true;
    };

    git.gitsigns.enable = true;
    utility.motion.hop.enable = true;    # Quick navigation
    utility.surround.enable = true;
    fzf-lua = {
      enable = true;
      profile = "telescope";
    };

    # Terminal integration
    terminal.toggleterm = {
      enable = true; # might not need afte snacks being used
      setupOpts.direction = "float"; # -----next change
    };

    # Language support
    lsp.enable = true;
    languages = {
      enableTreesitter = true;
      enableFormat = true;

      nix.enable = true;
      nix.lsp.servers = [ "nixd" ];
      clang.enable = true;
      rust.enable = true;
      python.enable = true;
      markdown.enable = true;
    };

    debugger.nvim-dap = {
      enable = true;       # Enable Debug Adapter Protocol
      ui.enable = true;    # Enable DAP UI (nvim-dap-ui)
    };
  };
}
