.PHONY: upgrade
upgrade:
	sudo darwin-rebuild switch --flake .

.PHONY: update
update:
	nix flake update
	make upgrade