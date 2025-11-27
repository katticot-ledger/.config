# QA Subagent Setup Function
# Setup and validate QA subagent environment

function qa-setup --description "QA Setup - Validate QA environment, prompt files, and clazl command availability"
    set --local prompts_dir "prompts"

    echo "🧪 Setting up QA Subagent environment..."
    echo ""

    # Check if prompts directory exists
    if not test -d "$prompts_dir"
        echo "❌ Error: prompts directory not found at $prompts_dir"
        echo "Please ensure all prompt files are created in the current directory."
        return 1
    end

    # Check if required prompt files exist
    set --local required_prompts qa_shared_header.md qa_main_prompt.md qa_feature_prompt.md qa_test_plan_creation_prompt.md qa_test_plan_execution_prompt.md

    for prompt in $required_prompts
        if not test -f "$prompts_dir/$prompt"
            echo "❌ Error: Required prompt file not found: $prompt"
            return 1
        end
    end

    echo "✅ All required QA prompt files found"
    echo ""

    # Test that clazl command exists
    if command -v clazl >/dev/null 2>&1
        echo "✅ clazl command found"
    else
        echo "⚠️  Warning: 'clazl' command not found in PATH"
        echo "   Make sure clazl CLI is installed and accessible"
    end

    echo ""
    echo "🔧 Testing prompt file access..."
    for prompt in $required_prompts
        if test -r "$prompts_dir/$prompt"
            echo "✅ $prompt - readable"
        else
            echo "❌ $prompt - not readable"
        end
    end

    echo ""
    echo "🎯 QA Subagents are ready to use!"
    echo ""
    echo "Available commands:"
    echo "  qa-main     - Run comprehensive QA best practices checks"
    echo "  qa-feature  - Run feature-specific QA tests"
    echo "  qa-plan     - Generate comprehensive test plans"
    echo "  qa-run      - Execute existing test plans"
    echo "  qa-setup    - Validate the QA setup"
    echo ""
    echo "Usage examples:"
    echo "  qa-main \"TARGET_ENV=staging; BUILD_REF=HEAD; SCOPE=smoke\""
    echo "  qa-feature \"FEATURE_NAME='Checkout'; ENTRY_POINTS='/checkout'; ACCEPTANCE_CRITERIA='AC1..AC5'\""
    echo "  qa-plan \"Generate a comprehensive test plan from prd.md\""
    echo "  qa-run \"Execute qa/test-plans/release1_test_plan.md against staging\""
end