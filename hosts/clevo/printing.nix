{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplip ];
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
  };
}
