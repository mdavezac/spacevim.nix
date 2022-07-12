config: rec {
  is_others_enabled = (builtins.length config.nvim.layers.testing.others) > 0;
  is_python_enabled = config.nvim.languages.python;
  is_enabled = config.nvim.layers.testing.enable && (is_python_enabled || is_others_enabled);
}
