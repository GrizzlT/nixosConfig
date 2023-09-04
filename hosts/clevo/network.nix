hostName: hostId:
{ lib, ... }:
{
  networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.interfaces.enp46s0.useDHCP = true;
  networking.hostId = hostId;
  networking.hostName = hostName;
  networking.networkmanager.enable = true;
  networking.extraHosts = ''
    127.0.0.1 facebook.com m.facebook.com

    127.0.0.1 test1.example.org
    127.0.0.1 test2.example.org
    127.0.0.1 test3.example.org
  '';
}
