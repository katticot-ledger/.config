# Tech Lead Subagent - Ticket Creation Mode
# Create Linear tickets from requests

function tl-tickets --description "TL Tickets - Create Linear tickets from feature requests and specifications"
    set --local prompts_dir "prompts"

    if not test -d "$prompts_dir"
        echo "❌ Error: prompts directory not found at $prompts_dir"
        echo "Please ensure all prompt files are created in the current directory."
        return 1
    end

    if not test -f "$prompts_dir/shared_header.md"
        echo "❌ Error: Required prompt file not found: shared_header.md"
        return 1
    end

    if not test -f "$prompts_dir/ticket_creation_prompt.md"
        echo "❌ Error: Required prompt file not found: ticket_creation_prompt.md"
        return 1
    end

    if test (count $argv) -eq 0
        echo "📋 Usage: tl-tickets \"<description of tickets to create>\""
        echo "Example: tl-tickets \"Create tickets for user authentication feature\""
        return 1
    end

    set --local sys_prompt (cat $prompts_dir/shared_header.md | string collect)
    set --local mode_prompt (cat $prompts_dir/ticket_creation_prompt.md | string collect)
    set --local payload $argv[1]

    echo "🎫 Starting ticket creation..."
    clazl \
        --system-prompt "$sys_prompt" \
        --append-system-prompt "$mode_prompt" \
        -- "$payload"
end
