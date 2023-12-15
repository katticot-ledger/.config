function opai --wraps='OPENAI_API_KEY' --description 'set OPENAI_API_KEY with 1password'
    set -gx OPENAI_API_KEY (op read op://private/OpenAI/credential --no-newline)
end
