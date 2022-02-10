{ config, lib, ... }:
let
  enable = config.nvim.layers.neorg.enable;
in
{
  config.nvim.which-key = lib.mkIf enable {
    groups = [
      { name = "+Neorg"; prefix = "<leader>n"; }
      { name = "+Tasks"; prefix = "<leader>nt"; }
      { name = "+Workspaces"; prefix = "<leader>nw"; }
    ];
    bindings = [
      {
        key = "<localeader>I";
        command = "<CMD>Neorg inject-metada<CR>";
        description = "Inject metadata";
        filetypes = [ "norg" ];
      }
      {
        key = "<leader>ntv";
        command = "<CMD>Neorg gtd views<CR>";
        description = "Views";
      }
      {
        key = "<leader>ntn";
        command = "<CMD>Neorg gtd capture<CR>";
        description = "New";
      }
      {
        key = "<leader>nte";
        command = "<CMD>Neorg gtd edit<CR>";
        description = "Edit";
        filetypes = [ "norg" ];
      }
      {
        key = "<leader>ntd";
        command = "<CMD>Neorg keybind norg core.norg.qol.todo_items.todo.task_done<CR>";
        description = "Done";
        filetypes = [ "norg" ];
      }
      {
        key = "<leader>ntu";
        command = "<CMD>Neorg keybind norg core.norg.qol.todo_items.todo.task_undone<CR>";
        description = "Undone";
        filetypes = [ "norg" ];
      }
      {
        key = "<leader>ntc";
        command = "<CMD>Neorg keybind norg core.norg.qol.todo_items.todo.task_cancel<CR>";
        description = "Cancel";
        filetypes = [ "norg" ];
      }
      {
        key = "<leader>nti";
        command = "<CMD>Neorg keybind norg core.norg.qol.todo_items.todo.task_important<CR>";
        description = "Important";
        filetypes = [ "norg" ];
      }
      {
        key = "<leader>ntp";
        command = "<CMD>Neorg keybind norg core.norg.qol.todo_items.todo.task_pending<CR>";
        description = "Pending";
        filetypes = [ "norg" ];
      }
      {
        key = "]]";
        command = "<CMD>Neorg keybind norg core.integrations.treesitter.next.heading<CR>";
        description = "Heading";
        filetypes = [ "norg" ];
      }
      {
        key = "[[";
        command = "<CMD>Neorg keybind norg core.integrations.treesitter.previous.heading<CR>";
        description = "Heading";
        filetypes = [ "norg" ];
      }
    ] ++ (
      builtins.map
        (k: {
          key = "<leader>nw${k.key}";
          command = "<CMD>Neorg workspace ${k.name}<CR>";
          description = k.name;
        })
        config.nvim.layers.neorg.workspaces
    );
  };
}
