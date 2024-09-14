#!/bin/bash

# This script is used to create the terraform environment
# Maintain the terraform workspace in S3

function check_workspace_name {
    local workspace_name=$1
    local pattern="^[a-zA-Z0-9]+_[a-zA-Z0-9]+_[a-z]+-[a-z]+-[0-9]"
    if ! [[ $workspace_name =~ $pattern ]]; then
        echo "Error: wrong workspace name"
        exit 1
    fi
}

export AWS_PROFILE="Ctrl-infrastructure"

if [ $# -lt 1 ]; then
    echo "Usage: $0 tenant_environment_region [-a|-d|-l|-p]"
    echo "E.g. $0 ctrl1_stage_us-east-1"
    exit 1
fi

if [ $1 == "-l" ]; then
    terraform workspace list
    exit 0
fi

workspace_name=$1
check_workspace_name $workspace_name
terraform workspace select $workspace_name
if [ $? -ne 0 ]; then
    exit 1
fi

if [ $# -ne 0 ]; then
    shift
    opt=$1
    case $opt in
        -l)
            terraform workspace list
            exit 0
            ;;   
        -d) 
            terraform destroy
            exit 0
            ;;
        -p) 
            terraform init
            terraform plan
            exit 0
            ;;
        -a) 
            terraform init
            terraform plan
            terraform apply
            exit 0
            ;;
        *) 
            echo "Error: no such option."
            exit 1
            ;;
    esac
fi
