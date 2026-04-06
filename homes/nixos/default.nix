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
    vscode
    spotify
    neovim
    obs-studio
    fastfetch

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
    wine
    winetricks
    bottles
    scanmem
    pince
  ];

  # Waybar
  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        mode = "dock";
        height = 48;
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        ipc = true;
        fixed-center = true;
        margin-top = 5;
        margin-left = 5;
        margin-right = 5;
        margin-bottom = 0;

        modules-left = [
          "group/gleft1"
          "hyprland/window"
        ];
        modules-center = [
          "hyprland/workspaces"
          "mpris"
        ];
        modules-right = [
          "group/gright1"
          "clock"
          "group/gright2"
        ];

        "group/gleft1" = {
          orientation = "horizontal";
          modules = [
            "custom/icon"
            "cpu"
            "memory"
            "temperature"
          ];
        };

        "group/gright1" = {
          orientation = "horizontal";
          modules = [
            "battery"
            "backlight"
            "pulseaudio"
            "network"
          ];
        };

        "group/gright2" = {
          orientation = "horizontal";
          modules = [
            "tray"
            "custom/notification"
            "custom/power"
          ];
        };

        "custom/icon" = {
          format = " ";
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        "custom/power" = {
          format = "⏻";
          on-click = "wlogout -b 4";
          interval = 86400;
          tooltip = false;
        };

        "mpris" = {
          format = "{player_icon} {title} - {artist}";
          format-paused = "{status_icon} <i>{title} - {artist}</i>";
          player-icons = {
            default = "▶";
            spotify = "";
            mpv = "󰐹";
            vlc = "󰕼";
            firefox = "";
          };
          status-icons = {
            paused = "⏸";
            playing = "";
          };
          ignored-players = [ "firefox" ];
          max-length = 30;
        };

        "temperature" = {
          critical-threshold = 88;
          format = "{icon} {temperatureC}°C";
          format-icons = [ "" "" "" ];
          interval = 10;
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          active-only = false;
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            urgent = "";
            active = "";
            default = "";
            sort-by-number = true;
          };
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };

        "hyprland/window" = {
          format = "  {}";
          separate-outputs = true;
          rewrite = {
            "(.*) — Mozilla Firefox" = "$1 󰈹";
            "(.*)Mozilla Firefox" = "Firefox 󰈹";
            "(.*) - Visual Studio Code" = "$1 󰨞";
            "(.*)Visual Studio Code" = "Code 󰨞";
            "(.*)Spotify" = "Spotify 󰓇";
            "(.*)Steam" = "Steam 󰓓";
          };
          max-length = 60;
        };

        "clock" = {
          format = "{:%a %d %b %R}";
          format-alt = "{:%a %d %b %I:%M %p}";
          tooltip-format = "<tt><big>{calendar}</big></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b>{}</b></span>";
            };
          };
        };

        "cpu" = {
          interval = 10;
          format = "󰍛 {usage}%";
        };

        "memory" = {
          interval = 30;
          format = "󰾆 {percentage}%";
          format-alt = "󰾅 {used}GB";
          max-length = 10;
          tooltip = true;
          tooltip-format = " {used:.1f}GB/{total:.1f}GB";
        };

        "backlight" = {
          format = "{icon} {percent}%";
          format-icons = [ "" "" "" "" "" "" "" ];
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 2%+";
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 2%-";
        };

        "network" = {
          format-wifi = "📡 {essid}";
          format-ethernet = "󱘖 Wired";
          format-linked = "󱘖 {ifname} (No IP)";
          format-disconnected = "󰤮 Disconnected";
          tooltip-format = "󱘖 {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
          interval = 5;
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = " ";
          on-click = "pavucontrol -t 3";
          tooltip-format = "{icon} {desc} // {volume}%";
          scroll-step = 4;
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
        };

        "tray" = {
          icon-size = 20;
          spacing = 5;
        };

        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };
      }
    ];

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 16px;
        border: none;
        border-radius: 0px;
        min-height: 0;
        margin: 0px;
        padding: 0px;
      }

      @define-color base   #1a2a1a;
      @define-color mantle #151f15;
      @define-color crust  #101810;

      @define-color text     #c8d5c8;
      @define-color subtext0 #8a9a8a;
      @define-color subtext1 #a0b0a0;

      @define-color surface0 #2d4a2d;
      @define-color surface1 #3a5a3a;
      @define-color surface2 #4a6a4a;

      @define-color overlay0 #4a5a4a;
      @define-color overlay1 #5a6a5a;
      @define-color overlay2 #6a7a6a;

      @define-color blue      #4a8a7a;
      @define-color lavender  #5a9a5a;
      @define-color sapphire  #7a9a8a;
      @define-color sky       #a0a870;
      @define-color teal      #c05a5a;
      @define-color green     #8a7a9a;
      @define-color yellow    #5a8a8a;
      @define-color peach     #fab387;
      @define-color maroon    #a07070;
      @define-color red       #b0a898;
      @define-color mauve     #7a9a8a;
      @define-color pink      #8a7a9a;
      @define-color flamingo  #9a8a8a;
      @define-color rosewater #b0a898;

      @define-color theme_base_color #1a2a1a;

      window#waybar {
        background: transparent;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #gleft1, #gright1 {
        padding: 0px 0px 0px 5px;
        margin: 6px 10px 2px 3px;
        border: 3px solid rgba(14, 14, 14, .1);
        border-radius: 30px;
        background: @theme_base_color;
        box-shadow: 0 0 2px rgba(0, 0, 0, 0.6);
        transition: all .3s ease;
        min-width: 120px;
      }

      #gright2 {
        margin: 6px 10px 2px 3px;
        border: 3px solid rgba(14, 14, 14, .1);
        border-radius: 30px;
        background: @theme_base_color;
        box-shadow: 0 0 2px rgba(0, 0, 0, 0.6);
        padding: 0px 0px 0px 5px;
        transition: all .3s ease;
      }

      #window {
        padding: 0px;
        margin: 6px 10px 2px 3px;
        border: 3px solid rgba(14, 14, 14, .1);
        border-radius: 30px;
        padding: 0px 8px;
        color: @mauve;
        background: @theme_base_color;
      }

      #workspaces {
        background: @theme_base_color;
        margin: 5px 5px;
        padding: 8px 5px;
        border-radius: 30px;
        color: @mauve;
      }

      #workspaces button {
        padding: 0px 5px;
        margin: 0px 3px;
        border-radius: 30px;
        color: @teal;
        background: transparent;
        transition: all 0.3s ease-in-out;
      }

      #workspaces button.active {
        background-color: @teal;
        color: @teal;
        border-radius: 16px;
        min-width: 50px;
        transition: all 0.3s ease-in-out;
      }

      #workspaces button:hover {
        background-color: @maroon;
        color: @maroon;
        border-radius: 16px;
        min-width: 50px;
      }

      #workspaces button.urgent {
        color: @red;
        border-radius: 0px;
      }

      #temperature {
        color: @teal;
        padding-left: 5px;
        padding-right: 5px;
      }

      #temperature.critical {
        background-color: @red;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }
      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }

      #clock {
        color: @yellow;
        background: @theme_base_color;
        margin: 6px 10px 2px 2px;
        border-radius: 30px;
        padding-left: 5px;
        padding-right: 5px;
        transition: all .3s ease;
      }

      #custom-icon {
        font-size: 20px;
        padding-left: 2px;
        padding-right: 5px;
        color: @mauve;
      }

      #cpu {
        color: @yellow;
        font-size: 15px;
        padding-left: 5px;
        padding-right: 5px;
      }

      #memory {
        color: @green;
        font-size: 15px;
        padding-left: 5px;
        padding-right: 5px;
      }

      #battery {
        color: #a6da95;
        padding-left: 5px;
        padding-right: 5px;
      }

      @keyframes blink {
        to { color: @surface0; }
      }

      #battery.critical:not(.charging) {
        background-color: @red;
        color: @text;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #custom-notification {
        color: #dfdfdf;
        padding: 0px 5px;
        border-radius: 5px;
      }

      #backlight {
        color: @rosewater;
        padding-left: 5px;
        padding-right: 5px;
      }

      #pulseaudio {
        color: @sapphire;
        padding-left: 5px;
        padding-right: 5px;
      }

      #pulseaudio.bluetooth {
        color: @pink;
        background: @theme_base_color;
      }

      #pulseaudio.muted {
        color: @red;
      }

      #network {
        color: #EE2091;
        padding-left: 5px;
        padding-right: 5px;
      }

      #network.disconnected,
      #network.disabled {
        background-color: @surface0;
        color: @text;
      }

      #mpris {
        color: @pink;
        background: @theme_base_color;
        margin: 6px 10px 2px 2px;
        border-radius: 30px;
        padding-left: 5px;
        padding-right: 5px;
        transition: all .3s ease;
      }

      #custom-power {
        color: @red;
        padding-left: 5px;
        padding-right: 5px;
      }

      tooltip {
        background: #1e1e2e;
        border-radius: 8px;
      }

      tooltip label {
        color: @text;
        margin-right: 5px;
        margin-left: 5px;
      }
    '';
  };


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
