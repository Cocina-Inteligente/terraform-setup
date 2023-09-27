#!/bin/bash

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

    echo curl ipinfo.io/ip

    source envs/$ENV/set-variables.sh
    cd layers/$SERVICE

    execute $ACTION $SERVICE $ENV

}

main "$@"