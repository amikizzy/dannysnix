{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {

  # Add your packages here...
  home.packages = with pkgs; [
    discord
    firefox
    vlc
    nautilus
    vim
    btop
    ghostty
    steam
    rpcs3
    fastfetch
    vscode
    spotify
    neovim

   # Hyprland Specific
    wlr-randr
    pamixer
    brightnessctl
    mpvpaper
    rofi

    # Waybar extras
    pavucontrol
    swaynotificationcenter
    wlogout
    nerd-fonts.jetbrains-mono
    papirus-icon-theme
    starship
    fish
    grim
    slurp
  ];

  # Waybar


  # Rofi
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "${pkgs.ghostty}/bin/ghostty";
    extraConfig = {
      modi = "drun,run";
      show-icons = true;
      icon-theme = "Papirus";
      drun-display-format = "{name}";
      display-drun = "Search Applications...";
      scroll-method = 0;
      disable-history = false;
      sidebar-mode = false;
      columns = 2;
      lines = 9;
    };
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg = mkLiteral "#1a2a1a";
        bg-alt = mkLiteral "#2d4a2d";
        bg-selected = mkLiteral "#4a8a7a";
        fg = mkLiteral "#c8d5c8";
        fg-dim = mkLiteral "#8a9a8a";
        font = "JetBrainsMono Nerd Font 13";
      };
      "window" = {
        background-color = mkLiteral "@bg";
        border = mkLiteral "0px";
        border-radius = mkLiteral "12px";
        padding = mkLiteral "20px";
        width = mkLiteral "700px";
      };
      "mainbox" = {
        background-color = mkLiteral "transparent";
        spacing = mkLiteral "10px";
      };
      "inputbar" = {
        background-color = mkLiteral "@bg-alt";
        border-radius = mkLiteral "8px";
        padding = mkLiteral "10px 14px";
        spacing = mkLiteral "8px";
        children = mkLiteral "[prompt, entry]";
      };
      "prompt" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg-dim";
      };
      "entry" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        placeholder-color = mkLiteral "@fg-dim";
      };
      "listview" = {
        background-color = mkLiteral "transparent";
        columns = 2;
        lines = 9;
        spacing = mkLiteral "6px";
        scrollbar = false;
      };
      "element" = {
        background-color = mkLiteral "transparent";
        border-radius = mkLiteral "8px";
        padding = mkLiteral "8px 10px";
        spacing = mkLiteral "10px";
        orientation = mkLiteral "horizontal";
      };
      "element selected" = {
        background-color = mkLiteral "@bg-selected";
        text-color = mkLiteral "@fg";
      };
      "element-icon" = {
        background-color = mkLiteral "transparent";
        size = mkLiteral "32px";
      };
      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        vertical-align = mkLiteral "0.5";
      };
      "element normal" = {
        text-color = mkLiteral "@fg";
      };
      "element alternate" = {
        background-color = mkLiteral "transparent";
      };
    };
  };

  # Ghostty
  programs.ghostty = {
    enable = true;
    settings = {
      background-opacity = 0.1;
      background-blur-radius = 20;
      keybind = [
      "ctrl+c=copy_to_clipboard"
      "ctrl+shift+c=text:\x03"
      "ctrl+v=paste_from_clipboard"
      ];
    };
  };

  # Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "amikizzy";
        email = "ozrul96@gmail.com";
      };
    };
  };

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    settings = {
      monitor = [
        #"HDMI-A-1,highrr,auto,1"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      general = {
        layout = "master";
        gaps_in = 2;
        gaps_out = 4;
        border_size = 1;
        "col.active_border" = "rgba(ffffffff)";
        "col.inactive_border" = "rgba(000000ff)";
        resize_on_border = true;
        allow_tearing = false;
      };

      decoration = {
        rounding = 0;
        active_opacity = 1;
        inactive_opacity = 1;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          ignore_window = true;
          color = "rgba(20,20,20,0.5)";
        };
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
          ignore_opacity = true;
          new_optimizations = true;
        };
      };

      animations = {
        enabled = true;
        bezier = [ "snap, 0.2, 0, 0, 1" ];
        animation = [
          "windows, 0"
          "layers, 0"
          "fade, 0"
          "border, 0"
          "borderangle, 0"
          "zoomFactor, 0"
          "workspaces, 1, 2, snap, slide"
        ];
      };

      input = {
        kb_layout = "gb";
        touchpad = {
          tap-to-click = false;
          scroll_factor = 1;
          natural_scroll = true;
          clickfinger_behavior = true;
          middle_button_emulation = true;
          disable_while_typing = true;
        };
      };

      cursor = {
        no_warps = true;
      };

      render = {
        direct_scanout = 1;
      };

      misc = {
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
        vfr = true;
        vrr = 0;
        focus_on_activate = true;
      };

      bind = [
        # Core
        "SUPER, S, exec, grim /home/danny/Pictures/screenshot.png"
        "SUPER SHIFT, S, exec, grim -g \"$(slurp)\" /home/danny/Pictures/screenshot.png"
        "SUPER, Return, exec, ghostty"
        "SUPER SHIFT, F, togglefloating"
        "SUPER, E, exec, rofi -show drun"
        "SUPER, Q, killactive"
        "SUPER, F, fullscreen"

        # Workspace Navigation
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # Workspace Manipulation
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        # Window Manipulation
        "SUPER SHIFT, left, layoutmsg, mfact -0.05"
        "SUPER SHIFT, right, layoutmsg, mfact +0.05"
        "SUPER SHIFT, F, togglefloating"

        # Quit
        "SUPER SHIFT, Q, exit"
      ];

      binde = [
        # Volume
        ",XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 2"
        ",XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 2"
        ",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
        ",XF86AudioMicMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source -t"

        # Brightness
        ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%+"
        ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%-"

        # Backlight
        "SUPER, XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl --class leds --device kbd_backlight set 1%+"
        "SUPER, XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl --class leds --device kbd_backlight set 1%-"
      ];

      bindm = [
        "SUPER, mouse:273, resizewindow"
        "SUPER, mouse:272, movewindow"
      ];

      exec-once = [
        "waybar"
        "swaync"
        "${pkgs.mpvpaper}/bin/mpvpaper -o ''no-audio loop'' HDMI-A-1 /home/danny/.config/wallpaper/wallpaper.mp4"
     ];
    };
  };

programs.fish = {
  enable = true;
  interactiveShellInit = ''
    starship init fish | source
  '';
};

programs.starship = {
  enable = true;
  settings = {
    add_newline = false;
    character = {
      success_symbol = "[❯](bold green)";
      error_symbol = "[❯](bold red)";
    };
  };
};

# Do not change this!
  home.stateVersion = "25.11";
}
