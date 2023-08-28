export-env {
    $env.PATH = (
      $env.PATH | split row (char esep) | uniq 
      | prepend '@nvim@/bin'
      | prepend '@git@/bin'
      | prepend '@tmux@/bin'
    );
}
export alias vi = nvim
export alias vim = nvim
