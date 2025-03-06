#!/bin/bash

GITHUB_USER="phalcon"
GITHUB_REPO="ide-stubs"
BUILD_DIR="build"
META_DIR="meta"
VERSION=""

usage() {
    echo "Usage: $0 [-l][-h][-v version {major.medium.minor} example 5.0.0 ]"
    exit 1
}

log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - ${message}"
}

latest_github_version() {
   if [[ -n ${1} && -n ${2} ]]; then
     local VERSION=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/${1}/${2}/releases/latest)
     echo ${VERSION##*/v}
   fi
}

check_version() {
  local version="$1"
  local regex='^([0-9]+\.){0,2}(\*|[0-9]+)$'

  if [[ -z "${version}" ]]; then
    read -p "Enter the version number: " version
  fi

  if [[ ${version} != *"."* ]];then
    log "ERROR:<-> Invalid version: '${version}'"
    exit 1
  fi

  if [[ ! (${version} =~ ${regex}) ]]; then
    log "ERROR:<-> Invalid version: '${version}'"
    exit 1
  fi

  local major=$(echo ${version} | cut -d '.' -f 1)
  local medium=$(echo ${version} | cut -d '.' -f 2)
  local minor=$(echo ${version} | cut -d '.' -f 3)

  if [[ ! -n ${minor} ]]; then
    log "ERROR:<-> Invalid version (o Minor version): '${version}'"
    exit 1
  fi

  log "Starting script for Phalcon version ${major}.${medium}.${minor}:  major ${major}, medium ${medium}, minor ${minor}"

  VERSION=${major}.${medium}.${minor}
}

build() {
  local tmp=$(mktemp -d)
  local extension='tar.gz'
  local url="https://github.com/${1}/${2}/archive/refs/tags/v${3}.${extension}"
  local file="${tmp}/v${3}.${extension}"
  local major=$(echo ${3} | cut -d '.' -f 1)

  if [[ ! -d ${tmp} ]]; then
    log "Failed to create temporary directory"
    exit 1
  else
      log "Created temporary directory ${tmp}"
  fi

  log "Downloading ${url}"
  curl -L -o "${file}" -H "Accept: application/vnd.github.v3+json" -H "User-Agent: Mozilla/5.0" "${url}"
  if [[ $? -ne 0 ]]; then
    log "Failed to download ${url}"
    exit 1
  elif [[ ! -f ${file} ]]; then
    log "Downloaded file not found"
    exit 1
  else
    log "Download file saved to ${file}"
  fi

  log "Extracting ${file}"
  tar -xvzf ${file} -C ${tmp}
  if [[ $? -ne 0 ]]; then
    log "Failed to extract ${file}"
    exit 1
  else
    log "Extracted successfully"
  fi

  log "Creating build directory"
  rm -rf ./${BUILD_DIR}
  mkdir -p ./${BUILD_DIR}
  if [[ $? -ne 0 ]]; then
    log "Failed to create build directory"
    exit 1
  else
    log "Build directory created successfully"
  fi
  mkdir -p ./${BUILD_DIR}/src/Phalcon
  if [[ $? -ne 0 ]]; then
    log "Failed to create source directory"
    exit 1
  else
    log "Source directory created successfully"
  fi
  log "Coping source files"
  if [[ ! -d ${tmp}/${2}-${3}/src ]]; then
    log "Source directory not found in ${tmp}/${2}-${3}/src"
    exit 1
  fi
  cp -r ${tmp}/${2}-${3}/src/* ./${BUILD_DIR}/src/Phalcon
  if [[ $? -ne 0 ]]; then
    log "FAILED: to copy source files"
    exit 1
  else
    log "COPIED: ${tmp}/${2}-${3}/src --> ./${BUILD_DIR}/src/Phalcon"
  fi

  log "Building META files"
  cp -r ${META_DIR} ./${BUILD_DIR}/META-INF
  if [[ $? -ne 0 ]]; then
    log "Failed to copy META files"
    exit 1
  else
    log "META files copied successfully"
  fi
  sed -i -e "s/{version}/${3}/g" ./${BUILD_DIR}/META-INF/plugin.xml
  if [ $? -ne 0 ]; then
    log "Failed to replace version in plugin.xml"
    exit 1
  fi
  sed -i -e "s/{major}/${major}/g" ./${BUILD_DIR}/META-INF/plugin.xml
  if [ $? -ne 0 ]; then
    log "Failed to replace major version in plugin.xml"
    exit 1
  fi

  log "Create JAR file"
  zip -r "./${BUILD_DIR}/phpstorm-phalcon-plugin-v${3}.jar" ./${BUILD_DIR}/*
  if [ $? -ne 0 ]; then
    log "Failed to create JAR file"
    exit 1
  fi
}

GITHUB_USER="phalcon"
GITHUB_REPO="ide-stubs"
BUILD_DIR="build"
META_DIR="meta"
VERSION=""

while getopts ":v:l:h" opt; do
  case ${opt} in
    v )
      VERSION=$OPTARG
      ;;
    l )
      VERSION=$(latest_github_version ${GITHUB_USER} ${GITHUB_REPO})
      ;;
    h )
      usage
      ;;
    \? )
      usage
      ;;
  esac
done

check_version ${VERSION}
build ${GITHUB_USER} ${GITHUB_REPO} ${VERSION}
