{ config, pkgs, ... }:
# https://github.com/nix-community/nixGL/issues/114#issuecomment-1732228827
### This seems to cause destop not to appear in dmenu
let
  nixGL = import <nixgl> { };
  nixGLWrap = pkg:
    let
      bin = "${pkg}/bin";
      executables = builtins.attrNames (builtins.readDir bin);
    in pkgs.buildEnv {
      name = "nixGL-${pkg.name}";
      paths = map (name:
        pkgs.writeShellScriptBin name ''
          exec -a "$0" ${nixGL.auto.nixGLDefault}/bin/nixGL ${bin}/${name} "$@"
        '') executables;
    };
in {
  imports = [ ./packages.nix ./nvim.nix ./hyprland.nix ];
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
      TK_THEME = "Gruvbox-Dark-BL";
      # In order for nautilus to be able to use gvfs mounts
      GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
      MANPAGER = "nvim +Man!";
      GOPRIVATE = "git.vizitec.com";
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    rofi = {
      package = pkgs.rofi-wayland;
      enable = true;
      theme = "gruvbox-dark";
      extraConfig = { font = "DejaVu Sans 20"; };
      # TODO put rofi config into flake - https://github.com/adi1090x/rofi
      configPath = "$XDG_CONFIG_HOME/rofi/config_hm.rasi";
      plugins = with pkgs; [
        rofi-vpn
        rofi-bluetooth
        rofi-pulse-select
        rofi-emoji
      ];
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
    browserpass = {
      enable = true;
      browsers = [ "chromium" "chrome" ];
    };
    chromium = {
      enable = true;
      package = nixGLWrap pkgs.chromium;
    };
    kitty = {
      package = nixGLWrap pkgs.kitty;
      enable = true;
      shellIntegration = { enableZshIntegration = true; };
      extraConfig = "background_opacity 0.8";
      theme = "Gruvbox Dark";
      font = {
        name = "FiraCode Nerd Font Mono";
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
      modulesRight = [ "vi-mode" ];
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
      syntaxHighlighting = { enable = true; };
      zplug = {
        enable = true;
        plugins = [{ name = "jeffreytse/zsh-vi-mode"; }];
      };
      oh-my-zsh = { enable = true; };
    };
  };

  services = {
    swayidle = {
      enable = true;
      events = [{
        event = "before-sleep";
        command = "swaylock -f --grace-no-mouse";
      }];
      timeouts = [
        {
          timeout = 300;
          command = "swaylock -fF --fade-in 1 --grace-no-mouse";
        }
        {
          timeout = 600;
          command = "hyprctl dispatch dpms off";
          resumeCommand = "hyprctl dispatch dpms on";
        }

      ];

    };
    dunst.enable = true;
    # fails to find bleman-mechanism service files
    # seems to work if Arch package blueman is isnstalled as swell
    blueman-applet.enable = true;
    kdeconnect = {
      enable = true;
      indicator = true;

    };
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
      pinentryFlavor = "gnome3";
    };

    gnome-keyring = {
      enable = true;
      components = [ "secrets" ];
    };
    #	mpd = {
    #		enable = true;
    #	};
  };
  gtk = {
    enable = true;
    gtk3 = { extraConfig = { gtk-application-prefer-dark-theme = true; }; };
    gtk4 = { extraConfig = { gtk-application-prefer-dark-theme = true; }; };
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
      "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
    };
  };

}
