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
          extraExtensions = [
            (fetchFirefoxAddon {
              name = "ublock";
              url = "https://addons.mozilla.org/firefox/downloads/file/3679754/ublock_origin-1.31.0-an+fx.xpi";
              sha256 = "1h768ljlh3pi23l27qp961v1hd0nbj2vasgy11bmcrlqp40zgvnr";
            })
            (fetchFirefoxAddon {
              name = "noscript";
              url = "https://addons.mozilla.org/firefox/downloads/file/3673546/noscript_security_suite-11.1.5-an+fx.xpi";
              sha256 = "162kxcai5yqxiys4dngz8yqqkdqmp4n86kwas5nbdwq20p4nkjh4";
            })
          ];

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
              start = [ editorconfig-vim ];
              opt = [ ];
            };
          };
        })
        steam
        multimc openjdk8
        inkscape
        zplug perl
      ];
      pathsToLink = [ "/share" "/bin" "/etc" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
}
