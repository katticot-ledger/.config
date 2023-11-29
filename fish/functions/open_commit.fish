function open_commit
    # Define the minimum tag
    set min_tag "7.26.0"

    # Select the starting tag using fzf, only listing tags greater than the minimum tag
    set start_tag (git tag | sort -V | awk -v min_tag="$min_tag" '$1 > min_tag' | fzf)

    # Check if a start tag was selected
    if test -z "$start_tag"
        echo "No start tag selected."
        return 1
    end

    # Select the end tag using fzf, only listing tags greater than the minimum tag
    set end_tag (git tag | sort -V | awk -v min_tag="$start_tag" '$1 > min_tag' | fzf)

    # Check if an end tag was selected
    if test -z "$end_tag"
        echo "No end tag selected."
        return 1
    end

    # Fetch the commit SHA using git log and fzf
    set commit_sha (git log $start_tag..$end_tag --oneline | fzf | string split " " | head -n 1)

    # Check if a commit SHA was selected
    if test -z "$commit_sha"
        echo "No commit selected."
        return 1
    end

    # Use the commit SHA in the open command
    open -a Arc "https://github.com/LedgerHQ/ledger-vault-front/commit/$commit_sha"
end
