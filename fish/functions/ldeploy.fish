function ldeploy -a name
    if test -z "$name"
        set name work-in-progess
    end # Execute the first command in the background
    nvm use 16
    ledger-vault deploy --name $name --owner @keita --expirationHours 24 --remoteURL https://remote.minivault.ledger-sbx.com &

    # Capture the process ID (PID) of the background process
    set pid $last_pid

    # Wait for the first command to complete
    wait $pid

    # Execute the second command after the first one finishes
    ledger-vault bake --preset beatles --minivaultURL https://$name.minivault.ledger-sbx.com -s saltqa
    telepresence connect -n minivault-csvexport-sbx
end

function ldeploy -a name -a useTelepresence
    if test -z "$name"
        set name work-in-progress
    end

    # Execute the first command in the background
    nvm use 16
    ledger-vault deploy --name $name --owner @keita --expirationHours 24 --remoteURL https://remote.minivault.ledger-sbx.com &

    # Capture the process ID (PID) of the background process
    set pid $last_pid

    # Wait for the first command to complete
    wait $pid

    # Execute the second command after the first one finishes
    ledger-vault bake --preset beatles --minivaultURL https://$name.minivault.ledger-sbx.com -s saltqa

    # Check the boolean argument to decide whether to run telepresence
    if test "$useTelepresence" = true
        telepresence connect -n minivault-$name
        mkdir /tmp/minivault/
        telepresence intercept gate --port 5000 --env-file /tmp/minivault/gate
        export $(cat /tmp/minivault/gate )
    end
end
