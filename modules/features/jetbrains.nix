{ inputs, ... }:
{
  flake-file.inputs.nix-jetbrains-plugins.url = "github:nix-community/nix-jetbrains-plugins";

  flake.modules.darwin.jetbrains.homebrew.casks = [
    "intellij-idea"
    "pycharm"
    "webstorm"
  ];

  flake.modules.homeManager.jetbrains =
    { pkgs, lib, ... }:
    let
      jbLib = inputs.nix-jetbrains-plugins.lib;
      commonPlugins = [
        "IdeaVIM" # IdeaVIM
        "org.yelog.ideavim.flash"
        "AceJump" # AceJump

        "com.github.catppuccin.jetbrains"
        "com.github.catppuccin.jetbrains_icons"

        "org.ldemetrios.kvasir" # Typst support
        "net.ashald.envfile"
        "org.toml.lang"
        "mobi.hsz.idea.gitignore"
        "com.github.bric3.excalidraw"
        # "com.jetbrains.writerside"
        "mdx.js"

        "com.jetbrains.edu"
        "Key Promoter X"
        # "dev.protsenko.security-linter"

        # Might move later
        "nix-idea"
        "com.intellij.mermaid"

        # "com.intellij.bigdatatools"
        # "com.intellij.bigdatatools.core"
        # "intellij.bigdatatools.coreUi"
        # "intellij.bigdatatools.awsBase"
        # "com.intellij.bigdatatools.binary.files"
        # "com.intellij.bigdatatools.rfs"
        # "com.intellij.bigdatatools.gcloud"

        "org.jetbrains.junie"
        "com.github.copilot"
      ];

      launchers = {
        idea = "/Applications/IntelliJ IDEA.app/Contents/MacOS/idea";
        pycharm = "/Applications/PyCharm.app/Contents/MacOS/pycharm";
        webstorm = "/Applications/WebStorm.app/Contents/MacOS/webstorm";
      };
      buildIDE =
        name: specificPlugins:
        if pkgs.stdenv.hostPlatform.isDarwin then
          pkgs.writeShellScriptBin "jetbrains-install-${name}-plugins" ''
            set -eu
            launcher=${lib.escapeShellArg launchers.${name}}
            if [ ! -x "$launcher" ]; then
              echo "Install the ${name} Homebrew cask before installing plugins." >&2
              exit 1
            fi
            exec "$launcher" installPlugins ${
              lib.escapeShellArgs (lib.unique (commonPlugins ++ specificPlugins))
            } "$@"
          ''
        else
          (jbLib.buildIdeWithPlugins pkgs pkgs.jetbrains.${name} (commonPlugins ++ specificPlugins))
          .overrideAttrs
            (_: {
              disallowedReferences = [ ];
            });

    in
    {
      home.packages = [
        # --- IntelliJ IDEA Ultimate ---
        (buildIDE "idea" [
          "Pythonid" # PyCharm Pro replacement
          "org.jetbrains.plugins.go" # GoLand replacement
          "com.jetbrains.rust" # Rust rover replacement
          "org.jetbrains.android" # Android studio replacement

          # Some bug currently - DO NOT UPDATE IF DOWNLOADED - just use CLion directly
          "com.intellij.clion" # CLion replacement
          # "org.jetbrains.plugins.clion.radler" # asahi issues
          # "com.intellij.nativeDebug" # asahi issues

          # Language
          "androidx.compose.plugins.idea" # Jetpack compose
          # "com.jetbrains.kmm" # Kotlin multiplatform mobile - conflicts with clion plugin
          "com.falsepattern.zigbrains"
          "dev.blachut.svelte.lang"
          "io.flutter"
          "Dart"
          "com.my.antlr.tool"
          "org.antlr.intellij.plugin"

          # Cloud
          "com.intellij.kubernetes"
          "org.intellij.plugins.hcl"

          # Minecraft
          "com.github.tth05.minecraft-nbt-intellij-plugin"
          "com.demonwav.minecraft-dev"

          # Various deps
          "com.redhat.devtools.lsp4ij"
          "com.android.tools.design"
          "PythonCore"
          "intellij.webp"
        ])

        # --- PyCharm Professional ---
        (buildIDE "pycharm" [
          "org.tonybaloney.security.pycharm-security"
        ])

        # --- WebStorm ---
        (buildIDE "webstorm" [
          "org.jetbrains.plugins.astro"
          "dev.blachut.svelte.lang"
          "com.intellij.lang.jsgraphql"
          "com.haulmont.rcb" # react
          "com.github.warningimhack3r.intellijshadcnplugin" # shadcn
        ])

        # --- CLion ---
        # (buildIDE "clion" [
        #   "com.intellij.gradle"
        #   "com.intellij.clion-gradle"
        # ])

        # --- GoLand ---
        # (buildIDE "goland" [
        #   "intellij.prettierJS"
        # ])

        # --- Rust Rover ---
        # (buildIDE "rust-rover" [])
      ];
    };
}
