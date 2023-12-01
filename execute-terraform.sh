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

    export ARM_CLIENT_ID= ${{ secrets.ARM_CLIENT_ID }}
    export ARM_CLIENT_SECRET= ${{ secrets.ARM_CLIENT_SECRET }}
    export ARM_TENANT_ID= ${{ secrets.ARM_TENANT_ID }}
    export ARM_SUBSCRIPTION_ID= ${{ secrets.ARM_SUBSCRIPTION_ID }}

    # source envs/$ENV/set-variables.sh
    cd layers/$SERVICE

    execute $ACTION $SERVICE $ENV

}

main "$@"