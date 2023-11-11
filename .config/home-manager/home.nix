{ config, pkgs, ... }:

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
    "ls" = "ls --color=auto";
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    htop
    dig
    obsidian
    wtype
    pwgen
    strace
    roboto-mono
    noto-fonts-emoji
    nerdfonts
    pw-volume
    winbox
    dconf
    vscode
    spotify
    unixtools.route
    remmina
    sshfs
    gimp
    feh
    ranger
    galculator
    whatsapp-for-linux
    openscad
    ### WORK --->
    trivy
    ### <--- WORK
    ### HYPRLAND --->
    wlr-randr
    pass-wayland
    hyprpaper
    wofi-emoji
    wl-clipboard
    # swaylock-effects => couldn't login, has to do with PAM
    swayidle
    wlogout
    dunst
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
       EDITOR = "nvim";
       TERM= "xterm-256color";
       PATH = "$PATH:$HOME/.local/bin";
     };
  };

  programs = {
  # Let Home Manager install and manage itself.
  home-manager.enable = true;
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
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-go  
      coc-nvim
      coc-go
      coc-sh
      coc-git
      coc-yaml
      coc-toml
      coc-json
      coc-python
      {
        plugin = lualine-nvim;
        config = toLua "require(\"lualine\").setup { options = { theme = \"gruvbox\", }, }";
      }
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
  powerline-go = {
    enable = true;
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
    enableAutosuggestions = true;
    syntaxHighlighting = {
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
    theme = {
      name = "orchis-theme";
      package = pkgs.orchis-theme;
    };
    iconTheme = {
      name = "Tela-circle";
      #package = pkgs.gnome.adwaita-icon-theme;
      package = pkgs.tela-circle-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
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
