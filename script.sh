#!/usr/bin/env bash

# setup the AWS credentials
# TODO check if empty env will use IAM instance profiles
export AWS_ACCESS_KEY_ID=${PLUGIN_AWS_ACCESS_KEY}
export AWS_SECRET_ACCESS_KEY=${PLUGIN_AWS_SECRET_KEY}
export AWS_SESSION_TOKEN=${PLUGIN_AWS_SESSION_TOKEN}
export AWS_DEFAULT_REGION=${PLUGIN_AWS_REGION}

# check we have our required env set
if [[ -z "${PLUGIN_S3_BUCKET}" ]]; then
	echo "ERROR: S3 bucket is not set"
	exit 1
fi
if [[ -z "${PLUGIN_CHART_NAME}" ]]; then
	echo "ERROR: Chart name is not set"
	exit 1
fi

# connect to the repo
helm repo add aws s3://${PLUGIN_S3_BUCKET}/${PLUGIN_S3_PATH}

# package
cp -r /drone/src /drone/${PLUGIN_CHART_NAME}
cd /drone

helm package ${PLUGIN_CHART_NAME}

# check that the tarball was created
if [[ ls ${PLUGIN_CHART_NAME}-*.tgz 1> /dev/null ]]; then
	echo "INFO: Found tarball"
else
	echo "ERROR: Couldn't find tarball"
	exit 1
fi
# grab the tarball
if [[ "${PLUGIN_FORCE}" = "true" ]]; then
	echo "INFO: Force pushing"
	helm s3 push ${PLUGIN_CHART_NAME}-*.tgz aws --force
else
	helm s3 push ${PLUGIN_CHART_NAME}-*.tgz aws
fi