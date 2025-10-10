#
# NAME
#   gc - Git clone shortcut
#
# SYNOPSIS
#   gc [OPTIONS] <REPOSITORY> [DIRECTORY]
#
# DESCRIPTION
#   Simple alias wrapper for the git clone command. Provides a shorter
#   command name for cloning repositories.
#
# OPTIONS
#   All git clone options are passed through unchanged.
#
# ARGUMENTS
#   REPOSITORY
#       The repository URL to clone (required)
#
#   DIRECTORY
#       Destination directory name (optional, defaults to repository name)
#
# EXAMPLES
#   gc https://github.com/user/repo.git
#   gc https://github.com/user/repo.git my-project
#   gc --depth 1 https://github.com/user/repo.git
#
# SEE ALSO
#   git-clone(1) gp(1) git(1)
#
function gc --wraps='git clone' --description 'Git clone shortcut'
  git clone $argv
end
