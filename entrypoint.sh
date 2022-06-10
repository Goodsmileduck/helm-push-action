#!/bin/bash
set -e
set -x

CHART_FOLDER=$1
SOURCE_DIR=$2
CHARTMUSEUM_REPO_NAME=$3
CHARTMUSEUM_URL=$4
CHARTMUSEUM_USER=$5
CHARTMUSEUM_PASSWORD=$6
CHART_VERSION=$7
CHART_APP_VERSION=$8
FORCE=$9

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

if [ -z "$CHARTMUSEUM_REPO_NAME" ]; then
  echo "CHARTMUSEUM_REPO_NAME is not set. Quitting."
  exit 1
fi

PACKAGE_FLAGS=""

if [ -n "$CHART_APP_VERSION" ]; then
  PACKAGE_FLAGS=" --app-version $CHART_APP_VERSION "
fi

if [ -n "$CHART_VERSION" ]; then
  PACKAGE_FLAGS="$PACKAGE_FLAGS --version $CHART_VERSION "
fi

if [ -n "$FORCE" ]; then
  FORCE="-f"
fi

cd ${SOURCE_DIR}/${CHART_FOLDER}

helm version -c

helm repo add "$CHARTMUSEUM_REPO_NAME" "$CHARTMUSEUM_URL" --username "$CHARTMUSEUM_USER" --password "$CHARTMUSEUM_PASSWORD"

helm inspect chart .

helm dependency update .

helm package . $PACKAGE_FLAGS

if helm cm-push ${CHART_FOLDER}-* ${CHARTMUSEUM_URL} -u ${CHARTMUSEUM_USER} -p ${CHARTMUSEUM_PASSWORD} ${FORCE}; then
  echo "Push successful!"
  exit 0
else
  echo "Chartmuseum push failure. Deleting and retrying."
  curl --user "pilot:${CHARTMUSEUM_PASSWORD}" -X "DELETE" "https://chartmuseum.devops.bestegg.com/api/charts/${CHART_FOLDER}/${CHART_APP_VERSION}"
  helm cm-push ${CHART_FOLDER}-* ${CHARTMUSEUM_URL} -u ${CHARTMUSEUM_USER} -p ${CHARTMUSEUM_PASSWORD} ${FORCE}
fi