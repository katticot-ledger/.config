# ovf: semantic search over OpenViking with fzf. Prints the picked viking:// URIs.
# Backend logic lives in ~/.local/bin/ovf-helper (POSIX sh, called by fzf).
# Exit status: 0 picked, 1 nothing to pick, 2 bad usage / missing tool, 130 cancelled.
function ovf --description 'fzf picker over ov find; prints picked viking:// URIs'
    argparse -n ovf h/help 'n/limit=' 'u/uri=' 't/threshold=' 'L/level=' \
        'T/context-type=' 'after=' 'before=' 'tags=' c/chunks -- $argv
    or return 2

    if set -q _flag_help
        echo "usage: ovf [options] [query...]   (ovf -- -query for a leading dash)

One row per video: title │ category │ N matches (summary + transcript parts).
Enter prints the summary URI. Type to search again; ctrl-k lists all keys.
Options (most are passed to ov find):
  -n, --limit N          rows to show (default 30; fetches 3x, min 100)
  -c, --chunks           start with one row per matched file
  -u, --uri URI          search under this viking:// subtree
  -t, --threshold S      minimum score
  -L, --level 0,1,2      levels: 0 abstract, 1 overview, 2 file (default 2)
  -T, --context-type T   memory, resource, skill
      --after T / --before T   e.g. 48h, 7d, 2026-03-10
      --tags a,b         explicit tags

Exit: 0 picked · 1 nothing picked · 2 usage/missing tool · 130 cancelled.
Titles are cached in ~/.cache/ovf/titles.tsv (safe to delete)."
        return 0
    end

    # Check early and bail out (clig.dev).
    set -l helper ~/.local/bin/ovf-helper
    set -l missing
    for tool in ov jq fzf
        command -q $tool; or set -a missing $tool
    end
    test -x $helper; or set -a missing $helper
    if test (count $missing) -gt 0
        echo "ovf: missing: $missing" >&2
        return 2
    end

    set -l extra -L 2
    set -q _flag_level; and set extra -L $_flag_level
    set -q _flag_uri; and set -a extra -u $_flag_uri
    set -q _flag_threshold; and set -a extra -t $_flag_threshold
    set -q _flag_context_type; and set -a extra --context-type $_flag_context_type
    set -q _flag_after; and set -a extra --after $_flag_after
    set -q _flag_before; and set -a extra --before $_flag_before
    set -q _flag_tags; and set -a extra --tags $_flag_tags

    set -l tmp (mktemp -d -t ovf)
    set -lx OVF_N 30
    set -q _flag_limit; and set OVF_N $_flag_limit
    # Over-fetch so grouping by video still fills the list (-n 100 costs the same as -n 30).
    set -lx OVF_FETCH_N (math "max(100, $OVF_N * 3)")
    set -lx OVF_ARGS (string join ' ' -- $extra)
    set -lx OVF_ERR $tmp/err
    set -lx OVF_LASTQ $tmp/q
    set -lx OVF_RAW $tmp/raw
    set -lx OVF_MODE $tmp/mode
    # fzf reports FZF_COLUMNS=0 on its start event; the helper falls back to this.
    set -lx OVF_COLS $COLUMNS
    set -l prompt 'ov> '
    if set -q _flag_chunks
        echo chunk >$OVF_MODE
        set prompt 'ov chunks> '
    end

    set -l query (string join ' ' -- $argv)
    set -l footer 'type to search · ctrl-k keys'
    test -n "$query"; and set footer 'searching…'

    set -l pager 'less -R'
    command -q bat; and set pager 'bat -l md --paging=always --style=plain'
    set -l view "ov read \"\$($helper accept {f})\" 2>&1 | $pager"

    fzf --ansi --multi --disabled --with-shell 'sh -c' --layout reverse \
        --query "$query" --prompt $prompt \
        --delimiter '\t' --with-nth 1 \
        --marker '+' --info inline-right \
        --footer $footer \
        --preview "$helper preview doc {2} {3} {4} {5} {6} {7}" --preview-label ' doc ' \
        --preview-window 'right,55%,wrap,<66(down,50%,wrap)' \
        --bind "start:reload:$helper fetch {q}" \
        --bind "change:transform:$helper change" \
        --bind "result:transform-footer:$helper footer" \
        --bind "ctrl-f:transform:$helper mode" \
        --bind "ctrl-t:transform:$helper toggle" \
        --bind "ctrl-o:transform:$helper cycle" \
        --bind "ctrl-k:transform:$helper keys-toggle" \
        --bind "enter:transform:$helper enter" \
        --bind "ctrl-v:execute:$view" \
        --bind "alt-enter:become:$view" \
        --bind "ctrl-y:execute-silent($helper accept {+f} | pbcopy)+change-footer(copied to clipboard)" \
        --bind "ctrl-e:execute:$helper errors | less -R" \
        --bind "resize:reload:$helper refetch" \
        --bind 'ctrl-/:change-preview-window(down,50%|hidden|right,55%)'
    set -l st $status
    rm -rf $tmp
    return $st
end
