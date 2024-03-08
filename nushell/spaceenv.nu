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
      | prepend @starship@/bin
      | prepend @ccache@/bin
    )
    $env.STARSHIP_CONFIG = '@STARSHIP_CONFIG@'
}

export alias vi = nvim
export alias vim = nvim
export alias roots = nix-store --gc --print-roots
export alias cat = ^@bat@/bin/bat

def session-names [] {
  fd "" ~/sapient ~/personal ~/kagenova --max-depth 1 -t d | lines | each { $in | path basename } | uniq
}

export def session [name: string@session-names] {
    let locations  = fd $"($name)$" -t d ~/ --maxdepth 2 | lines
    if ($locations | length) > 0 {
    let location = $locations | first
    let session = $location | path basename
      tmux new-session -As $session -c $location
    } else {
      echo $"Could not find session ($name)"
    }
}
