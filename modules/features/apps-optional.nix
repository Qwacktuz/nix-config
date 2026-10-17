{
  flake.modules.darwin.apps-communication.homebrew.masApps.WireGuard = 1451685025;
  flake.modules.darwin.apps-communication.homebrew.brews = [ "mas" ];
  flake.modules.darwin.apps-communication.homebrew.casks = [
    "signal"
    "protonvpn"
    "tuta-mail"
    "element"
    "royal-tsx"
    "omnissa-horizon-client"
    "legcord"
    "proton-mail"
    "proton-mail-bridge"
    "proton-pass"
  ];
  flake.modules.darwin.apps-games.homebrew.casks = [
    "steam"
    "nvidia-geforce-now"
    "prismlauncher"
  ];
  flake.modules.darwin.apps-peripherals.homebrew.casks = [
    "mos"
    "monitorcontrol"
    "focusrite-control-2"
    "wacom-tablet"
    "middleclick"
    "linearmouse"
    "raspberry-pi-imager"
  ];
  flake.modules.darwin.apps-creative.homebrew.casks = [
    "obs"
    "xournal++"
  ];
  flake.modules.darwin.apps-browsers.homebrew.casks = [
    "orion"
    "helium-browser"
  ];
  flake.modules.darwin.apps-security.homebrew.casks = [
    "burp-suite"
    "wireshark-app"
    "bit-slicer"
  ];
  flake.modules.darwin.apps-dev-extras.homebrew.casks = [
    "android-studio"
    "hashicorp/tap/hashicorp-vagrant"
  ];
  flake.modules.darwin.apps-backup.homebrew.casks = [ "vorta" ];
  flake.modules.darwin.apps-study.homebrew.casks = [
    "anki"
    "qbittorrent"
  ];
  flake.modules.darwin.apps-dev-extras.homebrew.brews = [ "vite-plus" ];
  flake.modules.darwin.apps-extra-tools.homebrew.brews = [
    "mole"
    "binwalk"
    "jdupes"
  ];
}
