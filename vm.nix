{ lib, config, pkgs, ... }:
{
  boot.loader.grub.splashImage = null;
  services.kubernetes = {
    roles = [ "master" "node" ];
    verbose = true;
    apiserver = {
      extraOpts = "--insecure-bind-address 0.0.0.0";
    };
  };

  networking.firewall.enable = false;
  services.mingetty.autologinUser = "root";
  systemd.services."serial-getty@ttyS0".enable = true;

  # Make lookups always succeed
  networking.hostName = "localhost";

  environment.systemPackages = with pkgs; [
    kubernetes-helm
    gnumake
  ];

  virtualisation.docker.listenOptions = [
    "/var/run/docker.sock"
    "0.0.0.0:2375"
  ];
}
