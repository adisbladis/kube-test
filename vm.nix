{ lib, config, pkgs, ... }:
{

  boot.loader.grub.splashImage = null;

  services.kubernetes = {
    roles = [ "master" "node" ];
    # verbose = true;
    apiserver = {
      extraOpts = "--insecure-bind-address 0.0.0.0 --anonymous-auth=true";
      authorizationMode = ["RBAC" "Node" "AlwaysAllow"];
    };
    kubelet = {
      extraOpts = "--anonymous-auth=true";
    };
  };

  services.unbound.enable = true;

  networking.firewall.enable = false;
  services.mingetty.autologinUser = lib.mkDefault "root";
  systemd.services."serial-getty@ttyS0".enable = true;

  networking.hostName = "nixiekube";

  virtualisation.docker.listenOptions = [
    "/var/run/docker.sock"
    "0.0.0.0:2375"
  ];
}
