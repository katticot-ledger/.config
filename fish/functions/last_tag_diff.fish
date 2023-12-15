function last_tag_diff
    # Fetch tags from remote
    git fetch --tags

    # Get the latest tag
    set last_tag (git for-each-ref --sort=-creatordate --format '%(refname:short)' refs/tags | head -n 1)

    # Show the latest tag for reference
    echo "Last Tag: $last_tag"

    # Perform the diff
    git log --oneline --no-merges $last_tag..main
    # Perform the diff, extract VG patterns, and remove duplicates
    set vg_patterns (git log $last_tag..main --pretty=format:%s | string match -r 'VG-\d+' | sort | uniq)

    # Copy the output to clipboard
    # For macOS:
    echo $vg_patterns | tr ' ' ',' | pbcopy
end
