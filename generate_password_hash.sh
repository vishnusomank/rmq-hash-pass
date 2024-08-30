#!/bin/bash

function encode_password() {
    PASSWORD=$1

    # Generate a random 32-bit salt (4 bytes)
    SALT=$(openssl rand -hex 4 | tr -d '\n' | awk '{print toupper($0)}')


    # Convert the password to its UTF-8 hexadecimal representation
    PASSWORD_HEX=$(echo -n "$PASSWORD" | xxd -p | tr -d '\n' | awk '{print toupper($0)}')

    # Prepend the salt to the password's hexadecimal representation
    INTERMEDIATE_RESULT="${SALT}${PASSWORD_HEX}"

    # Compute the SHA-256 hash of the intermediate result
    HASH=$(echo -n "$INTERMEDIATE_RESULT" | xxd -r -p | sha256sum | awk '{print $1}' | awk '{print toupper($0)}')

    # Prepend the salt to the hash result
    FINAL_RESULT="${SALT}${HASH}"

    # Convert the final result to base64 encoding
    PASSWORD_HASH=$(echo -n "$FINAL_RESULT" | xxd -r -p | base64)

    # Output the final base64-encoded password hash
    echo "$PASSWORD_HASH"

}

# input should be a base64 encoded password string

encode_password $1
