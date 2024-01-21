function ldeploy -d "Deploy and manage ledger-vault instances" -a name -a useTelepresence
    # Check if name is empty, set default if it is
    if test -z "$name"
        set name work-in-progress
    end

    # Export MINIVAULT_INSTANCE environment variable
    set -x MINIVAULT_INSTANCE $name

    # Check for nvm presence
    if not type -q nvm
        echo "nvm not found. Please install it."
        return 1
    end

    # Use Node.js version 16
    nvm use 16

    # Deploy ledger-vault in background
    ledger-vault deploy --name $name --owner @keita --expirationHours 24 --remoteURL https://remote.minivault.ledger-sbx.com &
    set pid $last_pid # Capture the PID

    # Wait for deployment to complete
    wait $pid

    # Handle any error in deployment
    if test $status -ne 0
        echo "Deployment failed."
        return 1
    end

    # Bake the ledger-vault
    ledger-vault bake --preset beatles --minivaultURL https://$name.minivault.ledger-sbx.com -s saltqa

    # Handle telepresence if requested
    if test "$useTelepresence" = true
        # Check for telepresence
        if not type -q telepresence
            echo "Telepresence not found. Please install it."
            return 1
        end

        # Connect and set up telepresence
        telepresence connect -n minivault-$name
        mkdir -p /tmp/minivault/
        telepresence intercept gate --port 5000 --env-file /tmp/minivault/gate
        source /tmp/minivault/gate # Import the environment variables
    end
end
