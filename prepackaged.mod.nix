wrapper: { config, lib, ... }: {
  imports = [
    ./layers/base/options.nix
    ./layers/completion/options.nix
    ./layers/dash/options.nix
    ./layers/debugger/options.nix
    ./layers/formatter/options.nix
    ./layers/git/options.nix
    ./layers/languages/options.nix
    ./layers/lsp/options.nix
    ./layers/motion/options.nix
    ./layers/neorg/options.nix
    ./layers/pimp/options.nix
    ./layers/terminal/options.nix
    ./layers/testing/options.nix
    ./layers/tmux/options.nix
    ./layers/tree-sitter/options.nix
  ];

  config.packages = [
    (wrapper { config = { nvim = config.nvim; }; })
  ];
}
