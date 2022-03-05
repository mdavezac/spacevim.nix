{ config, lib, pkgs, ... }:
let
  with-linters = builtins.any
    (v: v.enable)
    (builtins.attrValues config.nvim.linters);
  with-any-lsp = builtins.any
    (v: v.enable)
    (builtins.attrValues config.nvim.lsp-instances);
  with-internal-lsp = builtins.any
    (v: v.enable && (v.setup_location == "lsp"))
    (builtins.attrValues config.nvim.lsp-instances);
  internal-lsp = lib.filterAttrs
    (k: v: v.enable && (v.setup_location == "lsp"))
    config.nvim.lsp-instances;
  enabled = config.nvim.layers.lsp.enable && (with-any-lsp || with-linters);
in
{
  config.nvim.plugins.start = [
    (lib.mkIf (enabled && config.nvim.include-lspconfig) pkgs.vimPlugins.nvim-lspconfig)
    (lib.mkIf (enabled && config.nvim.layers.lsp.colors) pkgs.vimPlugins.lsp-colors-nvim)
  ];
  config.nvim.init.lua =
    let
      instances = lib.sort (a: b: a < b) config.nvim.lsp-instances;
      if_has_instance = instance: text:
        if (lib.any (x: x == instance) instances) then text else "";
      text = lib.concatStrings [
        (if_has_instance "rnix" "lsp.rnix.setup{cmd = {'${pkgs.rnix-lsp}/bin/rnix-lsp'}}\n\n")
      ];
      cmd-list = v: builtins.concatStringsSep "," (builtins.map (x: "\"${x}\"") v);
      on-attach = code:
        if ((builtins.length code) > 0) then ''
          on_attach = function (client, bufnr)
            ${builtins.concatStringsSep "\n            " code}
          end
        '' else "";
      setup-lsp = (k: v: ''
        lsp.${k}.setup({
           cmd={${cmd-list v.cmd}},
           capabilities=capabilities,
           ${on-attach v.on-attach}
        })
      '');
    in
    lib.mkIf (enabled && with-internal-lsp) (
      builtins.concatStringsSep "\n" (
        [
          ''
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

            local lsp = require('lspconfig')
          ''
          (if config.nvim.layers.lsp.colors then "require(\"lsp-colors\").setup({})" else "")
        ] ++ (builtins.attrValues (builtins.mapAttrs setup-lsp internal-lsp))
      )
    );
}
