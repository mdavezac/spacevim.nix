 let carapace_completer = {|spans|
    ^@carapace@ $spans.0 nushell $spans | from json
}

let-env config = {
  show_banner: false,
  table_mode: rounded
  ls: { use_ls_colors: true, clickable_links: true }
  buffer_editor: "nvim"
  cd : { abbreviations: true }
  hooks: {pre_execution : {code: ""}, pre_prompt: { code: "" } }
  keybindings: []
  completions: {
    external: {
      enable: true
      completer: $carapace_completer
    }
  }
}


# alias vi and vim to nvim
alias vi = ^nvim
alias vim = ^nvim
