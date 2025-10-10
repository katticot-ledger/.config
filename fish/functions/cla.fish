#
# NAME
#   cla - Run Claude AI assistant with default settings
#
# SYNOPSIS
#   cla [OPTIONS] [ARGS...]
#
# DESCRIPTION
#   Simple wrapper function that forwards all arguments to the claude command.
#   This is the basic Claude AI assistant launcher without any special flags
#   or configurations.
#
# EXAMPLES
#   cla "Help me write a Python function"
#   cla --help
#
# SEE ALSO
#   clad(1) clal(1) claf(1) cladr(1)
#
function cla --description "Run Claude AI assistant with default settings"
    claude $argv
end
