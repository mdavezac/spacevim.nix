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
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.lsp = lib.mkOption {
            type = lib.types.submodule {
              options.enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to enable the lsp layer";
              };
              options.saga = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to enable lsp-saga";
              };
            };
            default = { };
          };
        };
      };
      options.lsp-instances = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options.enable = lib.mkOption {
            type = lib.types.bool;
            description = "Whether to enable a particular LSP";
            default = true;
          };
          options.cmd = lib.mkOption {
            type = lib.types.listOf lib.types.string;
            description = "Command and argument list";
          };
          options.setup_location = lib.mkOption {
            type = lib.types.enum [ "lsp" "navigator" ];
            default = "lsp";
            description = "Where to do the setup";
          };
        });
        description = ''LSP instances'';
        default = { };
      };
      options.include-lspconfig = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to include lsp-config in plugins";
      };
    };
  };

  config.nvim.plugins.start =
    lib.mkIf (enabled && config.nvim.include-lspconfig) [ pkgs.vimPlugins.nvim-lspconfig ];
  config.nvim.init.lua =
    let
      instances = lib.sort (a: b: a < b) config.nvim.lsp-instances;
      if_has_instance = instance: text:
        if (lib.any (x: x == instance) instances) then text else "";
      text = lib.concatStrings [
        (if_has_instance "rnix" "lsp.rnix.setup{cmd = {'${pkgs.rnix-lsp}/bin/rnix-lsp'}}\n\n")
      ];
      cmd-list = v: builtins.concatStringsSep "," (builtins.map (x: "\"${x}\"") v);
      setup-lsp = (k: v: ''
        lsp.${k}.setup({
           cmd={${cmd-list v.cmd}},
           capabilities=capabilities
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
        ] ++ (builtins.attrValues (builtins.mapAttrs setup-lsp internal-lsp))
      )
    );
}
