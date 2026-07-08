function fish_prompt --description 'Simple prompt (no VCS check to avoid iCloud Drive hangs)'
    __herdr_agy_heartbeat
    set -l last_pipestatus $pipestatus
    set -l last_status $status

    # Color
    set -l normal (set_color normal)
    set -l color_cwd (set_color $fish_color_cwd)
    set -l suffix '>'

    # Prompt
    echo -n -s (prompt_login)' ' (set_color $fish_color_cwd) (prompt_pwd) $normal " $suffix "
end
