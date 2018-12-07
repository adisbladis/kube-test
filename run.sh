#!/usr/bin/env bash
set -euo pipefail

export QEMU_OPTS="-nographic -serial mon:stdio -m 2048"
export QEMU_KERNEL_PARAMS=console=ttyS0
# Forward ports require by kubernetes to localhost
export QEMU_NET_OPTS="hostfwd=tcp::8080-:8080,hostfwd=tcp::2375-:2375"
export NIX_DISK_IMAGE="kube.qcow2"
DISK_IMAGE_SIZE=16384

# Delete persistent image on exit
function finish {
    rm -f "$NIX_DISK_IMAGE"
}
trap finish EXIT

# Note: We should probably use a pre-built vm image that can be reused by everyone in the team
# and also works on OSX
#
# This is probably best achieved through extracting the VM image and discarding the `run-nixos-vm` script
output_path=$(nix-build '<nixpkgs/nixos>' -A vm -k -I nixos-config=./vm.nix --no-out-link --show-trace)

if ! test -e "$NIX_DISK_IMAGE"; then
    qemu-img create -f qcow2 "$NIX_DISK_IMAGE" "${DISK_IMAGE_SIZE}M"
fi

$output_path/bin/run-nixiekube-vm
