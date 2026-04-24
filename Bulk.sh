#!/bin/bash

INPUT="students.csv"

tail -n +2 "$INPUT" | while IFS=',' read -r username password givenName surname displayName ou
do
    echo "Creating user: $username ($displayName)"

    samba-tool user create "$username" "$password" \
        --given-name="$givenName" \
        --surname="$surname" \
        --display-name="$displayName" \
        --userou="$ou"

done

echo "All users created!"
