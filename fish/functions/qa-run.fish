# QA Subagent - Test Plan Execution
# Execute existing test plans

function qa-run --description "QA Run - Execute existing test plans against staging/production environments"
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

    if not test -f "$prompts_dir/qa_test_plan_execution_prompt.md"
        echo "❌ Error: Required prompt file not found: qa_test_plan_execution_prompt.md"
        return 1
    end

    if test (count $argv) -eq 0
        echo "📋 Usage: qa-run \"<execution parameters>\""
        echo "Example: qa-run \"Execute the test plan at qa/test-plans/release1_test_plan.md against staging\""
        return 1
    end

    set --local sys_prompt (cat $prompts_dir/qa_shared_header.md | string collect)
    set --local mode_prompt (cat $prompts_dir/qa_test_plan_execution_prompt.md | string collect)
    set --local payload $argv[1]

    echo "⚡ Executing test plan..."
    clazl \
        --system-prompt "$sys_prompt" \
        --append-system-prompt "$mode_prompt" \
        -- "$payload"
end
