{ pkgs, myScripts, config, ... }:
let
  scripts = myScripts.hyprland;
in
{
  home.packages = with pkgs; [
    grimblast
    hyprpicker
    cliphist
    wl-clipboard
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    extraConfig = ''
      exec-once=${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1 &
      exec-once=${pkgs.waybar}/bin/waybar
      exec-once=${pkgs.dunst}/bin/dunst
      exec-once=${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store
      exec-once=${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store
      # exec-once=${pkgs.swaybg}/bin/swaybg --mode fill --image ${../../../wallpapers/sunset-1920x1080.jpg}

      windowrule = float, class:*.pavucontrol
      windowrule = float, class:wlogout
      windowrule = move 0 0, class:wlogout
      windowrule = size 100% 100%, class:wlogout
      windowrule = animation slide, class:wlogout

      windowrule = float, class:my-fzf-menu
      windowrule = center, class:my-fzf-menu

      windowrule = float, title:^(Picture-in-Picture)$
      windowrule = fullscreenstate * 2, class:^(typst-preview)$

      workspace = HDMI-A-1,1
      workspace = HDMI-A-2,2
      workspace = HDMI-A-3,3
      workspace = eDP-1,4
      workspace = eDP-1,5
      workspace = eDP-1,6
      workspace = eDP-1,7
      workspace = eDP-1,8
      workspace = eDP-1,9

      $mainMod=SUPER
      $launcher=${scripts.launcher}/bin/launcher
      $browser=${pkgs.librewolf}/bin/librewolf
      $gamemode=${scripts.gamemode}/bin/gamemode
      $colorPicker=${scripts.colorPicker}/bin/colorpicker
      $volume=${pkgs.pw-volume}/bin/pw-volume
      $brightness=${scripts.brightness}/bin/brightness
      $playerctl=${pkgs.playerctl}/bin/playerctl
      $lock=${pkgs.swaylock}/bin/swaylock -f
      $wlogout=${scripts.wlogout}/bin/wlogout
      $music=${pkgs.spotifywm}/bin/spotify
      $discord=${pkgs.discord}/bin/discord
      $grimblast=${pkgs.grimblast}/bin/grimblast
      $passage=${scripts.passage-fzf}/bin/passage-fzf-type

      bind=$mainMod,delete,exit
      bind=$mainMod_SHIFT,q,exec,$wlogout
      bind=$mainMod,return,exec,wezterm start --always-new-process
      bind=$mainMod,b,exec,[workspace 2] $browser
      bind=$mainMod_SHIFT,f,fullscreenstate,* 2
      bind=$mainMod,f,fullscreen,0
      # bind=$mainMod,e,exec,xplr # TODO: do something fancy with xplr
      bind=$mainMod,t,togglefloating
      bind=$mainMod,j,cyclenext,prev
      bind=$mainMod,k,cyclenext,
      bind=$mainMod,l,exec,$lock
      bind=$mainMod_SHIFT,o,exec,$colorPicker
      bind=$mainMod,space,exec,$launcher
      bind=$mainMod,y,exec,[workspace special:trash] $music
      bind=$mainMod,d,exec,[workspace special:discord] $discord

      bind=$mainMod,i,exec,$passage

      bind=$mainMod,g,togglegroup
      bind=$mainMod,tab,changegroupactive
      bind=$mainMod_CTRL,g,moveoutofgroup
      bind=$mainMod_ALT,g,lockactivegroup,toggle
      bind=$mainMod_SHIFT,g,submap,group
      submap=group
      bind=,j,moveintogroup,d
      bind=,j,submap,reset
      bind=,k,moveintogroup,u
      bind=,k,submap,reset
      bind=,l,moveintogroup,r
      bind=,l,submap,reset
      bind=,h,moveintogroup,l
      bind=,h,submap,reset
      bind=,escape,submap,reset
      submap=reset

      bind = SUPER, p, exec, $grimblast save active
      bind = SUPER ALT, p, exec, $grimblast copy active
      bind = SUPER SHIFT, p, exec, $grimblast save area
      bind = SUPER SHIFT ALT, p, exec, $grimblast copy area
      bind = SUPER CTRL, p, exec, $grimblast save screen
      bind = SUPER CTRL ALT, p, exec, $grimblast copy screen

      bind=$mainMod,equal,submap,volume
      submap=volume
      bind=,equal,exec,$volume change +2.5%; pkill -RTMIN+8 waybar
      bind=,minus,exec,$volume change -2.5%; pkill -RTMIN+8 waybar
      bind=,k,exec,$volume change +2.5%; pkill -RTMIN+8 waybar
      bind=,j,exec,$volume change -2.5%; pkill -RTMIN+8 waybar
      bind=,up,exec,$volume change +2.5%; pkill -RTMIN+8 waybar
      bind=,down,exec,$volume change -2.5%; pkill -RTMIN+8 waybar
      bind=,braceleft,exec,$volume mute toggle; pkill -RTMIN+8 waybar
      # bind=,bracketright,exec,$volume --toggle-mic
      bind=,escape,submap,reset
      submap=reset

      # Volume Keys
      bindl=,xf86audioraisevolume,exec,$volume change +2.5%; pkill -RTMIN+8 waybar
      bindl=,xf86audiolowervolume,exec,$volume change -2.5%; pkill -RTMIN+8 waybar
      bindl=,xf86audiomute,exec,$volume mute toggle; pkill -RTMIN+8 waybar
      bindl=,xf86monbrightnessup,exec,$brightness --inc
      bindl=,xf86monbrightnessdown,exec,$brightness --dec
      bindl=,xf86audioplay,exec,$playerctl play-pause
      bindl=,xf86audionext,exec,$playerctl next
      bindl=,xf86audioprev,exec,$playerctl previous

      # Resize
      bind = $mainMod SHIFT, R, submap, resize
      submap = resize
      binde = , h, resizeactive,-50 0
      binde = , l, resizeactive,50 0
      binde = , k, resizeactive,0 -50
      binde = , j, resizeactive,0 50
      binde = , left, resizeactive,-50 0
      binde = , right, resizeactive,50 0
      binde = , up, resizeactive,0 -50
      binde = , down, resizeactive,0 50
      bind = , escape, submap, reset
      submap = reset

      # Move
      bind = $mainMod SHIFT, M, submap, move
      submap = move
      bind = , h, movewindow, l
      bind = , l, movewindow, r
      bind = , k, movewindow, u
      bind = , j, movewindow, d
      bind = , left, movewindow, l
      bind = , right, movewindow, r
      bind = , up, movewindow, u
      bind = , down, movewindow, d
      # bind = , period, exec, hyprctl dispatch movewindow mon:0
      # bind = , comma, exec, hyprctl dispatch movewindow mon:1
      bind = , escape, submap, reset
      submap = reset

      # Focus
      bind = $mainMod ALT, F, submap, focus
      submap = focus
      bind = , left, movefocus, l
      bind = , right, movefocus, r
      bind = , up, movefocus, u
      bind = , down, movefocus, d
      bind = , h, movefocus, l
      bind = , l, movefocus, r
      bind = , k, movefocus, u
      bind = , j, movefocus, d
      bind = , escape, submap, reset
      submap = reset

      # Preselection split ONLY IN DWINDLE mode
      bind = $mainMod, S, submap, split
      submap = split
      bind = , j, exec, hyprctl dispatch layoutmsg "preselect d"
      bind = , j, submap, reset
      bind = , k, exec, hyprctl dispatch layoutmsg "preselect u"
      bind = , k, submap, reset
      bind = , l, exec, hyprctl dispatch layoutmsg "preselect r"
      bind = , l, submap, reset
      bind = , h, exec, hyprctl dispatch layoutmsg "preselect l"
      bind = , h, submap, reset
      bind = , escape, submap, reset
      submap = reset

      # Special workspace
      bind = $mainMod SHIFT, U, movetoworkspace, special
      bind = $mainMod, U, togglespecialworkspace,
      bind = $mainMod SHIFT, Backspace, movetoworkspace, special:work
      bind = $mainMod, Backspace, togglespecialworkspace, work
      bind = $mainMod SHIFT, parenright, movetoworkspace, special:trash
      bind = $mainMod, parenright, togglespecialworkspace, trash
      bind = $mainMod SHIFT, minus, movetoworkspace, special:discord
      bind = $mainMod, minus, togglespecialworkspace, discord

      # Bypass global keybinds to pass binds directly to application (eg: VMs)
      bind = $mainMod CTRL, At, submap, passthru
      submap = passthru
      bind = $mainMod, Escape, submap, reset
      submap = reset

      # workspaces
      # binds $mainMod + [alt|shift + ] {1..10} to [move|(move silently) to] workspace {1..10}
      ${builtins.concatStringsSep "\n" (builtins.genList (
        x: let
          code = builtins.toString (10 + x);
          ws = builtins.toString (x + 1);
        in ''
          bind=$mainMod,code:${code},workspace,${ws}
          bind=$mainMod_ALT,code:${code},movetoworkspace,${ws}
          bind=$mainMod_SHIFT,code:${code},movetoworkspacesilent,${ws}
        ''
      ) 10)}
      bind=$mainMod,at,workspace,empty
      bind=$mainMod_ALT,at,movetoworkspace,empty
      bind=$mainMod,asciicircum,workspace,-1
      bind=$mainMod,dollar,workspace,+1
      bind=$mainMod_ALT,asciicircum,movetoworkspace,-1
      bind=$mainMod_ALT,dollar,movetoworkspace,+1
      bind=$mainMod_SHIFT,asciicircum,movetoworkspacesilent,-1
      bind=$mainMod_SHIFT,dollar,movetoworkspacesilent,+1

      bind=$mainMod, comma, focusmonitor, l
      bind=$mainMod, semicolon, focusmonitor, r
      bind=$mainMod_SHIFT, comma, movecurrentworkspacetomonitor, l
      bind=$mainMod_SHIFT, semicolon, movecurrentworkspacetomonitor, r
      bind=$mainMod_SHIFT, comma, swapactiveworkspaces, l r

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      bind=ALT,tab,exec,hyprctl dispatch focuscurrentorlast
      bind=$mainMod,q,killactive

      bind=$mainMod,F1,exec,$gamemode

      env=NIXOS_OZONE_WL,1
      env=MOZ_ENABLE_WAYLAND,1
      env=WLR_NO_HARDWARE_CURSORS,1
      env=WLR_RENDERER_ALLOW_SOFTWARE,1
      env=GDK_BACKEND,wayland,x11
      env=CLUTTER_BACKEND,wayland

      env=QT_QPA_PLATFORM,wayland
      env=QT_QPA_PLATFORMTHEME,qt5ct
      env=QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env=QT_AUTO_SCREEN_SCALE_FACTOR,1

      env=XDG_CURRENT_DESKTOP,Hyprland
      env=XDG_SESSION_TYPE,wayland
      env=XDG_SESSION_DESKTOP,Hyprland

      monitor=eDP-1,1920x1080@60,0x0,1
      monitor=HDMI-A-1,1366x768@60,-1366x0,1

      dwindle {
        pseudotile=true
        force_split=2
      }

      general {
        gaps_in=2
        gaps_out=5
        border_size=2
      }

      decoration {
        rounding=8
        active_opacity=0.95
        inactive_opacity=0.85
      }

      xwayland {
        force_zero_scaling = true
      }

      animations {
        enabled = yes
        bezier = wind, 0.05, 0.9, 0.1, 1.05
        bezier = winIn, 0.1, 1.1, 0.1, 1.1
        bezier = winOut, 0.3, -0.3, 0, 1
        bezier = liner, 1, 1, 1, 1
        animation = windows, 1, 3, wind, slide
        animation = windowsIn, 1, 3, winIn, slide
        animation = windowsOut, 1, 3, winOut, slide
        animation = windowsMove, 1, 3, wind, slide
        animation = border, 1, 1, liner
        animation = borderangle, 1, 30, liner, loop
        animation = fade, 1, 4, default
        animation = workspaces, 1, 5, wind
      }

      # device:logitech-usb-optical-mouse {
      device {
        name = logitech-usb-optical-mouse
        sensitivity = -0.3
        # accel_profile = custom 200 0.0 0.3 0.8 0.9 0.9
      }
      # device:ydotoold-virtual-device {
      device {
        name = ydotoold-virtual-device
        kb_layout=us
        kb_options=grp:shifts_toggle,caps:swapescape
      }

      input {
        numlock_by_default=true

        repeat_delay=300
        kb_layout=grizz
        kb_options=ctrl:nocaps

        # mouse is independent from keyboard
        follow_mouse=1
        natural_scroll=true

        touchpad {
          disable_while_typing=false
          natural_scroll=true
          scroll_factor=0.2
          clickfinger_behavior=true
          drag_lock=false
          tap-and-drag=false
        }
      }

      group {
        groupbar {
          render_titles = true
          gradients = false
          font_size = 11
          text_color = 0x353741
        }
      }

      misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        mouse_move_enables_dpms = true
        focus_on_activate = true
        allow_session_lock_restore = true
        vfr = true
      }

      render {
        direct_scanout = false
      }

      binds {
        workspace_back_and_forth = true
      }
    '';
  };
}
