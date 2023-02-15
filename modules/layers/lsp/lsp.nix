{
  config,
  lib,
  pkgs,
  ...
}: let
  with-linters =
    builtins.any
    (v: v.enable)
    (builtins.attrValues config.spacenix.linters);
  with-any-lsp =
    builtins.any
    (v: v.enable)
    (builtins.attrValues config.spacenix.lsp-instances);
  with-internal-lsp =
    builtins.any
    (v: v.enable && (v.setup_location == "lsp"))
    (builtins.attrValues config.spacenix.lsp-instances);
  internal-lsp =
    lib.filterAttrs
    (k: v: v.enable && (v.setup_location == "lsp"))
    config.spacenix.lsp-instances;
  enabled = config.spacenix.layers.lsp.enable && (with-any-lsp || with-linters);
in {
  config.nvim.plugins.start = [
    (lib.mkIf (enabled && config.spacenix.include-lspconfig) pkgs.vimPlugins.nvim-lspconfig)
    (lib.mkIf (enabled && config.spacenix.layers.lsp.colors) pkgs.vimPlugins.lsp-colors-nvim)
  ];
  config.nvim.init.lua = let
    instances = lib.sort (a: b: a < b) config.spacenix.lsp-instances;
    if_has_instance = instance: text:
      if (lib.any (x: x == instance) instances)
      then text
      else "";
    on-attach = code:
      if ((builtins.length code) > 0)
      then ''
        on_attach = function (client, bufnr)
          ${builtins.concatStringsSep "\n            " code}
        end
      ''
      else "";
    setup-lsp = k: v: ''
      lsp.${k}.setup({
         cmd={${v.cmd}},
         capabilities=capabilities,
         ${on-attach v.on-attach}
      })
    '';
  in
    lib.mkIf (enabled && with-internal-lsp) (
      builtins.concatStringsSep "\n" (
        [
          ''
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            local lsp = require('lspconfig')
          ''
          (
            if config.spacenix.layers.lsp.colors
            then "require(\"lsp-colors\").setup({})"
            else ""
          )
        ]
        ++ (builtins.attrValues (builtins.mapAttrs setup-lsp internal-lsp))
      )
    );
}
