{ pkgs, myScripts, ... }:
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
    configType = "lua";
    extraConfig = /* lua */ ''
      hl.on("hyprland.start", function ()
          hl.exec_cmd("${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1")
          hl.exec_cmd("${pkgs.waybar}/bin/waybar")
          hl.exec_cmd("${pkgs.dunst}/bin/dunst")
          hl.exec_cmd("${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store")
          hl.exec_cmd("${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store")
      end)

      local mainMod = "SUPER"
      local launcher = "${scripts.launcher}/bin/launcher"
      local browser = "${pkgs.librewolf}/bin/librewolf"
      local gamemode = "${scripts.gamemode}/bin/gamemode"
      local colorPicker = "${scripts.colorPicker}/bin/colorpicker"
      local volume = "${pkgs.pw-volume}/bin/pw-volume"
      local brightness = "${scripts.brightness}/bin/brightness"
      local playerctl = "${pkgs.playerctl}/bin/playerctl"
      local lock = "${pkgs.swaylock}/bin/swaylock -f"
      local wlogout = "${pkgs.wlogout}/bin/wlogout"
      local music = "${pkgs.spotifywm}/bin/spotify"
      local discord = "${pkgs.discord}/bin/Discord"
      local grimblast = "${pkgs.grimblast}/bin/grimblast"
      local passage = "${scripts.passage-fzf}/bin/passage-fzf-type"

      hl.bind(mainMod .. " + DELETE", hl.dsp.exit())
      hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd(wlogout))
      hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("wezterm start --always-new-process"))
      hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser, { workspace = "2" }))
      hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen_state({ internal = -1, client = 2, action = "toggle" }))
      hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

      hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + J", hl.dsp.window.cycle_next({ next = false }))
      hl.bind(mainMod .. " + K", hl.dsp.window.cycle_next({ next = true }))
      hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(lock))
      hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd(colorPicker))
      hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(launcher))
      hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd(music, { workspace = "special:trash" }))
      hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(discord, { workspace = "special:discord" }))

      hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(passage))

      hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
      hl.bind(mainMod .. " + TAB", hl.dsp.group.next())
      hl.bind(mainMod .. " + CTRL + G", hl.dsp.window.move({ out_of_group = true }))
      hl.bind(mainMod .. " + ALT + G", hl.dsp.group.lock_active({ action = "toggle" }))
      hl.bind(mainMod .. " + SUPER + G", hl.dsp.submap("group"))
      hl.define_submap("group", function ()
        hl.bind("j", function()
          hl.dsp.window.move({ into_group = "d" })
          hl.dsp.submap("reset")
        end)
        hl.bind("k", function()
          hl.dsp.window.move({ into_group = "u" })
          hl.dsp.submap("reset")
        end)
        hl.bind("l", function()
          hl.dsp.window.move({ into_group = "r" })
          hl.dsp.submap("reset")
        end)
        hl.bind("h", function()
          hl.dsp.window.move({ into_group = "l" })
          hl.dsp.submap("reset")
        end)
        hl.bind("escape", hl.dsp.submap("reset"))
      end)

      hl.bind(mainMod .. " + p", hl.dsp.exec_cmd(grimblast .. " save active"))
      hl.bind(mainMod .. " + ALT + p", hl.dsp.exec_cmd(grimblast .. " copy active"))
      hl.bind(mainMod .. " + SHIFT + p", hl.dsp.exec_cmd(grimblast .. " save area"))
      hl.bind(mainMod .. " + SHIFT + ALT + p", hl.dsp.exec_cmd(grimblast .. " copy area"))
      hl.bind(mainMod .. " + CTRL + p", hl.dsp.exec_cmd(grimblast .. " save screen"))
      hl.bind(mainMod .. " + CTRL + ALT + p", hl.dsp.exec_cmd(grimblast .. " copy screen"))


      hl.bind(mainMod .. " + equal", hl.dsp.submap("volume"))
      hl.define_submap("volume", function()
          hl.bind("equal", hl.dsp.exec_cmd(volume .. " change +2.5%; pkill -RTMIN+8 waybar"))
          hl.bind("minus", hl.dsp.exec_cmd(volume .. " change -2.5%; pkill -RTMIN+8 waybar"))
          hl.bind("k", hl.dsp.exec_cmd(volume .. " change +2.5%; pkill -RTMIN+8 waybar"))
          hl.bind("j", hl.dsp.exec_cmd(volume .. " change -2.5%; pkill -RTMIN+8 waybar"))
          hl.bind("up", hl.dsp.exec_cmd(volume .. " change +2.5%; pkill -RTMIN+8 waybar"))
          hl.bind("down", hl.dsp.exec_cmd(volume .. " change -2.5%; pkill -RTMIN+8 waybar"))
          hl.bind("braceleft", hl.dsp.exec_cmd(volume .. " mute toggle; pkill -RTMIN+8 waybar"))
          -- bind=,bracketright,exec,$volume --toggle-mic
          hl.bind("escape", hl.dsp.submap("reset"))
      end)

      -- Volume Keys
      hl.bind("xf86audioraisevolume", hl.dsp.exec_cmd(volume .. " change +2.5%; pkill -RTMIN+8 waybar"), { locked = true })
      hl.bind("xf86audiolowervolume", hl.dsp.exec_cmd(volume .. " change -2.5%; pkill -RTMIN+8 waybar"), { locked = true })
      hl.bind("xf86audiomute", hl.dsp.exec_cmd(volume .. " mute toggle; pkill -RTMIN+8 waybar"), { locked = true })
      hl.bind("xf86monbrightnessup", hl.dsp.exec_cmd(brightness .. " --inc"), { locked = true })
      hl.bind("xf86monbrightnessdown", hl.dsp.exec_cmd(brightness .. " --dec"), { locked = true })
      hl.bind("xf86audioplay", hl.dsp.exec_cmd(playerctl .. " play-pause"), { locked = true })
      hl.bind("xf86audionext", hl.dsp.exec_cmd(playerctl .. " next"), { locked = true })
      hl.bind("xf86audioprev", hl.dsp.exec_cmd(playerctl .. " previous"), { locked = true })

      -- Resize
      hl.bind(mainMod .. " + SHIFT + R", hl.dsp.submap("resize"))
      hl.define_submap("resize", function()
          hl.bind("h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
          hl.bind("l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
          hl.bind("k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
          hl.bind("j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
          hl.bind("left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
          hl.bind("right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
          hl.bind("up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
          hl.bind("down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
          hl.bind("escape", hl.dsp.submap("reset"))
      end)

      -- Move
      hl.bind(mainMod .. " + SHIFT + M", hl.dsp.submap("move"))
      hl.define_submap("move", function()
          hl.bind("h", hl.dsp.window.move({ direction = "l" }))
          hl.bind("l", hl.dsp.window.move({ direction = "r" }))
          hl.bind("k", hl.dsp.window.move({ direction = "u" }))
          hl.bind("j", hl.dsp.window.move({ direction = "d" }))
          hl.bind("left", hl.dsp.window.move({ direction = "l" }))
          hl.bind("right", hl.dsp.window.move({ direction = "r" }))
          hl.bind("up", hl.dsp.window.move({ direction = "u" }))
          hl.bind("down", hl.dsp.window.move({ direction = "d" }))
          -- bind = , period, exec, hyprctl dispatch movewindow mon:0
          -- bind = , comma, exec, hyprctl dispatch movewindow mon:1
          hl.bind("escape", hl.dsp.submap("reset"))
      end)

      -- Focus
      hl.bind(mainMod .. " + ALT + F", hl.dsp.submap("focus"))
      hl.define_submap("focus", function()
          hl.bind("left", hl.dsp.focus({ direction = "left" }))
          hl.bind("right", hl.dsp.focus({ direction = "right" }))
          hl.bind("up", hl.dsp.focus({ direction = "up" }))
          hl.bind("down", hl.dsp.focus({ direction = "down" }))
          hl.bind("h", hl.dsp.focus({ direction = "left" }))
          hl.bind("l", hl.dsp.focus({ direction = "right" }))
          hl.bind("k", hl.dsp.focus({ direction = "up" }))
          hl.bind("j", hl.dsp.focus({ direction = "down" }))
          hl.bind("escape", hl.dsp.submap("reset"))
      end)

      -- Preselection split ONLY IN DWINDLE mode
      hl.bind(mainMod .. " + S", hl.dsp.submap("split"))
      hl.define_submap("split", function()
          hl.bind("j", function ()
            hl.dsp.layout("\"preselect d\"")
            hl.dsp.submap("reset")
          end)
          hl.bind("k", function ()
            hl.dsp.layout("\"preselect u\"")
            hl.dsp.submap("reset")
          end)
          hl.bind("l", function ()
            hl.dsp.layout("\"preselect r\"")
            hl.dsp.submap("reset")
          end)
          hl.bind("h", function ()
            hl.dsp.layout("\"preselect l\"")
            hl.dsp.submap("reset")
          end)
          hl.bind("escape", hl.dsp.submap("reset"))
      end)

      -- Special workspace
      hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special" }))
      hl.bind(mainMod .. " + U", hl.dsp.workspace.toggle_special(""))
      hl.bind(mainMod .. " + SHIFT + Backspace", hl.dsp.window.move({ workspace = "special:work" }))
      hl.bind(mainMod .. " + Backspace", hl.dsp.workspace.toggle_special("work"))
      hl.bind(mainMod .. " + SHIFT + parenright", hl.dsp.window.move({ workspace = "special:trash" }))
      hl.bind(mainMod .. " + parenright", hl.dsp.workspace.toggle_special("trash"))
      hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "special:discord" }))
      hl.bind(mainMod .. " + minus", hl.dsp.workspace.toggle_special("discord"))

      -- Bypass global keybinds to pass binds directly to application (eg: VMs)
      hl.bind(mainMod .. " + CTRL + At", hl.dsp.submap("passthru"))
      hl.define_submap("passthru", function()
          hl.bind(mainMod .. " + Escape", hl.dsp.submap("reset"))
      end)

      -- workspaces
      -- binds $mainMod + [alt|shift + ] {1..10} to [move|(move silently) to] workspace {1..10}
      ${builtins.concatStringsSep "\n" (builtins.genList (
        x: let
          code = builtins.toString (10 + x);
          ws = builtins.toString (x + 1);
        in ''
          hl.bind(mainMod .. " + code:${code}", hl.dsp.focus({ workspace = ${ws} }))
          hl.bind(mainMod .. " + ALT + code:${code}", hl.dsp.window.move({ workspace = ${ws} }))
          hl.bind(mainMod .. " + SHIFT + code:${code}", hl.dsp.window.move({ workspace = ${ws}, follow = false }))
        ''
      ) 10)}

      hl.bind(mainMod .. " + at", hl.dsp.focus({ workspace = "empty" }))
      hl.bind(mainMod .. " + ALT + at", hl.dsp.window.move({ workspace = "empty" }))
      hl.bind(mainMod .. " + asciicircum", hl.dsp.focus({ workspace = -1 }))
      hl.bind(mainMod .. " + dollar", hl.dsp.focus({ workspace = "+1" }))
      hl.bind(mainMod .. " + ALT + asciicircum", hl.dsp.window.move({ workspace = -1 }))
      hl.bind(mainMod .. " + ALT + dollar", hl.dsp.window.move({ workspace = "+1" }))
      hl.bind(mainMod .. " + SHIFT + asciicircum", hl.dsp.window.move({ workspace = -1, follow = false }))
      hl.bind(mainMod .. " + SHIFT + dollar", hl.dsp.window.move({ workspace = "+1", follow = false }))

      hl.bind(mainMod .. " + comma", hl.dsp.focus({ monitor = "l" }))
      hl.bind(mainMod .. " + semicolon", hl.dsp.focus({ monitor = "r" }))
      hl.bind(mainMod .. " + SHIFT + comma", function() local w = hl.get_active_workspace(); if not w then return end; hl.dsp.workspace.move({ workspace = w.id, monitor = "l" }) end)
      hl.bind(mainMod .. " + SHIFT + semicolon", function() local w = hl.get_active_workspace(); if not w then return end; hl.dsp.workspace.move({ workspace = w.id, monitor = "r" }) end)
      hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.workspace.swap_monitors({ monitor1 = "l", monitor2 = "r" }))

      -- Scroll through existing workspaces with mainMod + scroll
      hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

      hl.bind("ALT + tab", hl.dsp.focus({ last = true }))
      hl.bind(mainMod .. " + q", hl.dsp.window.close())

      hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd(gamemode))

      hl.window_rule({
        name = "Floating-only windows",
        match = {
          class = "pavucontrol|.nkscape|inkstitch|Picture-in-Picture"
        },
        float = true,
      })
      hl.window_rule({
        name = "Floating-only windows",
        match = {
          title = "Picture-in-Picture"
        },
        float = true,
      })
      hl.window_rule({
        name = "wlogout window",
        match = { class = "wlogout" },
        float = true,
        move = {0, 0},
        size = {"100%", "100%"},
        animation = "slide",
      })
      hl.window_rule({
        name = "myfzf-menu",
        match = { class = "my-fzf-menu" },
        float = true,
        center = true,
      })
      hl.window_rule({
        name = "typst preview",
        match = { class = "typst-preview" },
        fullscreen_state = "-1 2"
      })

      hl.workspace_rule({ workspace = "r[1-3]", monitor = "HDMI-A-1" })
      hl.workspace_rule({ workspace = "r[4-9]", monitor = "eDP-1" })

      hl.monitor({
        output = "eDP-1",
        mode = "1920x1080@60",
        position = "0x0",
        scale = 1,
      })
      hl.monitor({
        output = "HDMI-A-1",
        mode = "preferred",
        position = "auto-left",
        scale = 1,
      })

      hl.env("NIXOS_OZONE_WL", "1")
      hl.env("MOZ_ENABLE_WAYLAND", "1")
      hl.env("WLR_NO_HARDWARE_CURSORS", "1")
      hl.env("WLR_RENDERER_ALLOW_SOFTWARE", "1")
      hl.env("GDK_BACKEND", "wayland,x11")
      hl.env("CLUTTER_BACKEND", "wayland")

      hl.env("QT_QPA_PLATFORM", "wayland")
      hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
      hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
      hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

      hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
      hl.env("XDG_SESSION_TYPE", "wayland")
      hl.env("XDG_SESSION_DESKTOP", "Hyprland")

      hl.config({
        decoration = {
          rounding = 8,
          active_opacity = 0.95,
          inactive_opacity = 0.9,
        },
        general = {
          gaps_in = 2,
          gaps_out = 5,
          border_size = 2,
        },

        input = {
          numlock_by_default = true,

          repeat_delay = 300,
          kb_layout = "grizz",
          kb_options = "ctrl:nocaps",

          -- mouse is independent from keyboard
          follow_mouse = 1,
          natural_scroll = true,

          touchpad = {
            disable_while_typing = true,
            natural_scroll = true,
            scroll_factor = 0.2,
            clickfinger_behavior = true,
            drag_lock = 0,
            tap_and_drag = false,
          },
        },

        group = {
          groupbar = {
            render_titles = true,
            gradients = false,
            font_size = 11,
            text_color = 0x353741,
          },
        },

        misc = {
          disable_hyprland_logo = true,
          disable_splash_rendering = true,
          mouse_move_enables_dpms = true,
          focus_on_activate = true,
          allow_session_lock_restore = true,
        },

        -- dwindle = {
        --   pseudotile = true,
        --   force_split = 2,
        -- },

        xwayland = {
          force_zero_scaling = true,
        },

        render = {
          direct_scanout = 1,
        },

        binds = {
          workspace_back_and_forth = true,
          allow_workspace_cycles = true,
        },

        debug = {
          full_cm_proto = true,
        },
      })

      hl.curve("wind", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05}}})
      hl.curve("winIn", { type = "bezier", points = { {0.1, 1.1}, {0.1, 1.1}}})
      hl.curve("winOut", { type = "bezier", points = { {0.3, -0.3}, {0, 1}}})
      hl.curve("linear", { type = "bezier", points = { {1, 1}, {1, 1}}})

      hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "wind", style = "slide" })
      hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "winIn", style = "slide" })
      hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "winOut", style = "slide" })
      hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "linear" })
      hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "linear", style = "loop" })
      hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "default" })
      hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "wind" })

      hl.device({
        name = "logitech-usb-optical-mouse",
        sensitivity = -0.3,
      })

      hl.device({
        name = "ydotoold-virtual-device",
        kb_layout = "us",
        kb_options = "grp:shifts_toggle,caps:swapescape",
      })

      hl.device({
        name = "beekeeb-grizzlt-piantor",
        kb_layout = "us",
      })
    '';
  };
}
