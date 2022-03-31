#!/bin/bash -x

if [ -n "$MOLECULE_IT_SCENARIO" ]; then
    export ANSIBLE_VAULT_PASSWORD_FILE=./.vault_pass.txt
    if [ ! -f "$ANSIBLE_VAULT_PASSWORD_FILE" ]; then
        echo "Generating a random secret to encrypt in ansible-vault"
        openssl rand -base64 21 > $ANSIBLE_VAULT_PASSWORD_FILE
    fi

    EXTRA_CONFIG=""
    MOLECULE_IT_PATH="molecule/$MOLECULE_IT_SCENARIO"
    if [ -n "$MOLECULE_IT_CONFIG" ]; then
        EXTRA_CONFIG="-e $MOLECULE_IT_PATH/$MOLECULE_IT_CONFIG"
    fi
    if [ "$1" == 'destroy' ]; then
        # shellcheck disable=SC2086
        molecule $EXTRA_CONFIG destroy -s "$MOLECULE_IT_SCENARIO"
    elif [ "$1" == 'verify' ]; then
        echo "Generating ansible-vault secrets..."
        ./scripts/generate-secrets.sh > vars/secrets.yml
        # shellcheck disable=SC2086
        molecule $EXTRA_CONFIG converge -s "$MOLECULE_IT_SCENARIO" || exit 1
        # shellcheck disable=SC2086
        molecule $EXTRA_CONFIG verify -s "$MOLECULE_IT_SCENARIO"
    else
        echo "$1: invalid command"
        exit 1
    fi
else
    echo "no molecule it scenario is set, doing nothing"
fi
