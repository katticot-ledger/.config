# Dev Subagent - Implementation Verification
# Validate implementations and move tickets to In Review if checks pass

function dev-verify --description "Dev Verify - Validate implementations and move tickets to In Review (acceptance criteria, tests, quality checks)"
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

    if not test -f "$prompts_dir/dev_verify_prompt.md"
        echo "❌ Error: Required prompt file not found: dev_verify_prompt.md"
        return 1
    end

    if test (count $argv) -eq 0
        echo "📋 Usage: dev-verify \"<verification parameters>\""
        echo "Example: dev-verify \"TICKET_ID='VSA-500'; PR_LINK='https://github.com/.../pull/123'\""
        return 1
    end

    set --local sys_prompt (cat $prompts_dir/dev_shared_header.md | string collect)
    set --local mode_prompt (cat $prompts_dir/dev_verify_prompt.md | string collect)
    set --local payload $argv[1]

    echo "✅ Verifying implementation..."
    clazl \
        --system-prompt "$sys_prompt" \
        --append-system-prompt "$mode_prompt" \
        -- "$payload"
end
