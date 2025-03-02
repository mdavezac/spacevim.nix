# Nushell Config File
#
# version = "0.84.0"
let dark_theme = {
        binary: '#d3869b'
        block: '#7daea3'
        cell-path: '#d4be98'
        closure: '#89b482'
        custom: '#d4be98'
        duration: '#d8a657'
        float: '#ea6962'
        glob: '#d4be98'
        int: '#d3869b'
        list: '#89b482'
        nothing: '#ea6962'
        range: '#d8a657'
        record: '#89b482'
        string: '#a9b665'

        bool: {|| if $in { '#89b482' } else { '#d8a657' } }

        date: {|| (date now) - $in |
            if $in < 1hr {
                { fg: '#ea6962' attr: 'b' }
            } else if $in < 6hr {
                '#ea6962'
            } else if $in < 1day {
                '#d8a657'
            } else if $in < 3day {
                '#a9b665'
            } else if $in < 1wk {
                { fg: '#a9b665' attr: 'b' }
            } else if $in < 6wk {
                '#89b482'
            } else if $in < 52wk {
                '#7daea3'
            } else { 'dark_gray' }
        }

        filesize: {|e|
            if $e == 0b {
                '#d4be98'
            } else if $e < 1mb {
                '#89b482'
            } else {{ fg: '#7daea3' }}
        }

        shape_and: { fg: '#d3869b' attr: 'b' }
        shape_binary: { fg: '#d3869b' attr: 'b' }
        shape_block: { fg: '#7daea3' attr: 'b' }
        shape_bool: '#89b482'
        shape_closure: { fg: '#89b482' attr: 'b' }
        shape_custom: '#a9b665'
        shape_datetime: { fg: '#89b482' attr: 'b' }
        shape_directory: '#89b482'
        shape_external: '#89b482'
        shape_external_resolved: '#89b482'
        shape_externalarg: { fg: '#a9b665' attr: 'b' }
        shape_filepath: '#89b482'
        shape_flag: { fg: '#7daea3' attr: 'b' }
        shape_float: { fg: '#ea6962' attr: 'b' }
        shape_garbage: { fg: '#FFFFFF' bg: '#FF0000' attr: 'b' }
        shape_glob_interpolation: { fg: '#89b482' attr: 'b' }
        shape_globpattern: { fg: '#89b482' attr: 'b' }
        shape_int: { fg: '#d3869b' attr: 'b' }
        shape_internalcall: { fg: '#89b482' attr: 'b' }
        shape_keyword: { fg: '#d3869b' attr: 'b' }
        shape_list: { fg: '#89b482' attr: 'b' }
        shape_literal: '#7daea3'
        shape_match_pattern: '#a9b665'
        shape_matching_brackets: { attr: 'u' }
        shape_nothing: '#ea6962'
        shape_operator: '#d8a657'
        shape_or: { fg: '#d3869b' attr: 'b' }
        shape_pipe: { fg: '#d3869b' attr: 'b' }
        shape_range: { fg: '#d8a657' attr: 'b' }
        shape_raw_string: { fg: '#d4be98' attr: 'b' }
        shape_record: { fg: '#89b482' attr: 'b' }
        shape_redirection: { fg: '#d3869b' attr: 'b' }
        shape_signature: { fg: '#a9b665' attr: 'b' }
        shape_string: '#a9b665'
        shape_string_interpolation: { fg: '#89b482' attr: 'b' }
        shape_table: { fg: '#7daea3' attr: 'b' }
        shape_vardecl: { fg: '#7daea3' attr: 'u' }
        shape_variable: '#d3869b'

        foreground: '#d4be98'
        background: '#1d2021'
        cursor: '#d4be98'

        empty: '#7daea3'
        header: { fg: '#a9b665' attr: 'b' }
        hints: '#1d2021'
        leading_trailing_space_bg: { attr: 'n' }
        row_index: { fg: '#a9b665' attr: 'b' }
        search_result: { fg: '#ea6962' bg: '#d4be98' }
        separator: '#d4be98'
}

