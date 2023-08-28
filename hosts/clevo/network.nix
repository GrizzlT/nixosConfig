hostName: hostId:
{ lib, ... }:
{
  networking.useDHCP = lib.mkDefault true;
  networking.hostId = hostId;
  networking.hostName = hostName;
  networking.networkmanager.enable = true;
  networking.extraHosts = ''
    127.0.0.1 facebook.com m.facebook.com
  '';
}
