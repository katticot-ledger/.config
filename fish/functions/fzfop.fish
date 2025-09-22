function fzfop --description "FZF 1Password selector; copy item ID to clipboard on Enter"
    # Ensure signed in
    if not op account get >/dev/null 2>&1
        echo "You must sign in to 1Password first using 'op signin'"
        return 1
    end

    # Build list: title<TAB>vault<TAB>id  (vault may be empty)
    set -l list (op item list --format json | jq -r '.[] | "\(.title)\t\(.vault.name // "-")\t\(.id)"')

    if test (count $list) -eq 0
        echo "No 1Password items found."
        return 1
    end

    # FZF: show Title & Vault only, copy ID on Enter (macOS pbcopy)
    printf "%s\n" $list | fzf \
        --with-nth=1,2 \
        --delimiter='\t' \
        --prompt="Select 1Password item > " \
        --bind 'enter:execute-silent(echo {3} | pbcopy)+abort'

    and echo "✅ Item ID copied to clipboard."
end
