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
        firefox
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
