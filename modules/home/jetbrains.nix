{ inputs, ... }:
{
  flake-file.inputs.nix-jetbrains-plugins.url = "github:nix-community/nix-jetbrains-plugins";

  flake.modules.homeManager.jetbrains =
    { pkgs, ... }:
    let
      jbLib = inputs.nix-jetbrains-plugins.lib;
      commonPlugins = [
        "IdeaVIM" # IdeaVIM
        "org.yelog.ideavim.flash"
        "AceJump" # AceJump

        "com.github.catppuccin.jetbrains"
        "com.github.catppuccin.jetbrains_icons"

        "net.ashald.envfile"
        "org.toml.lang"
        "mobi.hsz.idea.gitignore"
        "com.github.bric3.excalidraw"
        "com.jetbrains.writerside"
        "mdx.js"

        "com.jetbrains.edu"
        "Key Promoter X"
        "dev.protsenko.security-linter"

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

      # buildIDE =
      #   ide: specificPlugins: jbLib.buildIdeWithPlugins pkgs ide (commonPlugins ++ specificPlugins);

      # Darwin patch
      buildIDE =
        ide: specificPlugins:
        let
          wrappedIde = jbLib.buildIdeWithPlugins pkgs ide (commonPlugins ++ specificPlugins);
        in
        # Strip 'disallowedReferences' on darwin because the
        # wrapper causes a false-positive security violation.
        wrappedIde.overrideAttrs (old: {
          disallowedReferences = [ ];
        });

    in
    {
      home.packages = with pkgs.jetbrains; [

        # --- IntelliJ IDEA Ultimate ---
        (buildIDE idea [
          "Pythonid" # PyCharm Pro replacement
          "org.jetbrains.plugins.go" # GoLand replacement
          "com.jetbrains.rust" # Rust rover replacement
          "org.jetbrains.android" # Android studio replacement

          # Some bug currently - DO NOT UPDATE IF DOWNLOADED - just use CLion directly
          # "com.intellij.clion" # CLion replacement
          "org.jetbrains.plugins.clion.radler"
          "com.intellij.nativeDebug"

          # Language
          "androidx.compose.plugins.idea" # Jetpack compose
          "com.jetbrains.kmm" # Kotlin multiplatform
          "com.falsepattern.zigbrains"
          "dev.blachut.svelte.lang"
          "io.flutter"
          "Dart"

          # Cloud
          "com.intellij.kubernetes"
          "org.intellij.plugins.hcl"
          "com.intellij.kubernetes"

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
        (buildIDE pycharm [
          "org.tonybaloney.security.pycharm-security"
        ])

        # --- WebStorm ---
        (buildIDE webstorm [
          "org.jetbrains.plugins.astro"
          "dev.blachut.svelte.lang"
          "com.intellij.lang.jsgraphql"
          "com.haulmont.rcb" # react
          "com.github.warningimhack3r.intellijshadcnplugin" # shadcn
        ])

        # --- CLion ---
        (buildIDE clion [
          "com.intellij.gradle"
          "com.intellij.clion-gradle"
        ])

        # --- GoLand ---
        # (buildIDE goland [
        #   "intellij.prettierJS"
        # ])

        # --- Rust Rover ---
        # (buildIDE rust-rover [])
      ];
    };
}
