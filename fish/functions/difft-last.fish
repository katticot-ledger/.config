function difft-last
    for f in (git diff --name-only HEAD~1 HEAD)
        set sanitized (string replace -ar '/' '_' -- "$f")
        git show HEAD~1:"$f" > /tmp/old_$sanitized 2>/dev/null; or touch /tmp/old_$sanitized
        git show HEAD:"$f" > /tmp/new_$sanitized 2>/dev/null; or touch /tmp/new_$sanitized
        echo "=== $f ==="
        difft /tmp/old_$sanitized /tmp/new_$sanitized
        rm -f /tmp/old_$sanitized /tmp/new_$sanitized
    end
end
