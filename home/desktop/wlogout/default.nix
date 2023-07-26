{ pkgs, config, ... }:
with config.lib.stylix.colors.withHashtag;
with config.stylix.fonts;
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "${pkgs.swaylock}/bin/swaylock -f";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "${pkgs.systemd}/bin/loginctl terminate-user $USER";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "${pkgs.systemd}/bin/systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "${pkgs.systemd}/bin/systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "${pkgs.systemd}/bin/systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
    style = ''
      @define-color base00 ${base00}; @define-color base01 ${base01}; @define-color base02 ${base02}; @define-color base03 ${base03};
      @define-color base04 ${base04}; @define-color base05 ${base05}; @define-color base06 ${base06}; @define-color base07 ${base07};

      @define-color base08 ${base08}; @define-color base09 ${base09}; @define-color base0A ${base0A}; @define-color base0B ${base0B};
      @define-color base0C ${base0C}; @define-color base0D ${base0D}; @define-color base0E ${base0E}; @define-color base0F ${base0F};

      /** ********** Fonts ********** **/
      * {
        font-family: ${sansSerif.name};
        font-size: 30px;
        font-weight: bold;
      }

      /** ********** Main Window ********** **/
      window {
        background-color: @base00;
      }

      /** ********** Buttons ********** **/
      button {
        background-color: @base01;
        color: @base05;
        border: 2px solid @base0D;
        border-radius: 20px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 35%;
      }

      button:focus,
      button:active,
      button:hover {
        background-color: @base02;
        outline-style: none;
      }

      /** ********** Icons ********** **/
      #lock {
        background-image: image(url('${./icons/lock.png}'), url('/usr/share/wlogout/icons/lock.png'));
      }

      #logout {
        background-image: image(url('${./icons/logout.png}'), url('/usr/share/wlogout/icons/logout.png'));
      }

      #suspend {
        background-image: image(url('${.icons/suspend.png}'), url('/usr/share/wlogout/icons/suspend.png'));
      }

      #shutdown {
        background-image: image(url('${.icons/shutdown.png}'), url('/usr/share/wlogout/icons/shutdown.png'));
      }

      #reboot {
        background-image: image(url('${.icons/reboot.png}'), url('/usr/share/wlogout/icons/reboot.png'));
      }
    '';
  };
}
