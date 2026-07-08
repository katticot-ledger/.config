function __herdr_agy_heartbeat --description "Report agy conversation to herdr on each prompt"
    test "$HERDR_ENV" = "1" || return
    set -q __herdr_agy_last_report; and test (math (date +%s) - $__herdr_agy_last_report) -lt 5; and return
    set -g __herdr_agy_last_report (date +%s)
    set -l hook "$HOME/.gemini/antigravity-cli/hooks/herdr-agent-state.sh"
    test -x "$hook"; and "$hook" heartbeat &
end
