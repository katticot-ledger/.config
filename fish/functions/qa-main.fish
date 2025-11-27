# QA Subagent - Main Best Practices
# Run comprehensive QA best practices checks

function qa-main --description "QA Main - Run comprehensive QA best practices checks (staging, smoke tests, release sanity)"
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

    if not test -f "$prompts_dir/qa_main_prompt.md"
        echo "❌ Error: Required prompt file not found: qa_main_prompt.md"
        return 1
    end

    if test (count $argv) -eq 0
        echo "📋 Usage: qa-main \"<QA parameters>\""
        echo "Example: qa-main \"TARGET_ENV=staging; BUILD_REF=HEAD; SCOPE=release-sanity\""
        return 1
    end

    set --local sys_prompt (cat $prompts_dir/qa_shared_header.md | string collect)
    set --local mode_prompt (cat $prompts_dir/qa_main_prompt.md | string collect)
    set --local payload $argv[1]

    echo "🧪 Running QA main checks..."
    clazl \
        --system-prompt "$sys_prompt" \
        --append-system-prompt "$mode_prompt" \
        -- "$payload"
end
