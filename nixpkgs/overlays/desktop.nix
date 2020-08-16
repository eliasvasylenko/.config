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
        neovim
	steam
        multimc openjdk8
        inkscape
	zplug
      ];
      pathsToLink = [ "/share" "/bin" "/etc" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
}
