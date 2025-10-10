#
# NAME
#   connect_aws - AWS environment connection and kubectl setup
#
# SYNOPSIS
#   connect_aws [ENVIRONMENT]
#
# DESCRIPTION
#   Automates AWS environment setup by renewing credentials, configuring kubectl,
#   and switching to the appropriate Kubernetes context. Designed for Ledger's
#   AWS infrastructure workflow.
#
# ARGUMENTS
#   ENVIRONMENT
#       AWS environment name (defaults to 'sbx' if not specified)
#       Examples: sbx, staging, prod
#
# WORKFLOW
#   1. Executes Python script to renew AWS credentials
#   2. Sources environment variables from generated exports
#   3. Switches kubectl context to match environment
#   4. Lists available namespaces to verify connection
#
# DEPENDENCIES
#   python3
#   kubectl
#   kubectx
#
# CONFIGURATION FILES
#   /Users/keita.atticot/Code/Ledger/aws/main.py
#       Python script for AWS credential renewal
#
#   /Users/keita.atticot/Code/Ledger/aws/aws_exports.sh
#       Generated shell exports for AWS environment variables
#
# EXAMPLES
#   connect_aws               # Connect to sbx environment (default)
#   connect_aws staging       # Connect to staging environment
#   connect_aws prod          # Connect to production environment
#
# OUTPUT
#   - AWS credentials configured
#   - Kubernetes context switched
#   - List of available namespaces displayed
#
# SECURITY NOTES
#   This function handles AWS credentials. Ensure the Python script and
#   export files are properly secured and not committed to version control.
#
# SEE ALSO
#   aws(1) kubectl(1) kubectx(1)
#
function connect_aws --description "AWS environment connection and kubectl setup" -a awsenv
    # Check if name is empty, set default if it is
    if test -z "$awsenv"
        set awsenv sbx
    end
    python3 /Users/keita.atticot/Code/Ledger/aws/main.py $awsenv
    source /Users/keita.atticot/Code/Ledger/aws/aws_exports.sh
    kubectx $awsenv
    kubectl get ns
end
