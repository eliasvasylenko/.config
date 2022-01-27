self: super: {
  games = with self.pkgs;
    self.buildEnv {
      name = "games";
      paths = [
        steam
        multimc openjdk8
      ];
      pathsToLink = [ "/share" "/bin" "/etc" ];
    };
}
