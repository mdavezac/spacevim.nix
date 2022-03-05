{ lib, ... }:
let
  layer_options = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable the lsp layer";
    };
    saga = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable lsp-saga";
    };
    signature = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable lsp-signature";
    };
    colors = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable lsp-colors";
    };
    trouble = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable trouble";
    };
    aerial = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable aerial";
    };
  };
  instance_options = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable a particular LSP";
      default = true;
    };
    cmd = lib.mkOption {
      type = lib.types.listOf lib.types.string;
      description = "Command and argument list";
    };
    setup_location = lib.mkOption {
      type = lib.types.enum [ "lsp" "navigator" ];
      default = "lsp";
      description = "Where to do the setup";
    };
    on-attach = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Code to run in on-attach function";
    };
  };
in
{
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.lsp = lib.mkOption {
            type = lib.types.submodule { options = layer_options; };
            default = { };
          };
        };
      };
      options.lsp-instances = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule { options = instance_options; });
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
}
