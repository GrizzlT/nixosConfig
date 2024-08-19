{ config, ... }:
let
  spicePkgs = config.grizz.settings.spicetifyPkgs;
in
{
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      shuffle
      autoSkipVideo
      autoSkip
      loopyLoop
      popupLyrics
      skipOrPlayLikedSongs
      goToSong
      skipStats
      songStats
      volumeProfiles
      savePlaylists
      playNext
      volumePercentage
      autoSkipExplicit
    ];
    theme = spicePkgs.themes.lucid;
    colorScheme = "comfy";
  };
}
