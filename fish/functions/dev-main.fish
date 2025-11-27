# Dev Subagent - Main Implementation Planning
# Generate senior-level implementation plans for existing Linear tickets/epics

function dev-main --description "Dev Main - Generate implementation plans for existing Linear tickets/epics (sets status to In Progress)"
    set --local prompts_dir prompts

    if not test -d "$prompts_dir"
        echo "❌ Error: prompts directory not found at $prompts_dir"
        return 1
    end
    if not test -f "$prompts_dir/dev_shared_header.md"
        echo "❌ Error: Required prompt file not found: dev_shared_header.md"
        return 1
    end
    if not test -f "$prompts_dir/dev_main_prompt.md"
        echo "❌ Error: Required prompt file not found: dev_main_prompt.md"
        return 1
    end
    if test (count $argv) -eq 0
        echo "📋 Usage: dev-main <TICKET_ID or payload>"
        echo "Examples:"
        echo "  dev-main NOE-22"
        echo "  dev-main \"TICKET_ID='VSA-500'\""
        return 1
    end

    # Collapse prompt files into single-argument strings (prevents option parsing on '-' lines)
    set --local sys_prompt (cat $prompts_dir/dev_shared_header.md   | string collect)
    set --local mode_prompt (cat $prompts_dir/dev_main_prompt.md     | string collect)

    # If user passed a lone ID, wrap it as TICKET_ID='ID'; otherwise pass as-is.
    set --local input $argv[1]
    set --local payload $input
    if not string match -q '*=*' -- $input
        set payload "TICKET_ID='$input'"
    end

    echo "🔧 Generating implementation plan..."
    clal \
        --system-prompt "$sys_prompt" \
        --append-system-prompt "$mode_prompt" \
        -- "$payload"
end
