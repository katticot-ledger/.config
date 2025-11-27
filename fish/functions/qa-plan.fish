# QA Subagent - Test Plan Creation
# Generate comprehensive test plans

function qa-plan --description "QA Plan - Generate comprehensive test plans from PRDs, specs, or requirements"
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

    if not test -f "$prompts_dir/qa_test_plan_creation_prompt.md"
        echo "❌ Error: Required prompt file not found: qa_test_plan_creation_prompt.md"
        return 1
    end

    if test (count $argv) -eq 0
        echo "📋 Usage: qa-plan \"<test plan parameters>\""
        echo "Example: qa-plan \"Generate a comprehensive test plan based on prd.md\""
        return 1
    end

    set --local sys_prompt (cat $prompts_dir/qa_shared_header.md | string collect)
    set --local mode_prompt (cat $prompts_dir/qa_test_plan_creation_prompt.md | string collect)
    set --local payload $argv[1]

    echo "📝 Creating test plan..."
    clazl \
        --system-prompt "$sys_prompt" \
        --append-system-prompt "$mode_prompt" \
        -- "$payload"
end