# The default config record. This is where much of your global configuration is setup.
$env.config = {
    show_banner: false # true or false to enable or disable the welcome banner at startup
    color_config: $dark_theme # if you want a more interesting theme, you can replace the empty record with `$dark_theme`, `$light_theme` or another custom record

    ls: {
        use_ls_colors: true # use the LS_COLORS environment variable to colorize output
        clickable_links: true # enable or disable clickable links. Your terminal has to support links.
    }

    rm: {
        always_trash: false # always act as if -t was given. Can be overridden with -p
    }


    explore: {
        try: {
            border_color: {fg: "white"}
        },
        status_bar_background: {fg: "#1D1F21", bg: "#C4C9C6"},
        command_bar_text: {fg: "#C4C9C6"},
        highlight: {fg: "black", bg: "yellow"},
        status: {
            error: {fg: "white", bg: "red"},
            warn: {}
            info: {}
        },
        table: {
            split_line: {fg: "#404040"},
            selected_cell: {},
            selected_row: {},
            selected_column: {},
            show_cursor: true,
            line_head_top: true,
            line_head_bottom: true,
            line_shift: true,
            line_index: true,
        },
        config: {
            border_color: {fg: "white"}
            cursor_color: {fg: "black", bg: "light_yellow"}
        },
    }

    filesize: {
        metric: true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
        format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, auto
    }

    cursor_shape: {
        emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line (line is the default)
        vi_insert: block # block, underscore, line , blink_block, blink_underscore, blink_line (block is the default)
        vi_normal: underscore # block, underscore, line, blink_block, blink_underscore, blink_line (underscore is the default)
    }

    footer_mode: 25 # always, never, number_of_rows, auto
    float_precision: 2 # the precision for displaying floats in tables
    buffer_editor: "" # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
    use_ansi_coloring: true
    bracketed_paste: true # enable bracketed paste, currently useless on windows
    edit_mode: emacs # emacs, vi
    shell_integration: {
        # osc2 abbreviates the path if in the home_dir, sets the tab/window title, shows the running command in the tab/window title
        osc2: true
        # osc7 is a way to communicate the path to the terminal, this is helpful for spawning new tabs in the same directory
        osc7: true
        # osc8 is also implemented as the deprecated setting ls.show_clickable_links, it shows clickable links in ls output if your terminal supports it. show_clickable_links is deprecated in favor of osc8
        osc8: true
        # osc9_9 is from ConEmu and is starting to get wider support. It's similar to osc7 in that it communicates the path to the terminal
        osc9_9: false
        # osc133 is several escapes invented by Final Term which include the supported ones below.
        # 133;A - Mark prompt start
        # 133;B - Mark prompt end
        # 133;C - Mark pre-execution
        # 133;D;exit - Mark execution finished with exit code
        # This is used to enable terminals to know where the prompt is, the command is, where the command finishes, and where the output of the command is
        osc133: true
        # osc633 is closely related to osc133 but only exists in visual studio code (vscode) and supports their shell integration features
        # 633;A - Mark prompt start
        # 633;B - Mark prompt end
        # 633;C - Mark pre-execution
        # 633;D;exit - Mark execution finished with exit code
        # 633;E - NOT IMPLEMENTED - Explicitly set the command line with an optional nonce
        # 633;P;Cwd=<path> - Mark the current working directory and communicate it to the terminal
        # and also helps with the run recent menu in vscode
        osc633: true
        # reset_application_mode is escape \x1b[?1l and was added to help ssh work better
        reset_application_mode: true
    }
    render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.
}


def session-names [] {
  fd "" ~/sapient ~/personal ~/kagenova --max-depth 1 -t d | lines | each { $in | path basename } | uniq
}

export def session [name: string@session-names] {
    let locations  = fd $"($name)$" -t d ~/ --maxdepth 2 | lines
    if ($locations | length) > 0 {
    let location = $locations | first
    let session = $location | path basename
      # cd $location; zellij attach -c $session; cd -
      tmux new-session -As $session -c $location
    } else {
      echo $"Could not find session ($name)"
    }
}
