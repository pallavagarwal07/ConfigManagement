{
  nix.nixPath = [ "/home/pallavag/packages" "nixos-config=/etc/nixos/configuration.nix" ];
  allowUnfree = true;
  packageOverrides = pkgs: rec {

    networking.firewall.allowedTCPPorts = [ 3000 8000 ];

    updateFile = pkgs.writeScriptBin "upd"
    ''
      #!/${pkgs.bash}/bin/bash
      nix-env -f '<nixpkgs>' -i all
    '';

    quickAccess = pkgs.writeScriptBin "vv"
    ''
      #!/${pkgs.bash}/bin/bash
      if [ $# -lt 1 ]; then
        ${pkgs.neovim}/bin/nvim `nix-instantiate --eval -E '<nixpkgs>'`/pkgs/top-level/all-packages.nix
      else
        name=$(grep -oP "^\s*$1\s*=\s*.*?\.\.(\/[\w\.-]*)*"  \
          ~/packages/nixpkgs/pkgs/top-level/all-packages.nix | \
          grep -oP '\.\.(\/[\w\.-]*)*''$')
        grep -P '\.nix''$' <<< $name
        if [[ "$?" -eq "0" ]]; then
          ${pkgs.neovim}/bin/nvim "`nix-instantiate --eval -E '<nixpkgs>'`/pkgs/top-level/$name"
        else
          ${pkgs.neovim}/bin/nvim "`nix-instantiate --eval -E '<nixpkgs>'`/pkgs/top-level/$name/default.nix"
        fi
      fi
    '';

    all = pkgs.buildEnv {
      name = "all";
      paths = with pkgs; [
        python2 lxappearance sshfsFuse bundler_HEAD ruby pkgconfig docker bind
        imagemagick parallel python3 neovim notify-osd wxhexeditor updateFile
        scrot compton libnotify firefox go udisks2 manpages tcpflow i3lock zsh
        wxGTK29 mosh pythonPackages.udiskie quickAccess openssl tcpdump gdb
        weechat scala sbt graphviz alsaTools gparted arp-scan skype openjdk8
        rust.rustc rust.cargo flex bison fuse mysql-workbench
        httpie android-studio vagrant ranger python3Packages.pip bazel
        gitlab-runner
      ];
    };
  };
}
