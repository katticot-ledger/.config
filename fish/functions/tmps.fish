function tmps --description "Show running processes in each tmux pane"
    tmux list-panes -a -F "#{session_name}::#{window_index}.#{pane_index}::#{pane_pid}" | while read -l line
        set -l parts (string split "::" "$line")
        set -l session (string trim "$parts[1]")
        set -l pane "$session:$parts[2]"
        set -l pid "$parts[3]"

        # Find immediate child process
        set -l child (ps -o pid=,ppid=,command= | awk -v pid="$pid" '$2 == pid { print substr($0, index($0,$3)); exit }')
        set -l cpid (ps -o pid=,ppid=,command= | awk -v pid="$pid" '$2 == pid { print $1; exit }')

        # Find grandchild process
        set -l grandchild ""
        if test -n "$cpid"
            set grandchild (ps -o pid=,ppid=,command= | awk -v pid="$cpid" '$2 == pid { print substr($0, index($0,$3)); exit }')
        end

        if test -n "$grandchild"
            printf "%-20s  %s └─ %s\n" "$pane" "$child" "$grandchild"
        else if test -n "$child"
            printf "%-20s  %s\n" "$pane" "$child"
        else
            set -l shell_cmd (ps -p "$pid" -o command= | string trim)
            printf "%-20s  (%s)\n" "$pane" "$shell_cmd"
        end
    end
end
