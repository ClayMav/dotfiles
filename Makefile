.PHONY: upgrade
upgrade:
	darwin-rebuild switch --flake .
update:
	nix flake update