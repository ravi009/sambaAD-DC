#!/bin/bash

INPUT="students.csv"

tail -n +2 "$INPUT" | while IFS=',' read -r username password givenName surname displayName ou
do
    echo "Creating user: $username ($displayName)"
    if samba-tool user show "$username" > /dev/null 2>&1; then
        echo "User $username already exists, skipping..."
        continue
    fi
    samba-tool user create "$username" "$password" \
        --given-name="$givenName" \
        --surname="$surname" \
        --display-name="$displayName" \
        --userou="$ou"

done

echo "All users created!"
