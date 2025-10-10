#
# NAME
#   pm_status - Display crypto portfolio manager status
#
# SYNOPSIS
#   pm_status
#
# DESCRIPTION
#   Quick shortcut to display the current status of the cryptocurrency portfolio
#   manager. Uses a hardcoded configuration file path and runs the portfolio status
#   command with that configuration.
#
# CONFIGURATION
#   Uses configuration file: /Users/keita/Developer/Experiments/crypto-portfolio-manager/config/config.toml
#
# DEPENDENCIES
#   portfolio-manager (CLI tool)
#
# EXAMPLES
#   pm_status               # Show current portfolio status
#
# OUTPUT
#   Displays current portfolio holdings, values, and performance metrics
#   as formatted by the portfolio-manager tool.
#
# SEE ALSO
#   portfolio-manager(1)
#
function pm_status --description "Display crypto portfolio manager status"
    set -l config /Users/keita/Developer/Experiments/crypto-portfolio-manager/config/config.toml
    portfolio-manager portfolio status --config $config
end
