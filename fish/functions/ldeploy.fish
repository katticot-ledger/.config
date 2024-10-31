function ldeploy -d "Deploy and manage ledger-vault instances" -a name -a useTelepresence -a salt
    # Set default name if not provided
    if test -z "$name"
        set name work-in-progress
    end

    # Set default salt if not provided
    if test -z "$salt"
        set salt saltqa
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

    # Deploy ledger-vault in the background
    ledger-vault deploy --name $name --owner @keita --expirationHours 24 --remoteURL https://remote.minivault.ledger-sbx.com &
    set pid $last_pid # Capture the PID

    # Wait for deployment to complete
    wait $pid

    # Handle any errors during deployment
    if test $status -ne 0
        echo "Deployment failed."
        return 1
    end

    # Bake the ledger-vault with the specified or default salt value
    ledger-vault bake --preset beatles --minivaultURL https://$name.minivault.ledger-sbx.com -s $salt

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
