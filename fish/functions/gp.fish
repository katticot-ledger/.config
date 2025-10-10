#
# NAME
#   gp - Git pull shortcut
#
# SYNOPSIS
#   gp [OPTIONS] [REPOSITORY] [REFSPEC]
#
# DESCRIPTION
#   Simple alias wrapper for the git pull command. Provides a shorter
#   command name for pulling updates from remote repositories.
#
# OPTIONS
#   All git pull options are passed through unchanged.
#
# ARGUMENTS
#   REPOSITORY
#       Remote repository name (optional, defaults to current branch's upstream)
#
#   REFSPEC
#       Remote branch name (optional, defaults to current branch)
#
# EXAMPLES
#   gp                       # Pull from current branch's upstream
#   gp origin main           # Pull from origin main branch
#   gp --rebase origin main  # Pull with rebase strategy
#   gp --ff-only             # Pull only if fast-forward possible
#
# SEE ALSO
#   git-pull(1) gc(1) git(1)
#
function gp --wraps='git pull' --description 'Git pull shortcut'
  git pull
end
