#!/bin/bash

for command in aws egrep jq tfenv tgenv ; do
    if ! command -v $command &>/dev/null; then
        echo "$command NOT FOUND in the PATH"
        exit 1
    fi
done

AWS_PROFILE=${AWS_PROFILE:-default}
ENVIRONMENTS='env_1|env_2|...|env_N' # pipe separated values
TERRA=$(pwd | egrep -oh ".*(${ENVIRONMENTS})")
BUCKET_NAME=$(egrep bucket ${TERRA}/terra*.{hcl,tfvars} | cut -d'=' -f2 | sed 's/ //g;s/"//g' | sort -u)
STATE_FILE=terraform.tfstate

AWS_PROFILE=${AWS_PROFILE} aws s3 cp s3://${BUCKET_NAME}/${PWD##*/}/${STATE_FILE} .

if [[ -f ${STATE_FILE} ]]; then
    TF_VERSION_TO_SET=$(jq -r '.terraform_version' ${STATE_FILE})
    rm -f ${STATE_FILE}
else
    exit 1
fi

tfenv install ${TF_VERSION_TO_SET} ; tfenv use ${TF_VERSION_TO_SET}

# Accorging to https://terragrunt.gruntwork.io/docs/getting-started/supported-terraform-versions/
#
echo ${TF_VERSION_TO_SET} | egrep -oh '0.11.' &>/dev/null && TG_VERSION_TO_SET=0.18.7
echo ${TF_VERSION_TO_SET} | egrep -oh '0.12.' &>/dev/null && TG_VERSION_TO_SET=0.24.4
echo ${TF_VERSION_TO_SET} | egrep -oh '0.(13.|14.)' &>/dev/null && TG_VERSION_TO_SET=latest

tgenv install ${TG_VERSION_TO_SET} ; tgenv use ${TG_VERSION_TO_SET}

terraform -version | head -1 && terragrunt -version
