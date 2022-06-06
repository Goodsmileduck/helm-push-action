#!/usr/bin/env bash

set -e
set -x

if [ -z "$CHART_FOLDER" ]; then
  echo "CHART_FOLDER is not set. Quitting."
  exit 1
fi

if [ -z "$CHARTMUSEUM_URL_CI" ]; then
  echo "CHARTMUSEUM_URL_CI is not set. Quitting."
  exit 1
fi

if [ -z "$CHARTMUSEUM_URL_STABLE" ]; then
  echo "CHARTMUSEUM_URL_STABLE is not set. Quitting."
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

if [ -z "$FORCE" ]; then
  FORCE=""
elif [ "$FORCE" == "1" ] || [ "$FORCE" == "True" ] || [ "$FORCE" == "TRUE" ]; then
  FORCE="-f"
fi

cd ${SOURCE_DIR}/${CHART_FOLDER}

helm version -c

helm inspect chart .

CHARTMUSEUM_URL="${CHARTMUSEUM_URL_CI}"

CHARTMUSEUM_URL="${CHARTMUSEUM_URL_CI}"
[[ $IS_STABLE == "true" ]] && CHARTMUSEUM_URL="${CHARTMUSEUM_URL_STABLE}"
[[ $CHARTMUSEUM_REPO_NAME ]] && helm repo add ${CHARTMUSEUM_REPO_NAME} ${CHARTMUSEUM_URL} --username=${CHARTMUSEUM_USER} --password=${CHARTMUSEUM_PASSWORD}

helm dependency update .

helm package .

helm cm-push ${CHART_FOLDER}-* ${CHARTMUSEUM_URL} -u ${CHARTMUSEUM_USER} -p ${CHARTMUSEUM_PASSWORD} ${FORCE}
