#!/usr/bin/env bash

set -e
set -x

if [ -z "$CHART_FOLDER" ]; then
  echo "CHART_FOLDER is not set. Quitting."
  exit 1
fi

if [ -z "$CHARTMUSEUM_URL_UNSTABLE" ]; then
  echo "CHARTMUSEUM_URL_UNSTABLE is not set. Quitting."
  exit 1
fi

if [ -z "$CHARTMUSEUM_URL" ]; then
  echo "CHARTMUSEUM_URL is not set. Quitting."
  exit 1
fi

if [ -z "$GIT_STABLE_BRANCH_NAME" ]; then
  echo "GIT_STABLE_BRANCH_NAME is not set. Quitting."
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

if [ -z "$FORCE" ]; then
  FORCE=""
elif [ "$FORCE" == "1" ] || [ "$FORCE" == "True" ] || [ "$FORCE" == "TRUE" ]; then
  FORCE="-f"
fi

cd ${SOURCE_DIR}/${CHART_FOLDER}

helm version -c

helm inspect chart .

[[ $CHARTMUSEUM_REPO_NAME ]] && helm repo add ${CHARTMUSEUM_REPO_NAME} ${CHARTMUSEUM_URL_STABLE} --username=${CHARTMUSEUM_USER} --password=${CHARTMUSEUM_PASSWORD}

helm dependency update .

helm package .

echo "GIT_BRANCH_NAME=${GIT_BRANCH_NAME}"
if [[ ! $GIT_BRANCH_NAME =~ .*${GIT_STABLE_BRANCH_NAME}$ ]]; then
  echo "The git branch isn't the stable one so it will push on the unstable helm registry..."
  CHARTMUSEUM_URL="${CHARTMUSEUM_URL_UNSTABLE}"
fi

helm cm-push ${CHART_FOLDER}-* ${CHARTMUSEUM_URL} -u ${CHARTMUSEUM_USER} -p ${CHARTMUSEUM_PASSWORD} ${FORCE}
