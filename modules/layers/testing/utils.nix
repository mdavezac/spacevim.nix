config: rec {
  is_others_enabled = (builtins.length config.spacenix.layers.testing.others) > 0;
  is_python_enabled = config.spacenix.languages.python;
  is_enabled = config.spacenix.layers.testing.enable && (is_python_enabled || is_others_enabled);
}
