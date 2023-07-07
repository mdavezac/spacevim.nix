
let-env PATH = ($env.PATH | split row (char esep) | append ([$env.HOME '.nix-profile/bin/'] | str join "/"))
