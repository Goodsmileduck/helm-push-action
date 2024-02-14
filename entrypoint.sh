#!/usr/bin/env bash

set -e
set -x

if [ -z "$CHART_FOLDER" ]; then
  echo "CHART_FOLDER is not set. Quitting."
  exit 1
fi

if [ -z "$CHARTMUSEUM_URL" ]; then
  echo "CHARTMUSEUM_URL is not set. Quitting."
  exit 1
fi

if [ -z "$CHARTMUSEUM_USER" ]; then
  echo "CHARTMUSEUM_USER is not set. Quitting."
  exit 1
fi

if [ -z "$CHARTMUSEUM_PASSWORD" ]; then
  echo "CHARTMUSEUM_PASSWORD is not set. Quitting."
  exit 1
fi

if [ -z "$SOURCE_DIR" ]; then
  SOURCE_DIR="."
fi

if [ -z "$FORCE" ] || [ "$FORCE" == "False" ] || [ "$FORCE" == "FALSE" ]; then
  FORCE=""
elif [ "$FORCE" == "1" ] || [ "$FORCE" == "True" ] || [ "$FORCE" == "TRUE" ]; then
  FORCE="-f"
fi

if [ -z "$SKIP_SECURE" ] || [ "$SKIP_SECURE" == "False" ] || [ "$SKIP_SECURE" == "FALSE" ]; then
  SKIP_SECURE=""
elif [ "$SKIP_SECURE" == "1" ] || [ "$SKIP_SECURE" == "True" ] || [ "$SKIP_SECURE" == "TRUE" ]; then
  SKIP_SECURE="--insecure"
fi

if [ -z "$SSL_CERTIFICATE_PATH" ]; then
  SSL_CERTIFICATE_PATH=""
elif [ "$SSL_CERTIFICATE_PATH" != "" ]; then
  SSL_CERTIFICATE_PATH="--cert-file ../../${SSL_CERTIFICATE_PATH}"
fi

if [ -z "$SSL_CERTIFICATE_CA_PATH" ]; then
  SSL_CERTIFICATE_CA_PATH=""
elif [ "$SSL_CERTIFICATE_CA_PATH" != "" ]; then
  SSL_CERTIFICATE_CA_PATH="--ca-file ../../${SSL_CERTIFICATE_CA_PATH}"
fi

if [ -z "$SSL_CERTIFICATE_KEY_PATH" ]; then
  SSL_CERTIFICATE_KEY_PATH=""
elif [ "$SSL_CERTIFICATE_KEY_PATH" != "" ]; then
  SSL_CERTIFICATE_KEY_PATH="--key-file ../../${SSL_CERTIFICATE_KEY_PATH}"
fi

if [ -z "$DEBUG" ]; then
  DEBUG_FLAG=""
elif [ "$DEBUG" == "1" ] || [ "$DEBUG" == "True" ] || [ "$DEBUG" == "TRUE" ]; then
  DEBUG_FLAG="--debug"
fi



cd ${SOURCE_DIR}/${CHART_FOLDER}

helm version -c

helm inspect chart .

if [[ $CHARTMUSEUM_REPO_NAME ]]; then
  helm repo add ${CHARTMUSEUM_REPO_NAME} ${CHARTMUSEUM_URL} --username=${CHARTMUSEUM_USER} --password=${CHARTMUSEUM_PASSWORD}
fi

helm dependency update .

helm package .

helm cm-push ${CHART_FOLDER}-* ${CHARTMUSEUM_URL} -u ${CHARTMUSEUM_USER} -p ${CHARTMUSEUM_PASSWORD} ${FORCE} ${SKIP_SECURE} ${SSL_CERTIFICATE_PATH} ${SSL_CERTIFICATE_CA_PATH} ${SSL_CERTIFICATE_KEY_PATH} ${DEBUG_FLAG}
