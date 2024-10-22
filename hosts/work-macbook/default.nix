{ ... }@inputs:
{
  users.users.clay = {
    home = "/Users/clay";
  };
  homebrew.casks = [ "monokle" ];
  environment.systemPackages = [
    pkgs.zoom-us
    pkgs.slack
    pkgs.openvpn
    pkgs.awscli2
  ];
}
