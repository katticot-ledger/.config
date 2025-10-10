#
# NAME
#   fls - list fish functions with descriptions (Click-like)
#
# SYNOPSIS
#   fls [OPTIONS] [PATTERN]
#
# DESCRIPTION
#   Lists functions found in directories from `fish_function_path` and prints a
#   concise, Click-style table of name and description. The listing hides
#   internal helper names (`__*`, `_*`) by default unless `--all` is used.
#
# OPTIONS
#   -a, --all        Include internal helper names
#   -b, --builtin    Only functions from system paths
#   -u, --user       Only functions from user paths
#   -p, --paths      Show the source file path
#   -1, --names      Print names only (one per line)
#   -g, --grep TEXT  Filter by TEXT in name or description
#   -l, --long       Extended details (implies --paths)
#   -d, --doc        Show leading documentation comments for each function
#   -h, --help       Show help and exit
#
# EXAMPLES
#   fls
#   fls -g prompt
#   fls -p -u
#   fls --builtin --all
#
# SEE ALSO
#   functions(1) fish(1)
#
function fls --description "List fish functions with their descriptions (Click-like)."
    # Requirements: fish >= 3.4 (uses `argparse`, `string`), standard `find`, `sort`, `sed`, `awk`.

    # Print help (Click-like style)
    function __fls_help
        echo "Usage: fls [OPTIONS] [PATTERN]"
        echo
        echo "List fish functions with their descriptions."
        echo
        echo "Options:"
        echo "  -a, --all          Include internal names (e.g., __fish*)"
        echo "  -b, --builtin      Only functions from system paths"
        echo "  -u, --user         Only functions from user paths"
        echo "  -p, --paths        Show file path for each function"
        echo "  -1, --names        Print names only"
        echo "  -g, --grep TEXT    Filter by TEXT in name or description"
        echo "  -l, --long         Show extended details (adds path if available)"
        echo "  -d, --doc          Show leading documentation comments"
        echo "  -h, --help         Show this message and exit"
        echo
        echo "Examples:"
        echo "  fls                     # list user+system functions (hides __fish by default)"
        echo "  fls -g prompt           # search functions related to 'prompt'"
        echo "  fls -p                  # include definition paths"
        echo "  fls -u                  # only your functions in ~/.config/fish/functions"
        echo "  fls -b -a               # only system functions, include internal helper names"
    end

    # Parse CLI flags (manual, robust across fish versions)
    # Flags are set only when seen; do not predeclare

    while test (count $argv) -gt 0
        set -l a $argv[1]
        switch $a
            case -h --help
                set _flag_help 1
                set argv $argv[2..-1]
                continue
            case -a --all
                set _flag_all 1
                set argv $argv[2..-1]
                continue
            case -b --builtin
                set _flag_builtin 1
                set argv $argv[2..-1]
                continue
            case -u --user
                set _flag_user 1
                set argv $argv[2..-1]
                continue
            case -p --paths
                set _flag_paths 1
                set argv $argv[2..-1]
                continue
            case -1 --names
                set _flag_names 1
                set argv $argv[2..-1]
                continue
            case -l --long
                set _flag_long 1
                set argv $argv[2..-1]
                continue
            case -d --doc
                set _flag_doc 1
                set argv $argv[2..-1]
                continue
            case --grep -g
                if test (count $argv) -lt 2
                    echo "fls: --grep requires an argument" >&2
                    return 2
                end
                set _flag_grep $argv[2]
                set argv $argv[3..-1]
                continue
            case '-g*'
                # Support -gTEXT
                set _flag_grep (string replace -r '^-[g]+' '' -- $a)
                set argv $argv[2..-1]
                continue
            case --
                set argv $argv[2..-1]
                break
            case '-*'
                echo "fls: unknown option $a" >&2
                return 2
            case '*'
                break
        end
        break
    end

    if set -q _flag_help
        __fls_help
        return 0
    end

    # Pattern to filter by (positional or --grep)
    set -l pattern ""
    if set -q _flag_grep
        set pattern $_flag_grep
    else if test (count $argv) -gt 0
        set pattern $argv[1]
    end

    # Gather function search paths
    set -l all_dirs $fish_function_path
    set -l user_root "$HOME/.config/fish"
    set -l user_dirs
    set -l sys_dirs
    for d in $all_dirs
        if string match -q -- "$user_root/*" $d
            set -a user_dirs $d
        else
            set -a sys_dirs $d
        end
    end

    set -l search_dirs
    if set -q _flag_builtin; and set -q _flag_user
        set search_dirs $all_dirs
    else if set -q _flag_builtin
        set search_dirs $sys_dirs
    else if set -q _flag_user
        set search_dirs $user_dirs
    else
        # Default: search all, but hide internal helper names by default
        set search_dirs $all_dirs
    end

    # Helper: extract description from a .fish file, or fallback to leading comments
    function __fls_desc --no-scope-shadowing --argument-names file name
        set -l d ""
        # Try to capture --description "..." or '...'
        set -l line (command grep -m1 -E '^[[:space:]]*function[[:space:]].*--description' -- $file)
        if test -n "$line"
            set -l dd (string replace -r '.*--description[[:space:]]+"([^"]*)".*' '$1' -- $line)
            if test "$dd" != "$line"
                set d $dd
            else
                set -l dd2 (string replace -r ".*--description[[:space:]]+'([^']*)'.*" '$1' -- $line)
                if test "$dd2" != "$line"
                    set d $dd2
                end
            end
        end
        # Fallback: use leading comment block prior to first 'function'
        if test -z "$d"
            set d (command awk '
                BEGIN{desc="";block=1}
                block && /^#/ {line=$0; sub(/^# ?/,"",line); if (desc=="") desc=line; else if (length(desc)<160) desc=desc" "line; next}
                /^function[ ]/ {block=0}
                END{print desc}
            ' $file)
        end
        if test -z "$d"
            set d "—"
        end
        string trim -- $d
    end

    # Helper: extract leading documentation comment block
    function __fls_doc --no-scope-shadowing --argument-names file
        command awk '
            BEGIN{block=1}
            block && /^#/ {line=$0; sub(/^# ?/,"",line); print line; next}
            /^function[ ]/ {block=0}
        ' $file | sed -n '1,80p'
    end

    # Build lists: parallel arrays for names, paths, descs
    set -l TAB (printf "\t")
    set -l names
    set -l paths
    set -l descs
    set -l seen
    set -l maxw 0

    for dir in $search_dirs
        if not test -d $dir
            continue
        end
        for f in (command find -L $dir -maxdepth 1 -type f -name '*.fish' 2>/dev/null | sort)
            set -l base (string replace -r '.*/' '' -- $f)
            set -l name (string replace -r '\\.fish$' '' -- $base)

            # Hide internal helpers unless --all
            if not set -q _flag_all
                if string match -q -- '__*' $name
                    continue
                end
                if string match -q -- '_*' $name
                    continue
                end
            end

            # De-duplicate by name (first path in $fish_function_path wins)
            if contains -- $name $seen
                continue
            end

            set -l desc (__fls_desc $f $name)

            # Filter
            set -l keep 1
            if test -n "$pattern"
                set keep 0
                if string match -qi -- "*$pattern*" $name
                    set keep 1
                else if test -n "$desc"; and string match -qi -- "*$pattern*" $desc
                    set keep 1
                end
            end
            if test $keep -eq 0
                continue
            end

            set -a names $name
            set -a paths $f
            set -a descs $desc
            set -a seen $name
            set -l nlen (string length -- $name)
            if test $nlen -gt $maxw
                set maxw $nlen
            end
        end
    end

    # Nothing to show
    if test (count $names) -eq 0
        if test -n "$pattern"
            echo "fls: no functions match: $pattern" >&2
        else
            echo "fls: no functions found in search paths" >&2
        end
        return 1
    end

    # Output
    if set -q _flag_names
        # names only, sorted case-insensitively
        printf "%s\n" $names | sort -f
        return 0
    end

    set -l show_paths 0
    if set -q _flag_paths; or set -q _flag_long
        set show_paths 1
    end

    # Header (Click-like section label)
    set -l total (count $names)
    echo "Functions ($total)"

    # Print in discovery order (stable)
    for i in (seq (count $names))
        set -l name $names[$i]
        set -l path $paths[$i]
        set -l desc $descs[$i]
        if set -q _flag_doc
            if test $show_paths -eq 1
                printf "%-*s  %s (%s)\n" $maxw "$name" "$desc" "$path"
            else
                printf "%-*s  %s\n" $maxw "$name" "$desc"
            end
            set -l doc (__fls_doc $path)
            if test -n "$doc"
                echo "$doc" | sed 's/^/  /'
            end
            echo
        else
            if test $show_paths -eq 1
                printf "%-*s  %s (%s)\n" $maxw "$name" "$desc" "$path"
            else
                printf "%-*s  %s\n" $maxw "$name" "$desc"
            end
        end
    end
end
