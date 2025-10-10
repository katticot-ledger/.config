# Always installs bindings for insert and default mode for simplicity and b/c it has almost no side-effect
# https://gitter.im/fish-shell/fish-shell?at=60a55915ee77a74d685fa6b1
#
# NAME
#   fzf_configure_bindings - Configure fzf key bindings for Fish shell
#
# SYNOPSIS
#   fzf_configure_bindings [OPTIONS]
#
# DESCRIPTION
#   Installs default key bindings for fzf.fish with customizable overrides. Configures
#   keyboard shortcuts in both insert and default modes for various fzf search functions.
#   Provides interactive access to directory search, git log, git status, history,
#   process list, and variable search.
#
# OPTIONS
#   -h, --help              Show help message and exit
#
#   --directory=KEY         Override key sequence for directory search (default: Alt+f)
#   --git_log=KEY           Override key sequence for git log search (default: Alt+l)
#   --git_status=KEY        Override key sequence for git status search (default: Alt+s)
#   --history=KEY           Override key sequence for history search (default: Ctrl+r)
#   --processes=KEY         Override key sequence for process search (default: Alt+p)
#   --variables=KEY         Override key sequence for variable search (default: Ctrl+v)
#
# DEFAULT KEY BINDINGS
#   Alt+f   (_fzf_search_directory)  Fuzzy find and cd to directories
#   Alt+l   (_fzf_search_git_log)    Search and view git commit history
#   Alt+s   (_fzf_search_git_status) Search and view git status files
#   Ctrl+r  (_fzf_search_history)    Search and execute command history
#   Alt+p   (_fzf_search_processes)  Search and manage processes
#   Ctrl+v  (_fzf_search_vars_command) Search and view shell variables
#
# FEATURES
#   - Binds in both insert and default modes
#   - Clean installation with automatic cleanup of existing bindings
#   - Support for custom key sequences
#   - Help system with usage information
#
# DEPENDENCIES
#   fzf (fuzzy finder)
#   fzf.fish plugin (provides the _fzf_search_* functions)
#
# EXAMPLES
#   fzf_configure_bindings                    # Install with default keys
#   fzf_configure_bindings --help             # Show help
#   fzf_configure_bindings --history=Ctrl+R   # Use different key for history
#   fzf_configure_bindings --directory=Ctrl+f # Override directory search key
#
# KEY SYNTAX
#   Key sequences use Fish shell binding syntax:
#   - Ctrl+c: \cc
#   - Alt+f:  \ef
#   - Ctrl+r: \cr
#   - Enter:   \e
#
# NOTES
#   - Only installs in interactive mode or during CI testing
#   - Automatically uninstalls existing fzf bindings before installation
#   - Creates _fzf_uninstall_bindings function for cleanup
#
# SEE ALSO
#   fzf(1) fish(1) bind(1)
#
function fzf_configure_bindings --description "Configure fzf key bindings for Fish shell"
    # no need to install bindings if not in interactive mode or running tests
    status is-interactive || test "$CI" = true; or return

    set -f options_spec h/help 'directory=?' 'git_log=?' 'git_status=?' 'history=?' 'processes=?' 'variables=?'
    argparse --max-args=0 --ignore-unknown $options_spec -- $argv 2>/dev/null
    if test $status -ne 0
        echo "Invalid option or a positional argument was provided." >&2
        _fzf_configure_bindings_help
        return 22
    else if set --query _flag_help
        _fzf_configure_bindings_help
        return
    else
        # Initialize with default key sequences and then override or disable them based on flags
        # index 1 = directory, 2 = git_log, 3 = git_status, 4 = history, 5 = processes, 6 = variables
        set -f key_sequences \e\cf \e\cl \e\cs \cr \e\cp \cv # \c = control, \e = escape
        set --query _flag_directory && set key_sequences[1] "$_flag_directory"
        set --query _flag_git_log && set key_sequences[2] "$_flag_git_log"
        set --query _flag_git_status && set key_sequences[3] "$_flag_git_status"
        set --query _flag_history && set key_sequences[4] "$_flag_history"
        set --query _flag_processes && set key_sequences[5] "$_flag_processes"
        set --query _flag_variables && set key_sequences[6] "$_flag_variables"

        # If fzf bindings already exists, uninstall it first for a clean slate
        if functions --query _fzf_uninstall_bindings
            _fzf_uninstall_bindings
        end

        for mode in default insert
            test -n $key_sequences[1] && bind --mode $mode $key_sequences[1] _fzf_search_directory
            test -n $key_sequences[2] && bind --mode $mode $key_sequences[2] _fzf_search_git_log
            test -n $key_sequences[3] && bind --mode $mode $key_sequences[3] _fzf_search_git_status
            test -n $key_sequences[4] && bind --mode $mode $key_sequences[4] _fzf_search_history
            test -n $key_sequences[5] && bind --mode $mode $key_sequences[5] _fzf_search_processes
            test -n $key_sequences[6] && bind --mode $mode $key_sequences[6] "$_fzf_search_vars_command"
        end

        function _fzf_uninstall_bindings --inherit-variable key_sequences
            bind --erase -- $key_sequences
            bind --erase --mode insert -- $key_sequences
        end
    end
end
