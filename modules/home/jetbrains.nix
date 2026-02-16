{ inputs, ... }:
{
  flake-file.inputs.nix-jetbrains-plugins.url = "github:nix-community/nix-jetbrains-plugins";

  flake.modules.homeManager.jetbrains =
    { pkgs, ... }:
    let
      jbLib = inputs.nix-jetbrains-plugins.lib;
      commonPlugins = [
        "IdeaVIM" # IdeaVIM
        "org.jetbrains.IdeaVim-EasyMotion"
        "org.yelog.ideavim.flash"
        "AceJump" # AceJump

        "com.github.catppuccin.jetbrains"
        "com.github.catppuccin.jetbrains_icons"

        "org.jetbrains.security.package-checker"
        "net.ashald.envfile"
        "org.toml.lang"
        "mobi.hsz.idea.gitignore"
        "com.intellij.bigdatatools"
        "intellij.prettierJS"

        "com.jetbrains.edu"
        "com.intellij.mermaid"
        "nix-idea"

        "org.jetbrains.plugins.github"
        "org.jetbrains.junie"
        "com.github.copilot"
      ];
      buildIDE =
        ide: specificPlugins: jbLib.buildIdeWithPlugins pkgs ide (commonPlugins ++ specificPlugins);
    in
    {
      # imports = [ inputs.nix-jetbrains-plugins.plugins ];

      home.packages = with pkgs.jetbrains; [

        # --- IntelliJ IDEA Ultimate ---
        (buildIDE idea [
          "Lombook Plugin"
          "io.flutter"
          "Dart"
          "com.demonwav.minecraft-dev"
          "com.intellij.spring"
          "org.jetbrains.kotlin"
        ])

        # --- PyCharm Professional ---
        (buildIDE pycharm [
          # Add specific python plugins if needed
        ])

        # --- WebStorm ---
        (buildIDE webstorm [
          "NodeJS"
          "JavaScript"
          "org.intellij.plugins.postcss"
          "dev.blachut.svelte.lang"
          "intellij.vitejs"
          "com.intellij.lang.jsgraphql"
          "com.github.warningimhack3r.intellijshadcnplugin"
          "com.haulmont.rcb"
        ])

        # --- GoLand ---
        (buildIDE goland [
          "io.flutter"
          "Dart"
          "com.intellij.kubernetes"
          "org.intellij.plugins.hcl"
        ])

        # --- CLion ---
        (buildIDE clion [
          "name.kropp.intellij.makefile"
          "org.jetbrains.bazel"
          "SerialPortMonitor"
        ])

        # --- Rust Rover ---
        # (buildIDE rust-rover [])
      ];
    };
}

# TODO: intagrate these into the config above
# com.intellij.notebooks.core (253.30387.193)
# com.jetbrains.edu (2026.1-2025.3-563)
# Subversion (253.30387.193)
# ru.adelf.idea.dotenv (253.30387.193)
# org.yelog.ideavim.flash (1.0.5)
# com.github.catppuccin.jetbrains (3.5.3)
# Dart (502.0.0)
# com.intellij.mermaid (0.0.26+IJ.252)
# com.intellij.spring (253.30387.173)
# org.jetbrains.junie (253.620.53)
# org.jetbrains.plugins.terminal (253.30387.92)
# AceJump (3.8.22)
# IdeaVIM (2.29.0)
# org.jetbrains.IdeaVim-EasyMotion (1.16)
# intellij.jupyter (253.30387.193)
# com.intellij.nativeDebug (253.30387.79)
# intellij.vitejs (253.30387.193)
# dev.blachut.svelte.lang (253.29346.45)
# com.demonwav.minecraft-dev (2025.3-1.8.11)
# com.github.catppuccin.jetbrains_icons (1.13.1)
# io.flutter (89.0.0)
# nix-idea (0.4.0.18)
# org.jetbrains.plugins.docker.gateway (253.30387.92)
