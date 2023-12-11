{ config, ... }: {

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  ### TODO needs waybar-hyprland
  ### at the moment it is not available as nix package(maybe flake)
  # programs.waybar = {
  #   enable = true;
  #   systemd.enable = true;
  # };
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    settings = {
      source = [ "~/.config/hypr/monitors.conf" ];
      exec-once = [
        "nm-applet"
        "start_portal.sh"
        "hyprpaper"
        "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
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
        "float,solaar"
      ];
      "$mainMod" = "SUPER";
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
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

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
      ];
    };
  };
}
