{ config, pkgs, ... }:

# https://github.com/nix-community/nixGL/issues/114#issuecomment-1732228827
### This seems to cause destop not to appear in dmenu
let nixGL = import <nixgl> { }; nixGLWrap = pkg:
let
  bin = "${pkg}/bin";
  executables = builtins.attrNames (builtins.readDir bin);
in
  pkgs.buildEnv {
    name = "nixGL-${pkg.name}";
    paths = map
    (name: pkgs.writeShellScriptBin name ''
    exec -a "$0" ${nixGL.auto.nixGLDefault}/bin/nixGL ${bin}/${name} "$@"
    '')
    executables;
  };
in
  {
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };
    targets.genericLinux.enable = true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.shellAliases = {
    "ls" = "ls --color=auto --hyperlink $@";
    "s" = "kitten ssh";
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.htop
    pkgs.dig
    pkgs.more
    pkgs.obsidian
    pkgs.vscode
    pkgs.spotify
    (nixGLWrap pkgs.android-studio)
    (nixGLWrap pkgs.google-chrome)
    pkgs.wtype
    pkgs.pwgen
    pkgs.strace
    pkgs.roboto-mono
    pkgs.noto-fonts-emoji
    pkgs.nerdfonts
    pkgs.pw-volume
    pkgs.winbox
    pkgs.dconf
    pkgs.unixtools.route
    pkgs.remmina
    pkgs.sshfs
    pkgs.gimp
    pkgs.feh
    pkgs.ranger
    pkgs.calibre
    pkgs.hostname
    pkgs.libfido2
    (nixGLWrap pkgs.whatsapp-for-linux)
    (nixGLWrap pkgs.openscad)
    ### DEV --->
    pkgs.trivy
    pkgs.flutter
    pkgs.tree-sitter
    ### <--- DEV
    ### HYPRLAND --->
    pkgs.wlr-randr
    pkgs.pass-wayland
    pkgs.hyprpaper
    pkgs.wofi-emoji
    pkgs.wl-clipboard
    pkgs.gnome.nautilus
    pkgs.gnome.gnome-calculator
    pkgs.gnome.gnome-sound-recorder
    pkgs.gnome.dconf-editor
    pkgs.gnome.gnome-tweaks
    pkgs.gnome.gvfs
    pkgs.gtk-engine-murrine
    # swaylock-effects => couldn't login, has to do with PAM
    pkgs.wlogout
    pkgs.dunst
    pkgs.pavucontrol
    ### <--- HYPERLAND
    #xdg-desktop-portal-hyprland
    #subversion
    #perl
    #git
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ntsanov/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home = {
    homeDirectory = "/home/ntsanov";
    username = "ntsanov";
    sessionVariables = {
  #     TERM = "xterm-256color";
  CHROME_EXECUTABLE = "google-chrome-stable";
  PATH = "$PATH:$HOME/.local/bin:$HOME/go/bin";
       # gtk4 applications need this to use the gtk theme
       TK_THEME="Gruvbox-Dark-BL";
       # In order for nautilus to be able to use gvfs mounts
       GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
       MANPAGER = "nvim +Man!";
     };
   };

   wayland.windowManager.hyprland = {
     enable = true;
     systemd = {
       enable = true;
     };
     extraConfig = ''
     source=~/.config/hypr/monitors.conf
     $mainMod = SUPER
     '';
     settings = {
       exec-once = [
         "waybar"
         "nm-applet"
         "start_portal.sh"
         "hyprpaper"
         "/usr/lib/polkit-kde-authentication-agent-1"
       ];
       input = {
         kb_layout = "us,bg";
         kb_variant = ",phonetic";
         kb_options = "grp:caps_toggle";
       };
       windowrule = [
         "float,org.kde.polkit-kde-authentication-agent-1"
         "float,org.gnome.Calculator"
         "float,pavucontrol"
       ];
       bind = [

         "$mainMod, Q, exec, kitty"
         "$mainMod, C, killactive"
         "$mainMod, M, exec, powermenu"
         "$mainMod, E, exec, nautilus"
         "$mainMod, T, togglefloating"
         "$mainMod, R, exec, rofi-launcher"
         "$mainMod, P, exec, rofi-pass"
         "$mainMod, A, togglesplit" # dwindle
         "$mainMod, S, exec,rofi -show ssh"
          # Sound
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, pw-volume mute toggle; pkill -RTMIN+8 waybar"
          # Screenshots
          "SHIFT, Print, exec, hyprshot -m region -r | satty -f - "
          ", Print, exec, hyprshot -m region --clipboard-only"
          "=CTRL, Print, exec, hyprshot -m window --clipboard-only"
          "=CTRLSHIFT, Print, exec, hyprshot -m window -r | satty -f -"
          # Power
          "$mainMod SHIFT, L, exec, wlogout"
          # Move window with keyboard
          "$mainMod SHIFT, H, movewindow, l"
          "$mainMod SHIFT, L, movewindow, r"
          "$mainMod SHIFT, K, movewindow, u"
          "$mainMod SHIFT, J, movewindow, d"
          "$mainMod SHIFT, left, movewindow, l"
          "$mainMod SHIFT, right, movewindow, r"
          "$mainMod SHIFT, up, movewindow, u"
          "$mainMod SHIFT, down, movewindow, d"
          # Resize windows with keyboard
          "$mainMod SHIFT, l, resizeactive, 30 0"
          "$mainMod SHIFT, h, resizeactive, -30 0"
          "$mainMod SHIFT, j, resizeactive, 0 -30"
          "$mainMod SHIFT, k, resizeactive, 0 30 "
        ];
      };
    };

    programs = {
  # Let Home Manager install and manage itself.
  home-manager.enable = true;
  rofi = {
    package = pkgs.rofi-wayland;
    enable = true;
    theme = "gruvbox-dark";
    extraConfig = {
      font = "DejaVu Sans 20";
    };
    # TODO put rofi config into flake - https://github.com/adi1090x/rofi
    configPath = "$XDG_CONFIG_HOME/rofi/config_hm.rasi";
    pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
      extraConfig = ''
      _clip_in_primary() {
        wl-copy-p
      }

      _clip_in_clipboard() {
        wl-copy
      }

      _clip_out_primary() {
        wl-paste -p
      }

      _clip_out_clipboard() {
        wl-paste
      }
      USERNAME_field='username'
      EDITOR="kitty vi"
      clip=both
      edit_new_pass="true"
      default_do='copyPass'
      clibpoard_backend=wl-clipboard
      backend=wtype
      '';
    };
  };
  go = {
    enable = true;
    goBin = "go/bin";
  };
  neovim = 
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    #requireSetup = str: "lua << EOF\nrequire(\"${str}\").setup()\nEOF\n";
    requireSetup = name: config: toLua "require(\"${name}\").setup(${config})";
    requireDefaultSetup = name: requireSetup "${name}" "{}";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in
  {
    enable=true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with  pkgs; [
      # Optional dependencies for telescope
      ripgrep
      fd
      lua-language-server
      marksman
      ansible-language-server
      openscad-lsp
      pgformatter
      stylua
      shfmt
      # sqlls - not in nix packges at this moment
      nodePackages.bash-language-server
      nodePackages_latest.vscode-langservers-extracted
      nodePackages.typescript-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.yaml-language-server
      nodePackages.pyright
      nodePackages.vls
    ];
    extraConfig = 
    ''
    set clipboard=unnamedplus
    nnoremap <A-l> :tabNext<CR>
    nnoremap <A-h> :tabprevious<CR>
    nnoremap <A-1> :1tabnext<CR>
    nnoremap <A-2> :2tabnext<CR>
    nnoremap <A-3> :3tabnext<CR>
    nnoremap <A-4> :4tabnext<CR>
    nnoremap <A-5> :5tabnext<CR>
    nnoremap <A-6> :6tabnext<CR>
    nnoremap <A-7> :7tabnext<CR>
    nnoremap <A-8> :8tabnext<CR>
    nnoremap <A-9> :9tabnext<CR>
    nnoremap <leader>w :tabclose<CR>
    nnoremap <leader>tt :NvimTreeToggle<CR>
    nnoremap <leader>tf :NvimTreeFocus<CR>
    nnoremap <leader>tc :NvimTreeClose<CR>
    '';
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-go  
      plenary-nvim
      # nvim-cmp dependencies
      cmp-path
      cmp-buffer
      cmp-nvim-lsp
      cmp-cmdline
      nvim-cmp
      {
        plugin = formatter-nvim;
        config = toLuaFile ./nvim/plugin/formatter.lua;
      }
      {
        plugin = telescope-nvim;
        config = toLuaFile ./nvim/plugin/telescope.lua;
      }
      # {
      #   plugin = coc-nvim;
      #   config = toLuaFile ./nvim/plugin/coc.lua;
      # }
      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./nvim/plugin/lspconfig.lua;
      }
      {
        plugin = nvim-treesitter;
        config = toLuaFile ./nvim/plugin/tree-splitter.lua;
      }
      {
        plugin = lualine-nvim;
        config = toLuaFile ./nvim/plugin/lualine.lua;
      }
      {
        plugin = nvim-tree-lua;
        config = requireDefaultSetup "nvim-tree";
      }
      {
        plugin = dashboard-nvim;
        config = requireDefaultSetup "dashboard";
      }
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
        p.go
        p.gosum
        p.gowork
        p.gomod
        p.python
        p.bash
        p.rust
        p.json
        p.javascript
        p.c
        p.nix
        p.vim
        p.vimdoc
        # p.sql - causes buffer overflow 
        p.lua
        p.css
        p.html
        p.css
        p.awk
        p.yaml
        p.toml
        p.make
        p.regex
        p.pem
        p.gitignore
        p.gitcommit
      ]))
      {
        plugin = nvim-surround;
        config = requireDefaultSetup "nvim-surround";
      }
      {
        plugin = comment-nvim;
        config = requireDefaultSetup "Comment";
      }
      {
        plugin = gruvbox-nvim;
        config = "colorscheme gruvbox";
      }
      nvim-web-devicons
    ];
  };
  browserpass = {
    enable = true;
    browsers = [ 
      "chromium"
      "chrome"
    ];
  };
  # chromium = {
  #   enable = true;
  #   package = nixGLWrap pkgs.chromium;
  # };
  kitty = {
    package = nixGLWrap pkgs.kitty;
    enable = true;
    shellIntegration = {
      enableZshIntegration = true;
    };
    extraConfig = "background_opacity 0.8";
    theme = "Gruvbox Dark";
    font = {
      name = "DejaVu Sans";
      size = 13;
    };
  };
  powerline-go = {
    enable = true;
    newline = true;
    settings = {
      hostname-only-if-ssh = true;
      vi-mode = "viins";
      # Gruvbox looks horrible
      #theme = "solarized-dark16";
    };
    modulesRight = [
      "vi-mode"
    ];
  };
  wofi = {
    enable = true;
    settings = {
      allow_markup = true;
      allow_images = true;
      image_size = 64;
    };
  };
  zsh = {
    enable = true;
    defaultKeymap = "viins";
    enableAutosuggestions = true;
    syntaxHighlighting = {
      enable = true;
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "jeffreytse/zsh-vi-mode"; }
      ];
    };
    oh-my-zsh = {
      enable = true;
    };
  };
#    waybar = {
#      enable = true;
#      settings = {
#        mainBar = {
#          layer = "top";
#          height = 30;
#	};
#      };
#    };

  };

  services = {
    swayidle = {
      enable = true;
      events = [
        { event = "before-sleep"; command = "swaylock -f --grace-no-mouse"; }
      ];
      timeouts = [
        { timeout = 300; command = "swaylock -fF --fade-in 1 --grace-no-mouse"; }
        { timeout = 600; command = "hyprctl dispatch dpms off"; resumeCommand = "hyprctl dispatch dpms on"; }

      ];

    };
    dunst = {
      enable = true;
    };
    kdeconnect = {
      enable = true;
      indicator = true;

    };
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    gnome-keyring = {
      enable = true;
      components = [
        "secrets"
      ];
    };
#	mpd = {
#		enable = true;
#	};
  };
  gtk = {
    enable = true;
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
    theme = {
      # gruvbox-gtk-theme-unstable
      # orchis-theme
      name = "Gruvbox-Dark-BL";
      package = pkgs.gruvbox-gtk-theme;
    };
    iconTheme = {
      name = "Tela-circle";
      #package = pkgs.gnome.adwaita-icon-theme;
      package = pkgs.tela-circle-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita:dark";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

}
