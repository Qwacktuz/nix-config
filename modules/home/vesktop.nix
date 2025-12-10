{ ... }:
{
  # TODO: have stylix control the style + accent "manuve"
  # stylix.targets.vesktop.enable = true;
  # stylix.targets.vencord.enable = true;

  programs.vesktop = {
    enable = true;
    settings = {
      appBadge = false; # disable red notficiation dot
      arRPC = false;
      checkUpdates = false;
      customTitleBar = false;
      disableMinSize = true;
      minimizeToTray = false;
      tray = false;
      staticTitle = false;
      hardwareAcceleration = true;
      discordBranch = "stable";
    };

    vencord = {
      useSystem = true;
      themes = {
        catppuccin-mocha = builtins.readFile (
          builtins.fetchurl {
            url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha-mauve.theme.css";
            sha256 = "sha256:0kd48cx0m1zip927p923n4qbwjpqhqy449xwphsn2rxly3qnwfxl";
          }
        );
      };

      settings = {
        enabledThemes = [ "catppuccin-mocha.css" ];
        autoUpdate = false;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;
        quickCss = true;
        disableMinSize = true;
        plugins = {
          FakeNitro.enabled = true;
          MessageLogger = {
            enabled = true;
            ignoreSelf = true;
          };
          AccountPanelServerProfile.enabled = true;
          AlwaysTrust.enabled = true;
          AnonymiseFileNames.enabled = true;
          BetterSettings.enabled = true;
          BetterGifAltText.enabled = true;
          BetterRoleContext.enabled = true;
          BetterRoleDot.enabled = true;
          BetterSessions.enabled = true;
          BetterUploadButton.enabled = true;
          BiggerStreamPreview.enabled = true;
          BlurNSFW.enabled = true;
          ClearURLs.enabled = true;
          CopyFileContents.enabled = true;
          CopyEmojiMarkdown.enabled = true;
          CopyStickerLinks.enabled = true;
          CopyUserURLs.enabled = true;
          CrashHandler.enabled = true;
          CustomIdle.enabled = true;

          Decor.enabled = true;
          DisableCallIdle.enabled = true;
          DisableDeepLinks.enabled = true;
          ExpressionsCloner.enabled = true;
          FakeProfileThemes.enabled = true;
          FixCodeblockGap.enabled = true;
          FixImagesQuality.enabled = true;
          FixSpotifyEmbeds.enabled = true;
          ForceOwnerCrown.enabled = true;
          FriendsSince.enabled = true;
          FixYoutubeEmbeds.enabled = true;
          FullSearchContext.enabled = true;
          GameActivityToggle.enabled = true;
          GifPaste.enabled = true;
          GreetStickerPicker.enabled = true;
          ImageFilename.enabled = true;
          ImageLink.enabled = true;
          ImageZoom.enabled = true;
          ImplicitRelationships.enabled = true;
          #InvisibleChat.enabled=true;
          KeepCurrentChannel.enabled = true;
          LoadingQuotes.enabled = true;
          MemberCount.enabled = true;
          MessageLatency.enabled = true;
          MessageLinkEmbeds.enabled = true;
          MutualGroupDMs.enabled = true;
          NewGuildSettings.enabled = true; # mute when joining new servers

          NoMaskedUrlPaste.enabled = true;
          NoOnboardingDelay.enabled = true;
          NoReplyMention.enabled = true;
          NormalizeMessageLinks.enabled = true;
          NoSystemBadge.enabled = true;
          NotificationVolume.enabled = true;
          NoTrack.enabled = true;
          NoUnblockToJump.enabled = true;
          OnePingPerDM.enabled = true;
          OpenInApp.enabled = true;
          PauseInvitesForever.enabled = true;
          PermissionFreeWill.enabled = true;
          PermissionsViewer.enabled = true;
          petpet.enabled = true;
          PictureInPicture.enabled = true;
          PinDMs.enabled = true;
          PlatformIndicators.enabled = true;
          ReactErrorDecoder.enabled = true;
          ReadAllNotficationsButton.enabled = true;
          RelationshipNotifier.enabled = true;
          ReplaceGoogleSearch = {
            enabled = true;
            customEngineName = "DuckDuckGo";
            customEngineURL = "https://duckduckgo.com/?q=";
          };
          ReplyTimestamp.enabled = true;
          ReverseImageSearch.enabled = true;
          ReviewDB.enabled = true;
          SecretRingToneEnabler.enabled = true;
          ServerInfo.enabled = true;
          ServerListIndicators.enabled = true;
          Settings.enabled = true;
          ShikiCodeblocks.enabled = true;
          ShowConnections.enabled = true;
          ShowHiddenChannels.enabled = true;
          ShowHiddenThings.enabled = true;
          ShowMeYourName.enabled = true;
          ShowTimeoutDuration.enabled = true;
          SilentTyping.enabled = true;
          SortFriendRequests.enabled = true;
          SpotifyControls.enabled = true;
          SpotifyCrack.enabled = true;
          SpotifyShareCommands.enabled = true;
          StarupTimings.enabled = true;
          StickerPaste.enabled = true;
          StreamerModeOnStream.enabled = true;
          Summaries.enabled = true;
          SuperReactionTweaks.enabled = true;
          ThemeAttributes.enabled = true; # disable
          TypingIndicator.enabled = true;
          Translate.enabled = true;
          Unindent.enabled = true;
          TypingTweaks.enabled = true;
          UnblockedAvatarZoom.enabled = true;
          UnsuppressEmbeds.enabled = true;
          UserVoiceShow.enabled = true;
          USRBG.enabled = true;
          ValidReply.enabled = true;
          ValidUser.enabled = true;
          VencordToolbox.enabled = true;
          ViewIcons.enabled = true;
          ViewRaw.enabled = true;
          VoiceChatDoubleClick.enabled = true;
          VolumeBooster.enabled = true;
          WebScreenShareFixes.enabled = true;
          WebKeybinds.enabled = true;
          WebContextMenus.enabled = true;
          WhoReacted.enabled = true;
          YoutubeAdblock.enabled = true;
        };
      };
    };
  };
}
