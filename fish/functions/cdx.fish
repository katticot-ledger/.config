# Codex CLI Fish aliases
#
# Provides:
#   - cdx-quick  -> minimal/quick model
#   - cdx        -> medium coder model
#   - cdx-full   -> full/large model
#
# Customize the binary or models by setting these env vars
# (ideally in your config.fish before sourcing this file):
#   set -gx CODEX_CLI codex
#   set -gx CODEX_MODEL_QUICK  "gpt-5 minimal"
#   set -gx CODEX_MODEL_MEDIUM "gpt-5-codex medium"
#   set -gx CODEX_MODEL_FULL   "gpt-5-codex high"

# Defaults (only set if not already set by the user)
if not set -q CODEX_CLI
    set -gx CODEX_CLI codex
end

if not set -q CODEX_MODEL_QUICK
    set -gx CODEX_MODEL_QUICK "gpt-5 minimal"
end

if not set -q CODEX_MODEL_MEDIUM
    set -gx CODEX_MODEL_MEDIUM "gpt-5-codex medium"
end

if not set -q CODEX_MODEL_FULL
    set -gx CODEX_MODEL_FULL "gpt-5-codex high"
end

function __cdx_check --description 'Ensure Codex CLI is available'
    if not type -q $CODEX_CLI
        echo "Codex CLI not found: $CODEX_CLI" 1>&2
        echo "Set CODEX_CLI to your binary name/path before using cdx aliases." 1>&2
        return 127
    end
end

function cdx-quick --description 'Launch Codex with the quick/minimal model'
    __cdx_check; or return $status
    command $CODEX_CLI --model "$CODEX_MODEL_QUICK" $argv
end

function cdx --description 'Launch Codex with the medium coder model'
    __cdx_check; or return $status
    command $CODEX_CLI --model "$CODEX_MODEL_MEDIUM" $argv
end

function cdx-full --description 'Launch Codex with the full/large model'
    __cdx_check; or return $status
    command $CODEX_CLI --model "$CODEX_MODEL_FULL" $argv
end

function cdx-help --description 'Show current Codex alias configuration'
    echo "Using binary:    $CODEX_CLI"
    echo "Quick model:     $CODEX_MODEL_QUICK"
    echo "Medium model:    $CODEX_MODEL_MEDIUM"
    echo "Full model:      $CODEX_MODEL_FULL"
    echo
    echo "Usage:"
    echo "  cdx-quick [args...]         # minimal/fast model (gpt-5 minimal)"
    echo "  cdx [args...]               # medium coder (gpt-5-codex medium)"
    echo "  cdx-full [args...]          # full/large coder (gpt-5-codex high)"
    echo "  cdx5-minimal [args...]      # gpt-5 minimal"
    echo "  cdx5-low [args...]          # gpt-5 low"
    echo "  cdx5-medium [args...]       # gpt-5 medium"
    echo "  cdx5-high [args...]         # gpt-5 high"
    echo "  cdx5-codex-low [args...]    # gpt-5-codex low"
    echo "  cdx5-codex-medium [args...] # gpt-5-codex medium"
    echo "  cdx5-codex-high [args...]   # gpt-5-codex high"
end

# Dedicated shortcuts for all provided models
function cdx5-minimal --description 'Codex with model: gpt-5 minimal'
    __cdx_check; or return $status
    command $CODEX_CLI --model "gpt-5 minimal" $argv
end

function cdx5-low --description 'Codex with model: gpt-5 low'
    __cdx_check; or return $status
    command $CODEX_CLI --model "gpt-5 low" $argv
end

function cdx5-medium --description 'Codex with model: gpt-5 medium'
    __cdx_check; or return $status
    command $CODEX_CLI --model "gpt-5 medium" $argv
end

function cdx5-high --description 'Codex with model: gpt-5 high'
    __cdx_check; or return $status
    command $CODEX_CLI --model "gpt-5 high" $argv
end

function cdx5-codex-low --description 'Codex with model: gpt-5-codex low'
    __cdx_check; or return $status
    command $CODEX_CLI --model "gpt-5-codex low" $argv
end

function cdx5-codex-medium --description 'Codex with model: gpt-5-codex medium'
    __cdx_check; or return $status
    command $CODEX_CLI --model "gpt-5-codex medium" $argv
end

function cdx5-codex-high --description 'Codex with model: gpt-5-codex high'
    __cdx_check; or return $status
    command $CODEX_CLI --model "gpt-5-codex high" $argv
end
