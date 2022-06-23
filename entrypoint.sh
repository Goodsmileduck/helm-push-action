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

# Using the repo name as the chart name and not the chart folder name
PACKAGE=$(helm package --app-version $CHART_APP_VERSION --version $CHART_VERSION . | rev | cut -d'/' -f1 | rev)
helm cm-push --force $PACKAGE chartmuseum