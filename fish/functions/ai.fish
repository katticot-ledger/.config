#
# NAME
#   ai - Interactive Ollama model selector with chat interface
#
# SYNOPSIS
#   ai [OPTIONS] [PROMPT]
#   ai set-model [MODEL_NAME]
#   ai -s|--select [PROMPT]
#
# DESCRIPTION
#   Provides an interactive interface for Ollama models with fuzzy selection via fzf.
#   Supports model management, default model setting, and direct prompting with
#   either interactive selection or default model usage.
#
# OPTIONS
#   -s, --select, --select-model
#       Force interactive model selection via fzf, even if default model is set
#
# COMMANDS
#   set-model [MODEL_NAME]
#       Show current default model or set a new default model
#       Without arguments: shows current model and available models
#       With MODEL_NAME: sets new default after verification
#
# ARGUMENTS
#   PROMPT
#       Text prompt to send directly to the model (uses default model if set)
#
# EXAMPLES
#   ai                                    # Interactive mode with default model or selection
#   ai "Explain quantum computing"        # Direct prompt with default model
#   ai -s "Help me write Python code"     # Force model selection then prompt
#   ai set-model                          # Show current model and available options
#   ai set-model llama3                  # Set llama3 as default model
#
# ENVIRONMENT VARIABLES
#   AI_MODEL
#       Default model to use when no model is explicitly selected
#
# DEPENDENCIES
#   ollama (required)
#   fzf (recommended for interactive selection)
#
# SEE ALSO
#   ollama(1)
#
function ai --description "Interactive Ollama model selector with chat interface"
    # Parse arguments
    set -l force_select 0
    set -l remaining_args
    
    for arg in $argv
        switch $arg
            case '-s' '--select' '--select-model'
                set force_select 1
            case '*'
                set remaining_args $remaining_args $arg
        end
    end
    
    # Check if ollama is available
    if not type -q ollama
        echo "Ollama not found. Please install it first."
        echo "Visit: https://ollama.ai/"
        return 1
    end

    # Handle model selection commands
    if test (count $remaining_args) -ge 1; and test "$remaining_args[1]" = "set-model"
        if test (count $remaining_args) -eq 1
            # Show current model and available models
            if set -q AI_MODEL
                echo "Current default model: $AI_MODEL"
            else
                echo "No default model set"
            end
            echo ""
            echo "Available models:"
            ollama list | tail -n +2 | awk '{print "  " $1}' | grep -v '^$'
            echo ""
            echo "Usage: ai set-model <model_name>"
            return 0
        else
            # Set the model
            set -l new_model $remaining_args[2]
            # Verify the model exists
            if ollama list | grep -q "^$new_model"
                set -Ux AI_MODEL $new_model
                echo "Default model set to: $new_model"
                return 0
            else
                echo "Model '$new_model' not found. Available models:"
                ollama list | tail -n +2 | awk '{print "  " $1}' | grep -v '^$'
                return 1
            end
        end
    end

    # Get default model from environment variable or use fallback
    set -l default_model
    if set -q AI_MODEL
        set default_model $AI_MODEL
    else
        # Try to find a reasonable default from available models
        set -l available_models (ollama list | tail -n +2 | awk '{print $1}' | grep -v '^$')
        if test (count $available_models) -gt 0
            set default_model $available_models[1]
        end
    end

    # Force model selection with fzf if requested
    if test $force_select -eq 1
        # Show fzf model selector
        set -l models (ollama list | tail -n +2 | awk '{print $1}' | grep -v '^$')
        
        if test (count $models) -eq 0
            echo "No models found. Please pull a model first:"
            echo "  ollama pull llama2"
            echo "  ollama pull codellama"
            echo "  ollama pull mistral"
            return 1
        end

        if type -q fzf
            set -l selected_model (printf "%s\n" $models | fzf \
                --prompt="Select Ollama model > " \
                --height=50% \
                --layout=reverse \
                --border \
                --header="ESC: cancel | ENTER: select | TAB: set as default" \
                --preview="ollama show {} | head -20" \
                --preview-window=right:60%:wrap \
                --bind="tab:execute(fish -c 'set -Ux AI_MODEL {}; echo Default model set to: {}')")
            
            if test -z "$selected_model"
                echo "No model selected."
                return 1
            end
            
            if test (count $remaining_args) -gt 0
                set -l prompt (string join " " $remaining_args)
                echo "Running prompt with $selected_model: $prompt"
                echo "---"
                ollama run $selected_model "$prompt"
            else
                echo "Starting chat with $selected_model..."
                ollama run $selected_model
            end
        else
            echo "fzf not found. Install with: brew install fzf"
            return 1
        end
        return 0
    end

    # Check if any arguments were passed
    if test (count $remaining_args) -eq 0
        # No arguments - use default model if set, otherwise show interactive selector
        if test -n "$default_model"
            echo "Starting chat with default model: $default_model"
            echo "(Use 'ai set-model <name>' to change default)"
            ollama run $default_model
        else
            # Show interactive model selector
            set -l models (ollama list | tail -n +2 | awk '{print $1}' | grep -v '^$')
            
            if test (count $models) -eq 0
                echo "No models found. Please pull a model first:"
                echo "  ollama pull llama2"
                echo "  ollama pull codellama"
                echo "  ollama pull mistral"
                return 1
            end

            # Use fzf to select model if available, otherwise show list
            if type -q fzf
                set -l selected_model (printf "%s\n" $models | fzf \
                    --prompt="Select Ollama model > " \
                    --height=50% \
                    --layout=reverse \
                    --border \
                    --header="ESC: cancel | ENTER: select | TAB: set as default" \
                    --preview="ollama show {} | head -20" \
                    --preview-window=right:60%:wrap \
                    --bind="tab:execute(fish -c 'set -Ux AI_MODEL {}; echo Default model set to: {}')")
                
                if test -z "$selected_model"
                    echo "No model selected."
                    return 1
                end
                
                echo "Starting chat with $selected_model..."
                ollama run $selected_model
            else
                echo "Available models:"
                for model in $models
                    echo "  $model"
                end
                echo ""
                echo "Usage: ai <model_name> [prompt]"
                echo "Or install fzf for interactive selection: brew install fzf"
                echo "Or set a default model: ai set-model <model_name>"
            end
        end
    else
        # Arguments provided - treat as prompt with default model
        set -l prompt (string join " " $remaining_args)
        
        if test -n "$default_model"
            echo "Starting chat with $prompt..."
            echo "Using model: $default_model"
            echo "---"
            ollama run $default_model "$prompt"
        else
            echo "No default model set. Available models:"
            set -l available_models (ollama list | tail -n +2 | awk '{print $1}' | grep -v '^$')
            for model in $available_models
                echo "  $model"
            end
            echo ""
            echo "Set a default model: ai set-model <model_name>"
            return 1
        end
    end
end