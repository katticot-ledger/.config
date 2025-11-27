# QA Subagent - Feature Testing
# Run feature-specific QA tests

function qa-feature --description "QA Feature - Run feature-specific QA tests (acceptance criteria, entry points, feature validation)"
    set --local prompts_dir "prompts"

    if not test -d "$prompts_dir"
        echo "❌ Error: prompts directory not found at $prompts_dir"
        echo "Please ensure all prompt files are created in the current directory."
        return 1
    end

    if not test -f "$prompts_dir/qa_shared_header.md"
        echo "❌ Error: Required prompt file not found: qa_shared_header.md"
        return 1
    end

    if not test -f "$prompts_dir/qa_feature_prompt.md"
        echo "❌ Error: Required prompt file not found: qa_feature_prompt.md"
        return 1
    end

    if test (count $argv) -eq 0
        echo "📋 Usage: qa-feature \"<feature parameters>\""
        echo "Example: qa-feature \"FEATURE_NAME='Snapshot Diff Viewer'; ENTRY_POINTS='/viewer'; ACCEPTANCE_CRITERIA='AC1,AC2,AC3'\""
        return 1
    end

    set --local sys_prompt (cat $prompts_dir/qa_shared_header.md | string collect)
    set --local mode_prompt (cat $prompts_dir/qa_feature_prompt.md | string collect)
    set --local payload $argv[1]

    echo "🔍 Running feature QA..."
    clazl \
        --system-prompt "$sys_prompt" \
        --append-system-prompt "$mode_prompt" \
        -- "$payload"
end
