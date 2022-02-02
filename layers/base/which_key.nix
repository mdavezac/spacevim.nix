{ lib, pkgs, config, ... }: {
  config.nvim.post = lib.mkIf config.nvim.layers.base.enable {
    lua =
      let
        filter_prefixes = cfg: builtins.filter (builtins.hasAttr "name") cfg;
        filter_keys = cfg: builtins.filter (builtins.hasAttr "key") cfg;
        if_cond = condition: text: if condition then text else "";
        print_function = filetype: cfgs:
          let
            fcfgs = builtins.filter (k: builtins.any (u: u == filetype) k.filetypes) cfgs;
            modes = lib.unique (builtins.concatLists (builtins.map (k: k.modes) fcfgs));
          in
          (
            "function which_key_${filetype}()\n"
            + (
              builtins.concatStringsSep "\n" (builtins.map (print_mode filetype fcfgs) modes)
            ) + "\nend\n\n"
          );
        print_mode = filetype: cfgs: mode:
          let
            strmode = builtins.substring 0 1 mode;
          in
          (
            "    wk.register({\n        "
            + (
              builtins.concatStringsSep ",\n        "
                (
                  builtins.map (print_key_or_group filetype)
                    (builtins.filter (k: builtins.any (u: u == mode) k.modes) cfgs)
                )
              + "\n    },\n"
            ) + "        { mode=\"${strmode}\" }\n"
            + "   )\n"
          );
        print_key_or_group = filetype: cfg:
          if (builtins.hasAttr "name" cfg)
          then (print_group_name cfg)
          else (print_key filetype cfg);
        print_group_name = cfg: "[\"${cfg.prefix}\"] = {name=\"${cfg.name}\"}";
        print_key = filetype: cfg:
          "[\"${cfg.key}\"] = {" + (print_key_options filetype cfg) + "}";
        print_key_options = filetype: cfg: builtins.concatStringsSep ", " (
          builtins.filter (x: x != "") [
            (if_cond (cfg.command != "") ("\"" + cfg.command + "\""))
            (if_cond (cfg.description != "") ("\"" + cfg.description + "\""))
            (if_cond (!cfg.noremap) "noremap=false")
            (if_cond (filetype != "any") "buffer=0")
          ]
        );

        all_options = builtins.concatLists [
          config.nvim.which-key.groups
          config.nvim.which-key.bindings
        ];
        filetypes = cfgs: lib.unique (builtins.concatLists (builtins.map (k: k.filetypes) cfgs));
        print_autocmd = filetype:
          let
            ft = builtins.toString filetype;
          in
          ''
            vim.api.nvim_exec([[autocmd FileType ${ft} :lua which_key_${ft}()]], false)
          '';
        print_autocmds = filetypes:
          builtins.concatStringsSep "\n" (
            builtins.map print_autocmd (builtins.filter (k: k != "any") filetypes)
          );
        print_functions = cfgs: builtins.concatStringsSep "\n\n" (builtins.map
          (filetype: print_function filetype cfgs)
          (filetypes cfgs));

        text = ''
          local wk = require("which-key")
          wk.setup({})

        '' + (print_functions all_options)
        + "\n\n which_key_any()\n" + (print_autocmds (filetypes all_options));
      in
      "-- Which-key from base layer\n" + text + "\n-- End of which-key from base layer";
  };
}
