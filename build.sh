#!/bin/bash

source ./.env

usage() {
    echo "Usage: $0 [-l][-h][-v version {major.medium.minor} (example 5.0.0) ]"
    exit 1
}

info() {
    echo -e "\e[1;33mINFO:\e[0m ${1}"
}

error() {
    echo -e "\e[1;31mERROR:\e[0m ${1}"
    exit 1
}

success() {
    echo -e "\e[1;32mSUCCESS:\e[0m ${1}"
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
    error "Invalid version: '${version}'"
  fi

  if [[ ! (${version} =~ ${regex}) ]]; then
    error "Invalid version: '${version}'"
  fi

  local major=$(echo ${version} | cut -d '.' -f 1)
  local medium=$(echo ${version} | cut -d '.' -f 2)
  local minor=$(echo ${version} | cut -d '.' -f 3)

  if [[ ! -n ${minor} ]]; then
    error "Invalid minor version : '${version}'"
  fi

  info "Starting script for Phalcon version ${major}.${medium}.${minor}:  major ${major}, medium ${medium}, minor ${minor}"

  VERSION=${major}.${medium}.${minor}
}

build() {
  local tmp=$(mktemp -d)
  local extension='tar.gz'
  local url="https://github.com/${1}/${2}/archive/refs/tags/v${3}.${extension}"
  local file="${tmp}/v${3}.${extension}"
  local major=$(echo ${3} | cut -d '.' -f 1)

  if [[ ! -d ${tmp} ]]; then
    eeror "Failed to create temporary directory"
  else
    success "Created temporary directory ${tmp}"
  fi

  info "Downloading ${url}"
  curl -L -o "${file}" -H "Accept: application/vnd.github.v3+json" -H "User-Agent: Mozilla/5.0" "${url}"
  if [[ $? -ne 0 ]]; then
    error "Failed to download ${url}"
  elif [[ ! -f ${file} ]]; then
    error "Downloaded file not found"
  else
    success "Download file saved to ${file}"
  fi

  info "Extracting ${file}"
  tar -xvzf ${file} -C ${tmp}
  if [[ $? -ne 0 ]]; then
    error "Failed to extract ${file}"
  else
    success "Extracted successfully"
  fi

  info "Creating build directory"
  rm -rf ./${BUILD_DIR}
  mkdir -p ./${BUILD_DIR}
  if [[ $? -ne 0 ]]; then
    error "Failed to create build directory"
  else
    success "Build directory created successfully"
  fi
  mkdir -p ./${BUILD_DIR}/src/Phalcon
  if [[ $? -ne 0 ]]; then
    error "Failed to create source directory"
  else
    success "Source directory created successfully"
  fi

  info "Coping source files"
  if [[ ! -d ${tmp}/${2}-${3}/src ]]; then
    error "Source directory not found in ${tmp}/${2}-${3}/src"
  fi
  cp -r ${tmp}/${2}-${3}/src/* ./${BUILD_DIR}/src/Phalcon/
  if [[ $? -ne 0 ]]; then
    error "Failed to copy source files"
  else
    success "Copied: ${tmp}/${2}-${3}/src --> ./${BUILD_DIR}/src/Phalcon"
  fi

  info "Building META files"
  cp -r ${META_DIR} ./${BUILD_DIR}/META-INF
  if [[ $? -ne 0 ]]; then
    error "Failed to copy META files"
  else
    info "META files copied"
  fi
  sed -i -e "s/{version}/${3}/g" ./${BUILD_DIR}/META-INF/plugin.xml
  if [ $? -ne 0 ]; then
    error "Failed to replace version in plugin.xml"
  else
    info "Version replaced"
  fi
  sed -i -e "s/{major}/${major}/g" ./${BUILD_DIR}/META-INF/plugin.xml
  if [ $? -ne 0 ]; then
    error "Failed to replace major version in plugin.xml"
  else
    info "Major version replaced"
  fi
  success "Meta Files successfully created"

  info "Create JAR file"
  zip -r "./${BUILD_DIR}/phpstorm-phalcon-plugin-v${3}.jar" ./${BUILD_DIR}/*
  if [ $? -ne 0 ]; then
    error "Failed to create JAR file"
  else
    success "JAR file created successfully"
  fi

  info "Re-creating plugin directory"
  rm -rf ./${PLUGIN_DIR}
  mkdir -p ./${PLUGIN_DIR}
  if [[ $? -ne 0 ]]; then
    error "Failed to create plugin directory"
  else
    success "Plugin directory created successfully"
  fi

  info "Update plugin files"
  cp -r ./${BUILD_DIR}/* ./${PLUGIN_DIR}/
  if [ $? -ne 0 ]; then
    error "Failed copy files into plugin"
  else
    success "Files copied to plugin directory"
  fi

  info "Remove BUILD directory"
  rm -rf ./${BUILD_DIR}
  if [ $? -ne 0 ]; then
    error "Failed remove build directory"
  else
    success "Build directory successfully removed"
  fi
}

while getopts ":v:l" opt; do
  case ${opt} in
    v )
      VERSION=$OPTARG
      ;;
    l )
      VERSION=$(latest_github_version ${GITHUB_USER} ${GITHUB_REPO})
      ;;
    \? )
      usage
      ;;
  esac
done

check_version ${VERSION}
build ${GITHUB_USER} ${GITHUB_REPO} ${VERSION}
