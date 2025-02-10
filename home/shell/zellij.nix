{config, ...}: {
  programs.zellij.enable = true;
  programs.zellij.settings = {
    default_shell = "nu";
    session_serialization = false;
    plugins = {
      compact-bar._props.location = "zellij:compact-bar";
      configuration._props.location = "zellij:configuration";
      filepicker._props.location = "zellij:strider";
      filepicker.cwd = "~/";
      plugin-manager._props.location = "zellij:plugin-manager";
      session-manager._props.location = "zellij:session-manager";
      status-bar._props.location = "zellij:status-bar";
      strider._props.location = "zellij:strider";
      welcome-screen._props.location = "zellij:session-manager";
      welcome-screen.welcome_screen = true;
    };
    on_force_close = "detach";
    simplified_ui = true;
    pane_frames = false;
    theme = "default";
    default_mode = "locked";
    scroll_buffer_size = 10000;
    scrollback_editor = "nvim";
    keybinds = {
      _props.clear-defaults = true;
      locked."bind \"Ctrl g\"".SwitchToMode = "normal";
      pane = {
        "bind \"left\"".MoveFocus = "left";
        "bind \"down\"".MoveFocus = "down";
        "bind \"up\"".MoveFocus = "up";
        "bind \"right\"".MoveFocus = "right";
        "bind \"c\"".SwitchToMode = "renamepane";
        "bind \"c\"".PaneNameInput = 0;
        "bind \"d\"".NewPane = "down";
        "bind \"d\"".SwitchToMode = "locked";
        "bind \"e\"".TogglePaneEmbedOrFloating = {};
        "bind \"e\"".SwitchToMode = "locked";
        "bind \"f\"".ToggleFocusFullscreen = {};
        "bind \"f\"".SwitchToMode = "locked";
        "bind \"h\"".MoveFocus = "left";
        "bind \"j\"".MoveFocus = "down";
        "bind \"k\"".MoveFocus = "up";
        "bind \"l\"".MoveFocus = "right";
        "bind \"n\"".NewPane = {};
        "bind \"n\"".SwitchToMode = "locked";
        "bind \"p\"" = {SwitchToMode = "normal";};
        "bind \"r\"".NewPane = "right";
        "bind \"r\"".SwitchToMode = "locked";
        "bind \"w\"".ToggleFloatingPanes = {};
        "bind \"w\"".SwitchToMode = "locked";
        "bind \"x\"".CloseFocus = {};
        "bind \"x\"".SwitchToMode = "locked";
        "bind \"z\"".TogglePaneFrames = {};
        "bind \"z\"".SwitchToMode = "locked";
        "bind \"tab\"".SwitchFocus = {};
      };
      tab = {
        "bind \"left\"".GoToPreviousTab = {};
        "bind \"down\"".GoToNextTab = {};
        "bind \"up\"".GoToPreviousTab = {};
        "bind \"right\"".GoToNextTab = {};
        "bind \"1\"".GoToTab = 1;
        "bind \"1\"".SwitchToMode = "locked";
        "bind \"2\"".GoToTab = 2;
        "bind \"2\"".SwitchToMode = "locked";
        "bind \"3\"".GoToTab = 3;
        "bind \"3\"".SwitchToMode = "locked";
        "bind \"4\"".GoToTab = 4;
        "bind \"4\"".SwitchToMode = "locked";
        "bind \"5\"".GoToTab = 5;
        "bind \"5\"".SwitchToMode = "locked";
        "bind \"6\"".GoToTab = 6;
        "bind \"6\"".SwitchToMode = "locked";
        "bind \"7\"".GoToTab = 7;
        "bind \"7\"".SwitchToMode = "locked";
        "bind \"8\"".GoToTab = 8;
        "bind \"8\"".SwitchToMode = "locked";
        "bind \"9\"".GoToTab = 9;
        "bind \"9\"".SwitchToMode = "locked";
        "bind \"[\"".BreakPaneLeft = {};
        "bind \"[\"".SwitchToMode = "locked";
        "bind \"]\"".BreakPaneRight = {};
        "bind \"]\"".SwitchToMode = "locked";
        "bind \"b\"".BreakPane = {};
        "bind \"b\"".SwitchToMode = "locked";
        "bind \"h\"".GoToPreviousTab = {};
        "bind \"j\"".GoToNextTab = {};
        "bind \"k\"".GoToPreviousTab = {};
        "bind \"l\"".GoToNextTab = {};
        "bind \"n\"".NewTab = {};
        "bind \"n\"".SwitchToMode = "locked";
        "bind \"r\"".SwitchToMode = "renametab";
        "bind \"r\"".TabNameInput = 0;
        "bind \"s\"".ToggleActiveSyncTab = {};
        "bind \"s\"".SwitchToMode = "locked";
        "bind \"t\"".SwitchToMode = "normal";
        "bind \"x\"".CloseTab = {};
        "bind \"x\"".SwitchToMode = "locked";
        "bind \"tab\"".ToggleTab = {};
      };
      resize = {
        "bind \"left\"".Resize = "Increase left";
        "bind \"down\"".Resize = "Increase down";
        "bind \"up\"".Resize = "Increase up";
        "bind \"right\"".Resize = "Increase right";
        "bind \"+\"".Resize = "Increase";
        "bind \"-\"".Resize = "Decrease";
        "bind \"=\"".Resize = "Increase";
        "bind \"H\"".Resize = "Decrease left";
        "bind \"J\"".Resize = "Decrease down";
        "bind \"K\"".Resize = "Decrease up";
        "bind \"L\"".Resize = "Decrease right";
        "bind \"h\"".Resize = "Increase left";
        "bind \"j\"".Resize = "Increase down";
        "bind \"k\"".Resize = "Increase up";
        "bind \"l\"".Resize = "Increase right";
        "bind \"r\"".SwitchToMode = "normal";
      };
      move = {
        "bind \"left\"".MovePane = "left";
        "bind \"down\"".MovePane = "down";
        "bind \"up\"".MovePane = "up";
        "bind \"right\"".MovePane = "right";
        "bind \"h\"".MovePane = "left";
        "bind \"j\"".MovePane = "down";
        "bind \"k\"".MovePane = "up";
        "bind \"l\"".MovePane = "right";
        "bind \"m\"".SwitchToMode = "normal";
        "bind \"n\"".MovePane = {};
        "bind \"p\"".MovePaneBackwards = {};
        "bind \"tab\"".MovePane = {};
      };
      scroll = {
        "bind \"Alt left\"".MoveFocusOrTab = "left";
        "bind \"Alt left\"".SwitchToMode = "locked";
        "bind \"Alt down\"".MoveFocus = "down";
        "bind \"Alt down\"".SwitchToMode = "locked";
        "bind \"Alt up\"".MoveFocus = "up";
        "bind \"Alt up\"".SwitchToMode = "locked";
        "bind \"Alt right\"".MoveFocusOrTab = "right";
        "bind \"Alt right\"".SwitchToMode = "locked";
        "bind \"e\"".EditScrollback = {};
        "bind \"e\"". SwitchToMode = "locked";
        "bind \"f\"".SwitchToMode = "entersearch";
        "bind \"f\"".SearchInput = 0;
        "bind \"Alt h\"".MoveFocusOrTab = "left";
        "bind \"Alt h\"".SwitchToMode = "locked";
        "bind \"Alt j\"".MoveFocus = "down";
        "bind \"Alt j\"".SwitchToMode = "locked";
        "bind \"Alt k\"".MoveFocus = "up";
        "bind \"Alt k\"".SwitchToMode = "locked";
        "bind \"Alt l\"".MoveFocusOrTab = "right";
        "bind \"Alt l\"".SwitchToMode = "locked";
        "bind \"s\"".SwitchToMode = "normal";
      };
      search = {
        "bind \"c\"".SearchToggleOption = "CaseSensitivity";
        "bind \"n\"".Search = "down";
        "bind \"o\"".SearchToggleOption = "WholeWord";
        "bind \"p\"".Search = "up";
        "bind \"w\"".SearchToggleOption = "Wrap";
      };
      session = {
        "bind \"c\"" = {
          LaunchOrFocusPlugin._args = ["configuration"];
          LaunchOrFocusPlugin.floating = true;
          LaunchOrFocusPlugin.move_to_focused_tab = true;
          SwitchToMode = "locked";
        };
        "bind \"d\"".Detach = {};
        "bind \"o\"".SwitchToMode = "normal";
        "bind \"p\"" = {
          LaunchOrFocusPlugin._args = ["plugin-manager"];
          LaunchOrFocusPlugin.floating = true;
          LaunchOrFocusPlugin.move_to_focused_tab = true;
          SwitchToMode = "locked";
        };
        "bind \"w\"" = {
          LaunchOrFocusPlugin._args = ["session-manager"];
          LaunchOrFocusPlugin.floating = true;
          LaunchOrFocusPlugin.move_to_focused_tab = true;
          SwitchToMode = "locked";
        };
      };
      shared_among = {
        _args = ["normal" "locked"];
        "bind \"Alt left\"".MoveFocusOrTab = "left";
        "bind \"Alt down\"".MoveFocus = "down";
        "bind \"Alt up\"".MoveFocus = "up";
        "bind \"Alt right\"".MoveFocusOrTab = "right";
        "bind \"Alt +\"".Resize = "Increase";
        "bind \"Alt -\"".Resize = "Decrease";
        "bind \"Alt =\"".Resize = "Increase";
        "bind \"Alt [\"".PreviousSwapLayout = {};
        "bind \"Alt ]\"".NextSwapLayout = {};
        "bind \"Alt f\"".ToggleFloatingPanes = {};
        "bind \"Alt h\"".MoveFocusOrTab = "left";
        "bind \"Alt i\"".MoveTab = "left";
        "bind \"Alt j\"".MoveFocus = "down";
        "bind \"Alt k\"".MoveFocus = "up";
        "bind \"Alt l\"".MoveFocusOrTab = "right";
        "bind \"Alt n\"".NewPane = {};
        "bind \"Alt o\"".MoveTab = "right";
      };
      "shared_except \"locked\"" = {
        "bind \"Alt f\"" = {
          LaunchOrFocusPlugin._args = ["filepicker"];
          LaunchOrFocusPlugin.floating = true;
          LaunchOrFocusPlugin.close_on_selection = true;
        };
      };
      "shared_except \"locked\" \"renametab\" \"renamepane\"" = {
        "bind \"Ctrl g\"".SwitchToMode = "locked";
        "bind \"Alt q\"".Quit = {};
      };
      "shared_except \"locked\" \"entersearch\"" = {
        "bind \"enter\"".SwitchToMode = "locked";
      };
      "shared_except \"locked\" \"entersearch\" \"renametab\" \"renamepane\"" = {
        "bind \"esc\"".SwitchToMode = "locked";
      };
      "shared_except \"locked\" \"entersearch\" \"renametab\" \"renamepane\" \"move\"" = {
        "bind \"m\"".SwitchToMode = "move";
      };
      "shared_except \"locked\" \"entersearch\" \"search\" \"renametab\" \"renamepane\" \"session\"" = {
        "bind \"o\"".SwitchToMode = "session";
      };
      "shared_except \"locked\" \"tab\" \"entersearch\" \"renametab\" \"renamepane\"" = {
        "bind \"t\"".SwitchToMode = "tab";
      };
      "shared_except \"locked\" \"tab\" \"scroll\" \"entersearch\" \"renametab\" \"renamepane\"" = {
        "bind \"s\"".SwitchToMode = "scroll";
      };
      "shared_among \"normal\" \"resize\" \"tab\" \"scroll\" \"prompt\" \"tmux\"" = {
        "bind \"p\"".SwitchToMode = "pane";
      };
      shared_except = {
        _args = ["locked" "resize" "pane" "tab" "entersearch" "renametab" "renamepane"];
        "bind \"r\"".SwitchToMode = "resize";
      };
      "shared_among \"scroll\" \"search\"" = {
        "bind \"PageDown\"".PageScrollDown = {};
        "bind \"PageUp\"".PageScrollUp = {};
        "bind \"left\"".PageScrollUp = {};
        "bind \"down\"".ScrollDown = {};
        "bind \"up\"".ScrollUp = {};
        "bind \"right\"".PageScrollDown = {};
        "bind \"Ctrl b\"".PageScrollUp = {};
        "bind \"Ctrl c\"".ScrollToBottom = {};
        "bind \"Ctrl c\"".SwitchToMode = "locked";
        "bind \"d\"".HalfPageScrollDown = {};
        "bind \"Ctrl f\"".PageScrollDown = {};
        "bind \"h\"".PageScrollUp = {};
        "bind \"j\"".ScrollDown = {};
        "bind \"k\"".ScrollUp = {};
        "bind \"l\"".PageScrollDown = {};
        "bind \"u\"".HalfPageScrollUp = {};
      };
      entersearch = {
        "bind \"Ctrl c\"".SwitchToMode = "scroll";
        "bind \"esc\"".SwitchToMode = "scroll";
        "bind \"enter\"".SwitchToMode = "search";
      };
      renametab = {
        "bind \"esc\"".UndoRenameTab = {};
        "bind \"esc\"".SwitchToMode = "tab";
      };
      "shared_among \"renametab\" \"renamepane\"" = {
        "bind \"Ctrl c\"".SwitchToMode = "locked";
      };
      renamepane = {
        "bind \"esc\"".UndoRenamePane = {};
        "bind \"esc\"".SwitchToMode = "pane";
      };
    };
  };
}
