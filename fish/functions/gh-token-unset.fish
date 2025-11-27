function gh-token-unset
    # Unset GH_TOKEN from current session
    set -e GH_TOKEN

    # Also unset from universal variables if it's set there
    set -Ue GH_TOKEN

    echo "✅ GH_TOKEN has been unset from current session"
    echo "💡 Run 'gh auth login' to let GitHub CLI manage credentials instead"
end