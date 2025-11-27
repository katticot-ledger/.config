# Tech Lead Subagent - Merge Gate Mode
# Review and approve code merges

function tl-merge --description "TL Merge - Review and approve code merges (PR reviews, code quality, merge gate)"
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

    if not test -f "$prompts_dir/merge_gate_prompt.md"
        echo "❌ Error: Required prompt file not found: merge_gate_prompt.md"
        return 1
    end

    if test (count $argv) -eq 0
        echo "📋 Usage: tl-merge \"<description of merge to review>\""
        echo "Example: tl-merge \"Review PR #42 for VSA-123\""
        return 1
    end

    set --local sys_prompt (cat $prompts_dir/shared_header.md | string collect)
    set --local mode_prompt (cat $prompts_dir/merge_gate_prompt.md | string collect)
    set --local payload $argv[1]

    echo "🚀 Starting Merge Gate review..."
    clazl \
        --system-prompt "$sys_prompt" \
        --append-system-prompt "$mode_prompt" \
        -- "$payload"
end
