# Nushell Environment Config File
#
# version = "0.84.0"


# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    # ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    # ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
$env.PATH = (
  $env.PATH | split row (char esep)
  | prepend '/run/current-system/sw/bin/'
  | prepend '/nix/var/nix/profiles/default/bin/'
  | prepend '~/.nix-profile/bin/'
  | prepend @atuin@/bin
  | prepend @direnv@/bin
  | append '/usr/local/bin'
)
$env.SHELL = $env.HOME + "/.nix-profile/bin/nu"
$env.GPG_TTY = $"(tty)"
$env.EDITOR = "nvim"
$env.ATUIN_SESSION = (^@atuin@/bin/atuin uuid)

