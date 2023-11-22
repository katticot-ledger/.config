function ldeploy -a name
    # Execute the first command in the background
    ledger-vault deploy --name $name --owner @keita --expirationHours 24 --remoteURL https://remote.minivault.ledger-sbx.com &

    # Capture the process ID (PID) of the background process
    set pid $last_pid

    # Wait for the first command to complete
    wait $pid

    # Execute the second command after the first one finishes
    ledger-vault bake --preset beatles --minivaultURL https://$name.minivault.ledger-sbx.com -s saltqa

end
