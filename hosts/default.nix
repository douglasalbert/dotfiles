{ pkgs, hostname, ... }:

{
  # Primary user (required by nix-darwin for user-scoped defaults)
  system.primaryUser = "da";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set hostname
  networking.hostName = hostname;

  # Define the primary user
  users.users.da = {
    name = "da";
    home = "/Users/da";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    git
  ];

  # Homebrew integration for casks and packages not in nixpkgs
  homebrew = {
    enable = true;

    taps = [
      "nikitabobko/tap"
      "osx-cross/arm"
      "osx-cross/avr"
    ];

    brews = [
      "gemini-cli"
      "container"
    ];

    casks = [
      "nikitabobko/tap/aerospace"
      "claude"
      "discord"
      "ghostty"
      "google-chrome"
      "gstreamer-runtime"
      "handbrake"
      "iina"
      "lm-studio"
      "mac-mouse-fix"
      "rustdesk"
      "signal"
      "stolendata-mpv"
      "tailscale"
      "transmission"
      "zed"
    ];

    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
    };
  };

  # macOS system preferences (converted from bin/.macos)
  system.defaults = {

    # General UI/UX
    NSGlobalDomain = {
      NSTableViewDefaultSizeMode = 2;
      NSUseAnimatedFocusRing = false;
      NSWindowResizeTime = 0.001;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSTextShowsControlCharacters = true;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      AppleShowAllExtensions = true;
      ApplePressAndHoldEnabled = false;
      KeyRepeat = 1;
      InitialKeyRepeat = 10;
      AppleFontSmoothing = 1;
      AppleKeyboardUIMode = 3;
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.swipescrolldirection" = true;
      "com.apple.springing.enabled" = true;
      "com.apple.springing.delay" = 0.0;
    };

    # Dock
    dock = {
      tilesize = 36;
      mineffect = "scale";
      minimize-to-application = true;
      enable-spring-load-actions-on-all-items = true;
      show-process-indicators = true;
      launchanim = false;
      expose-animation-duration = 0.1;
      mru-spaces = false;
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      showhidden = true;
      mouse-over-hilite-stack = true;
    };

    # Finder
    finder = {
      AppleShowAllFiles = true;
      ShowStatusBar = true;
      ShowPathbar = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      QuitMenuItem = false;
    };

    # Trackpad
    trackpad = {
      Clicking = true;
    };

    # Screen capture
    screencapture = {
      location = "~/Desktop";
      type = "png";
      disable-shadow = true;
    };

    # Screensaver
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0;
    };

    # Login window
    loginwindow = {
      GuestEnabled = false;
    };

    # Custom preferences for apps not covered by built-in nix-darwin options
    CustomUserPreferences = {
      # Safari
      "com.apple.Safari" = {
      };

      # Mail
      "com.apple.mail" = {
      };

      # Messages
      "com.apple.messageshelper.MessageController" = {
        SOInputLineSettings = {
          automaticEmojiSubstitutionEnablediMessage = false;
          automaticQuoteSubstitutionEnabled = false;
          continuousSpellCheckingEnabled = false;
        };
      };

      # Activity Monitor
      "com.apple.ActivityMonitor" = {
        OpenMainWindow = true;
        IconType = 5;
        ShowCategory = 0;
        SortColumn = "CPUUsage";
        SortDirection = 0;
      };

      # TextEdit
      "com.apple.TextEdit" = {
        RichText = 0;
        PlainTextEncoding = 4;
        PlainTextEncodingForWrite = 4;
      };

      # Disk Utility
      "com.apple.DiskUtility" = {
        DUDebugMenuEnabled = true;
        "advanced-image-options" = true;
      };

      # Software Update
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        ScheduleFrequency = 1;
        AutomaticDownload = 1;
        CriticalUpdateInstall = 1;
        ConfigDataInstall = 1;
      };

      # Time Machine
      "com.apple.TimeMachine" = {
        DoNotOfferNewDisksForBackup = true;
      };

      # Desktop Services
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };

      # Printer
      "com.apple.print.PrintingPrefs" = {
        "Quit When Finished" = true;
      };

      # App Store
      "com.apple.commerce" = {
        AutoUpdate = true;
        AutoUpdateRestartRequired = true;
      };

      # LaunchServices
      "com.apple.LaunchServices" = {
        LSQuarantine = true;
      };

      # Network Browser
      "com.apple.NetworkBrowser" = {
        BrowseAllInterfaces = true;
      };

      # QuickTime Player
      "com.apple.QuickTimePlayerX" = {
        MGPlayMovieOnOpen = true;
      };
    };
  };

  # Activation script for settings not covered by system.defaults
  system.activationScripts.postActivation.text = ''
    # Show the ~/Library folder
    chflags nohidden ~/Library || true

    # Show the /Volumes folder
    sudo chflags nohidden /Volumes || true

    # Finder: show item info and snap-to-grid via PlistBuddy
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
  '';

  # Used for backwards compatibility
  system.stateVersion = 5;
}
