#!/bin/bash

execute() {

    case $1 in
        init)
            printf "\n\nAbout to: $1 Terraform in $3 environment\n"
            command="terraform init -backend-config=../../envs/$3/$2/backend.tfbackend"
            command+=" -var-file=../../envs/$3/$2/variables.tfvars -var env=$3 -var tenant_id=$ARM_TENANT_ID -var subscription_id=$ARM_SUBSCRIPTION_ID"
        ;;
        plan)   
            printf "\n\nAbout to: $1 $2 in $3 environment\n"
            command="terraform plan -no-color -out=tf.plan"
            command+=" -var-file=../../envs/$3/$2/variables.tfvars -var env=$3 -var tenant_id=$ARM_TENANT_ID -var subscription_id=$ARM_SUBSCRIPTION_ID"
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

    source envs/$ENV/set-variables.sh
    cd layers/$SERVICE

    execute $ACTION $SERVICE $ENV

}

main "$@"