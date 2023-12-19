{ pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [
        "electron-25.9.0"
        "openssl-1.1.1w" # Viber
      ];
    };
  };
  home.packages = with pkgs; [
    htop
    inetutils
    lftp
    dig
    more
    obsidian
    vscode
    spotify
    android-studio
    google-chrome
    wtype
    pwgen
    apacheHttpd
    strace
    roboto-mono
    noto-fonts-emoji
    nerdfonts
    pw-volume
    winbox
    dconf
    unixtools.route
    remmina
    sshfs
    gimp
    feh
    ranger
    speedtest-cli
    calibre
    hostname
    libfido2
    whatsapp-for-linux
    viber
    openscad
    ### DEV --->
    trivy
    flutter
    tree-sitter
    ### <--- DEV
    ### HYPRLAND --->
    wlr-randr
    pass-wayland
    hyprpaper
    wofi-emoji
    rofi-bluetooth
    wl-clipboard
    polkit_gnome
    gnome.gnome-bluetooth
    gnome.nautilus
    gnome.gnome-calculator
    gnome.gnome-sound-recorder
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnome.gvfs
    gtk-engine-murrine
    # swaylock-effects => couldn't login, has to do with PAM
    wlogout
    dunst
    pavucontrol
    anydesk
    libsForQt5.dolphin
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
}
