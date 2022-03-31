#!/bin/bash -e
if [ -z "${ANSIBLE_VAULT_PASSWORD_FILE}" ]; then
    echo "ANSIBLE_VAULT_PASSWORD_FILE must be set to a file containing your shared secret"
fi

secret_keys=(repo_db_password sync_db_password reposearch_shared_secret)
for secret_key in "${secret_keys[@]}"; do
    ansible-vault encrypt_string "$(openssl rand -base64 21)" --name ${secret_key} | grep -v 'Encryption successful'
done