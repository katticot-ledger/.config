# Tech Lead Subagent - Architectural Review Mode
# Review design proposals

function tl-review --description "TL Review - Review architectural designs, schemas, and technical proposals"
    set --local prompts_dir prompts

    if not test -d "$prompts_dir"
        echo "❌ Error: prompts directory not found at $prompts_dir"
        echo "Please ensure all prompt files are created in the current directory."
        return 1
    end

    if not test -f "$prompts_dir/shared_header.md"
        echo "❌ Error: Required prompt file not found: shared_header.md"
        return 1
    end

    if not test -f "$prompts_dir/architectural_review_prompt.md"
        echo "❌ Error: Required prompt file not found: architectural_review_prompt.md"
        return 1
    end

    if test (count $argv) -eq 0
        echo "📋 Usage: tl-review \"<description of architecture to review>\""
        echo "Example: tl-review \"Review database schema changes in docs/schema-v2.md\""
        return 1
    end

    set --local sys_prompt (cat $prompts_dir/shared_header.md | string collect)
    set --local mode_prompt (cat $prompts_dir/architectural_review_prompt.md | string collect)
    set --local payload $argv[1]

    echo "🏗️ Starting architectural review..."
    clal \
        --system-prompt "$sys_prompt" \
        --append-system-prompt "$mode_prompt" \
        -- "$payload"
end
