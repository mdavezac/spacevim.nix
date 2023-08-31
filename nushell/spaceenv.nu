export-env {
    $env.PATH = (
      $env.PATH | split row (char esep) | uniq 
      | prepend '@nvim@/bin'
      | prepend '@git@/bin'
      | prepend '@tmux@/bin'
    )
    $env.STARSHIP_CONFIG = '@STARSHIP_CONFIG@'
}

export alias vi = nvim
export alias vim = nvim
export alias roots = nix-store --gc --print-roots
export alias cat = ^@bat@/bin/bat
