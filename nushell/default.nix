{
  pkgs,
  nvim,
  git,
  tmux,
  theme ? "chalk",
}:
pkgs.stdenv.mkDerivation {
  name = "nushell";
  nativeBuildInputs = [pkgs.makeWrapper];
  src = ./.;
  buildInputs = [pkgs.starship];
  version = pkgs.nushell.version;
  buildPhase = ''
    mkdir -p share/nushell/overlays
    mkdir -p bin

    cp ./env.nu ./config.nu ./starship.toml share/nushell/
    sed -i -e "s!@carapace@!${pkgs.carapace}/bin/carapace!g" share/nushell/config.nu
    sed -i -e "s!@atuin@!${pkgs.atuin}!g" share/nushell/config.nu
    sed -i -e "s!@direnv@!${pkgs.direnv}!g" share/nushell/config.nu
    echo "use ${pkgs.nuscripts}/custom-completions/git/git-completions.nu" >> share/nushell/config.nu
    echo "use ${pkgs.nuscripts}/custom-completions/nix/nix-completions.nu" >> share/nushell/config.nu
    sed -i -e "s!@atuin@!${pkgs.atuin}!g" share/nushell/env.nu
    sed -i -e "s!@direnv@!${pkgs.direnv}!g" share/nushell/env.nu
    echo "use ${pkgs.nuscripts}/themes/themes/${theme}.nu" >> share/nushell/config.nu
    echo "\$env.config = (\$env.config | merge {color_config: (${theme})})" >> share/nushell/config.nu


    cp ./spaceenv.nu share/nushell/overlays/
    sed -i -e "s!@nvim@!${nvim}!g" share/nushell/overlays/spaceenv.nu
    sed -i -e "s!@git@!${git}!g" share/nushell/overlays/spaceenv.nu
    sed -i -e "s!@tmux@!${tmux}!g" share/nushell/overlays/spaceenv.nu
    sed -i -e "s!@bat@!${pkgs.bat}!g" share/nushell/overlays/spaceenv.nu
    sed -i -e "s!@lazygit@!${pkgs.lazygit}!g" share/nushell/overlays/spaceenv.nu
    sed -i -e "s!@glab@!${pkgs.glab}!g" share/nushell/overlays/spaceenv.nu
    sed -i -e "s!@gh@!${pkgs.gh}!g" share/nushell/overlays/spaceenv.nu
    sed -i -e "s!@ripgrep@!${pkgs.ripgrep}!g" share/nushell/overlays/spaceenv.nu
    sed -i -e "s!@fd@!${pkgs.fd}!g" share/nushell/overlays/spaceenv.nu
    sed -i -e "s!@STARSHIP_CONFIG@!$out/share/nushell/starship.toml!g" share/nushell/overlays/spaceenv.nu

    starship init nu > share/nushell/overlays/starship.nu
    echo "overlay use $out/share/nushell/overlays/starship.nu" >> share/nushell/config.nu
    echo "overlay use $out/share/nushell/overlays/spaceenv.nu" >> share/nushell/config.nu

    makeWrapper \
      ${pkgs.nushell}/bin/nu \
      bin/nu  \
      --add-flags "--config=$out/share/nushell/config.nu --env-config=$out/share/nushell/env.nu"
  '';
  installPhase = "mkdir -p $out && cp -r share bin $out/";
}
