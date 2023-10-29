export-env {
    $env.PATH = (
      $env.PATH | split row (char esep) | uniq 
      | prepend '@nvim@/bin'
      | prepend '@git@/bin'
      | prepend '@tmux@/bin'
      | prepend @lazygit@/bin
      | prepend @glab@/bin
      | prepend @ripgrep@/bin
      | prepend @fd@/bin
      | prepend @gh@/bin
      | prepend @zellij@/bin
    )
    $env.STARSHIP_CONFIG = '@STARSHIP_CONFIG@'
}

export alias vi = nvim
export alias vim = nvim
export alias roots = nix-store --gc --print-roots
export alias cat = ^@bat@/bin/bat
