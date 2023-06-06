###############################################################################

HOSTNAME := bahnhof

NIXOS_GENERATE_CONFIG := nixos-generate-config
NIX_FLAKE             := nix flake
NIXOS_REBUILD         := nixos-rebuild
NIX_COLLECT_GARBAGE   := nix-collect-garbage
NIX_REPL              := nix repl

HARDWARE_CONFIG := config/hardware.nix

###############################################################################

.PHONY: update
update:
	$(NIX_FLAKE) update

.PHONY: switch
switch:
	$(NIXOS_REBUILD) switch --flake .#$(HOSTNAME)

.PHONY: clean
clean:
	$(NIX_COLLECT_GARBAGE) -d

.PHONY: upgrade
upgrade: update switch

.PHONY: generate-hardware-config
generate-hardware-config: $(HARDWARE_CONFIG)

###############################################################################

$(HARDWARE_CONFIG): .FORCE
	$(NIXOS_GENERATE_CONFIG) --no-filesystems --show-hardware-config > $@

###############################################################################

.PHONY: .FORCE
.FORCE:

###############################################################################
