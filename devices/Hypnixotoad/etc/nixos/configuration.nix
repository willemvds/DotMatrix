{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "Hypnixotoad";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Johannesburg";
  i18n.defaultLocale = "en_ZA.UTF-8";

  services.xserver.enable = false;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    simple-scan # document scanner
    totem       # video player
    showtime
    yelp        # help viewer
    evince      # document viewer
    geary       # email client
    seahorse    # password manager
    gnome-music
    gnome-maps
    gnome-weather
  ];

  services.xserver.xkb = {
    layout = "za";
    variant = "";
  };

  services.printing.enable = false;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;

    #media-session.enable = true;
  };

  # services.xserver.libinput.enable = true;

  programs.zsh.enable = true;

  virtualisation.containers = {
    enable = true;
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = true;
  };

  users.users."willem" = {
    isNormalUser = true;
    description = "Willem van der Schyff";
    extraGroups = [
      "networkmanager"
      "podman"
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Willem van der Schyff";
	email = "willem@vds.io";
      };
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
      };
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.firefox = {
    enable = true;
    policies = {
      PasswordManagerEnabled = false;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    bat
    ghostty
    duf
    eza
    fd
    fzf
    gcc
    gnumake
    gnupg
    inetutils
    lua
    mpv
    openssl
    openssh
    ripgrep
    rustup
    neovim
    starship
    stylua
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.sauce-code-pro
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "26.05";
}
