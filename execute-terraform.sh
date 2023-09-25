#!/bin/bash

setup() {
    source envs/$ENV/set-variables.sh

    if $TERRAFORM_INSTALL ; then
        apt-get update && apt-get install -y gnupg software-properties-common

        wget -O- https://apt.releases.hashicorp.com/gpg | \
        gpg --dearmor | \
        tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

        gpg --no-default-keyring \
        --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
        --fingerprint

        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
        https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        tee /etc/apt/sources.list.d/hashicorp.list

        apt update

        apt-get install terraform
    else
        printf "\nTerraform already installed."
    fi
}

init() {
    terraform int -var="env=$1"
}

plan() {
    terraform plan -var="env=$1" -no-color -out="tf.plan"
}

apply() {
    plan $1
    terraform apply tf.plan -auto-approve -var="env=$1" 
}

main() {

    while [[ $# -gt 0 ]]; do
        case $1 in
            -a|--action)
                ACTION="$2"
                shift
                shift
                ;;
            -e|--env)
                ENV="$2"
                shift
                shift
                ;;
            -*|--*)
                echo "Unkown option $1"
                exit 1
                ;;
        esac

        setup $ENV
        ACTION $ENV
    done

}

# ./execute-terraform.sh -a apply -e local
main "$@"