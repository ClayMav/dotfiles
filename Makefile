.PHONY: upgrade
upgrade:
	sudo darwin-rebuild switch --flake .
update:
	nix flake update