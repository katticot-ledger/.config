# Dev Subagent Setup Function
# Setup and validate Dev subagent environment

function dev-setup --description "Dev Setup - Validate Dev environment, prompt files, dev.md, and clazl command availability"
    set --local prompts_dir "prompts"

    echo "🔧 Setting up Dev Subagent environment..."
    echo ""

    # Check if prompts directory exists
    if not test -d "$prompts_dir"
        echo "❌ Error: prompts directory not found at $prompts_dir"
        echo "Please ensure all prompt files are created in the current directory."
        return 1
    end

    # Check if required prompt files exist
    set --local required_prompts dev_shared_header.md dev_main_prompt.md dev_ticket_prompt.md dev_verify_prompt.md

    for prompt in $required_prompts
        if not test -f "$prompts_dir/$prompt"
            echo "❌ Error: Required prompt file not found: $prompt"
            return 1
        end
    end

    echo "✅ All required Dev prompt files found"
    echo ""

    # Check if dev.md exists in current directory
    if not test -f "dev.md"
        echo "❌ Error: dev.md configuration file not found in current directory"
        echo "Please create dev.md with project configuration"
        return 1
    else
        echo "✅ dev.md configuration file found"
    end

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
    echo "🎯 Dev Subagents are ready to use!"
    echo ""
    echo "Available commands:"
    echo "  dev-main    - Generate implementation plans for existing tickets"
    echo "  dev-impl    - Generate detailed implementation blueprints"
    echo "  dev-verify  - Validate implementations and move to In Review"
    echo "  dev-setup   - Validate the Dev setup"
    echo ""
    echo "Usage examples:"
    echo "  dev-main \"TICKET_ID='VSA-500'\""
    echo "  dev-impl \"TICKET_ID='VSA-500'\""
    echo "  dev-verify \"TICKET_ID='VSA-500'; PR_LINK='https://github.com/.../pull/123\""
    echo ""
    echo "Note: Dev agents work only on existing Linear tickets/epics and do not create new tickets."
end