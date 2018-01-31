#!/usr/bin/env bash

RED="\e[01;31m"
GRY="\e[90m"
NRM="\e[00m"

WORKING_DIR=$(dirname "$BASH_SOURCE" | xargs realpath)

CONFIGS_DIR="${WORKING_DIR}/configs"
EXTENSIONS_DIR="${WORKING_DIR}/extensions"

echo_color() {
    local -r message=${1?message is not set}
    local -r color=${2?color is not set}
    echo -e "${color}${message}${NRM}";
}

find_ovpn_files() {
    local -r config_dir=${1?directory is not set}
    find "${config_dir}" -name "*.ovpn" -type f -print | xargs realpath --relative-to=${config_dir} | sort --ignore-case

}

# select main config file
PS3='Select openvpn config file: '
options=($(find_ovpn_files ${CONFIGS_DIR}))
select opt in "${options[@]}"
do
    if (( REPLY > 0 && REPLY <= ${#options[@]})); then
        openvpn_args="${openvpn_args} --config ${CONFIGS_DIR}/${opt}"
        break;
    else
        echo_color "Invalid option. Try another one." ${RED}
    fi
done

# load extensions configs
for extension_file in $(find_ovpn_files "${EXTENSIONS_DIR}")
do
    openvpn_args="${openvpn_args} --config ${EXTENSIONS_DIR}/${extension_file}"
done

openvpn_cmd="sudo openvpn ${openvpn_args}"
echo_color "${openvpn_cmd}" ${GRY}
${openvpn_cmd}
