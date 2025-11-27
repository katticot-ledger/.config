# Tech Lead Subagent Setup Function
# Setup and validate Tech Lead subagent environment

function tl-setup --description "TL Setup - Validate TL environment, prompt files, and clazl command availability"
    set --local prompts_dir "prompts"

    echo "🚀 Setting up Tech Lead Subagent environment for VSA..."
    echo ""

    # Check if prompts directory exists
    if not test -d "$prompts_dir"
        echo "❌ Error: prompts directory not found at $prompts_dir"
        echo "Please ensure all prompt files are created in the current directory."
        return 1
    end

    # Check if required prompt files exist
    set --local required_prompts shared_header.md merge_gate_prompt.md ticket_creation_prompt.md architectural_review_prompt.md

    for prompt in $required_prompts
        if not test -f "$prompts_dir/$prompt"
            echo "❌ Error: Required prompt file not found: $prompt"
            return 1
        end
    end

    echo "✅ All required prompt files found"
    echo ""

    # Test that clazl command exists
    if command -v clazl >/dev/null 2>&1
        echo "✅ clazl command found"
    else
        echo "⚠️  Warning: 'clazl' command not found in PATH"
        echo "   Make sure clazl CLI is installed and accessible"
    end

    echo ""
    echo "🔧 Testing prompt file access..."
    for prompt in $required_prompts
        if test -r "$prompts_dir/$prompt"
            echo "✅ $prompt - readable"
        else
            echo "❌ $prompt - not readable"
        end
    end

    echo ""
    echo "🎯 Tech Lead Subagents are ready to use!"
    echo ""
    echo "Available commands:"
    echo "  tl-merge    - Review and approve code merges"
    echo "  tl-tickets  - Create Linear tickets from requests"
    echo "  tl-review   - Review design proposals"
    echo "  tl-setup    - Validate the setup"
    echo ""
    echo "Usage examples:"
    echo "  tl-merge \"Review PR #42 for VSA-123\""
    echo "  tl-tickets \"Create tickets for user authentication feature\""
    echo "  tl-review \"Review database schema changes in docs/schema-v2.md\""
end