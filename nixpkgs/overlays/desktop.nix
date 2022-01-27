self: super: {
  desktop = with self.pkgs;
    let
      desktopProfile = writeText "desktop-profile" ''
        export TERMINAL=alacritty
        export EDITOR=vim
      '';
    in self.buildEnv {
      name = "desktop";
      paths = [
        (wrapFirefox firefox-unwrapped {
          extraPolicies = {
            CaptivePortal = false;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableTelemetry = true;
            FirefoxHome = {
              Pocket = false;
              Snippets = false;
            };
            UserMessaging = {
              ExtensionRecommendations = false;
              SkipOnboarding = true;
            };
          };

          extraPrefs = ''
            // Show more ssl cert infos
            lockPref("security.identityblock.show_extended_validation", true);
          '';
        })
        mpv
        alacritty (runCommand "profile" {} ''
          mkdir -p $out/etc/profile.d
          cp ${desktopProfile} $out/etc/profile.d/desktop-profile.sh
        '')
        direnv
        git
        htop
        tmux
        unzip
        (neovim.override {
          configure = {
            customRC = ''
              set nu
              set mouse=a
            '';
            packages.myVimPackage = with pkgs.vimPlugins; {
              start = [ editorconfig-vim vim-nix ];
              opt = [ ];
            };
          };
        })
        inkscape
        zplug perl
	spotify
      ];
      pathsToLink = [ "/share" "/bin" "/etc" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
}
