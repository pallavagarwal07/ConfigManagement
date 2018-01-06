{
  nix.nixPath = [ "/home/pallav/proj" "nixos-config=/etc/nixos/configuration.nix" ];
  nix.binaryCaches = ["http://hydra.nixos.org/" "http://cache.nixos.org/"];
  allowUnfree = true;
  allowBroken = true;
  packageOverrides = pkgs: rec {

    updateFile = pkgs.writeScriptBin "upd"
    ''
      #!/${pkgs.bashInteractive}/bin/bash
      nix-env -f '<nixpkgs>' -i all
    '';

    quickAccess = pkgs.writeScriptBin "vv"
    ''
      #!/${pkgs.bashInteractive}/bin/bash
      if [ $# -lt 1 ]; then
        ${pkgs.neovim}/bin/nvim `nix-instantiate --eval -E '<nixpkgs>'`/pkgs/top-level/all-packages.nix
      else
        name=$(grep -oP "^\s*$1\s*=\s*.*?\.\.(\/[\w\.-]*)*"  \
          ~/proj/nixpkgs/pkgs/top-level/all-packages.nix | \
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
      paths = with pkgs; [ ruby python2 sshfsFuse bundler_HEAD pkgconfig docker
      bind imagemagick parallel python3 neovim notify-osd wxhexeditor
      updateFile go firefox udisks2 manpages tcpflow gdb
      wxGTK29 mosh quickAccess openssl tcpdump gparted weechat openjdk8
      rust.cargo fuse httpie ghc zsh my_tex_packages ranger python3Packages.pip
      gitlab-runner wpsoffice kvm virtmanager ltrace evince zeal mongodb ] ++
      my_conf_packages ++
      my_tmp_packages ++
      my_custom_packages;
    };

    my_conf_packages = with pkgs; [
      # Used by terminal emulator.
      source-code-pro source-sans-pro unifont

      # Appearance
      ubuntu_font_family lxappearance compton

      # Tools
      scrot libnotify i3lock alsaTools
      pythonPackages.udiskie kitty xsel sdcv
      xdg_utils xorg.xkill usbutils
      ccrypt keybase
    ];

    my_tmp_packages = with pkgs; [
      calibre kvm openvpn
    ];

    my_custom_packages = [ sdm pkgs.i3-gaps ];

    my_tex_packages = with pkgs; texlive.combine {
      inherit (texlive) scheme-medium appendix changebar footmisc multirow
      overpic stmaryrd subfigure titlesec wasysym xargs bigfoot luatex lipsum
      fontawesome adjustbox collectbox wrapfig fancyhdr;
    };

    sdm = (pkgs.callPackage /home/pallav/.GO/src/github.com/pallavagarwal07/sdm/help/default.nix {});
  };
}
