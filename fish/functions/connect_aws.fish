function connect_aws -d "Renew AWS keys" -a awsenv
    # Check if name is empty, set default if it is
    if test -z "$awsenv"
        set awsenv sbx
    end
    python3 /Users/keita.atticot/Code/Ledger/aws/main.py $awsenv
    source /Users/keita.atticot/Code/Ledger/aws/aws_exports.sh
    kubectx $awsenv
    kubectl get ns
end
