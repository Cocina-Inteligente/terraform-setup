#!/bin/bash

setup() {

    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

    gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint

    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

    sudo apt update

    sudo apt-get install terraform

    terraform -help

}

execute() {

    case $1 in
        init)
            printf "\n\nAbout to: $1 Terraform in $3 environment\n"
            command="terraform init -backend-config=../../envs/$3/$2/backend.tfbackend"
            command+=" -var-file=../../envs/$3/$2/variables.tfvars -var env=$3"
        ;;
        plan)
            printf "\n\nAbout to: $1 $2 in $3 environment\n"
            command="terraform plan -no-color -out=tf.plan"
            command+=" -var-file=../../envs/$3/$2/variables.tfvars -var env=$3"
        ;;
        apply)
            printf "\n\nAbout to: $1 $2 in $3 environment\n"
            command="terraform apply -auto-approve tf.plan"
    esac

    echo $command
    $command
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
            -s|--service)
                SERVICE="$2"
                shift
                shift
                ;;
            -*|--*)
                echo "Unkown option $1"
                exit 1
                ;;
        esac
    done

    export ARM_CLIENT_ID=e480723c-480c-4e1d-afec-7d45882e92c9
    export ARM_CLIENT_SECRET=C_M8Q~CJ.Qk5AOwotYxY2P0KIEo2xyfLbT86rcRz
    export ARM_TENANT_ID=5f45355f-95f9-4862-9d17-94f05e20529b
    export ARM_SUBSCRIPTION_ID=586d6509-c783-41ef-a543-39a09899fe70

    source envs/$ENV/set-variables.sh
    cd layers/$SERVICE

    if [ "$TERRAFORM_INSTALL" = true & "$ACTION" = "setup" ] ; then
       setup
       exit -1
    fi

    execute $ACTION $SERVICE $ENV

}

main "$@"