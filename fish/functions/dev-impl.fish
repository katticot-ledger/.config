# Dev Subagent - Deep Implementation Blueprint
# Generate thorough, step-by-step execution blueprints for existing Linear tickets/epics

function dev-impl --description "Dev Impl - Generate detailed implementation blueprints for existing Linear tickets/epics (step-by-step execution)"
    set --local prompts_dir "prompts"

    if not test -d "$prompts_dir"
        echo "❌ Error: prompts directory not found at $prompts_dir"
        echo "Please ensure all prompt files are created in the current directory."
        return 1
    end

    if not test -f "$prompts_dir/dev_shared_header.md"
        echo "❌ Error: Required prompt file not found: dev_shared_header.md"
        return 1
    end

    if not test -f "$prompts_dir/dev_ticket_prompt.md"
        echo "❌ Error: Required prompt file not found: dev_ticket_prompt.md"
        return 1
    end

    if test (count $argv) -eq 0
        echo "📋 Usage: dev-impl \"<ticket parameters>\""
        echo "Example: dev-impl \"TICKET_ID='VSA-500'\""
        return 1
    end

    set --local sys_prompt (cat $prompts_dir/dev_shared_header.md | string collect)
    set --local mode_prompt (cat $prompts_dir/dev_ticket_prompt.md | string collect)
    set --local payload $argv[1]

    echo "🔨 Creating implementation blueprint..."
    clazl \
        --system-prompt "$sys_prompt" \
        --append-system-prompt "$mode_prompt" \
        -- "$payload"
end
