#!/bin/bash

set -euo pipefail

# Function to handle errors
error_handler() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo -e "\e[31mThe script exited with status ${exit_code}.\e[0m" 1>&2
        cleanup
        exit ${exit_code}
    fi
}

trap error_handler EXIT

# Function to run commands and capture stderr
run_cmd() {
    local cmd="$1"
    local stderr_file=$(mktemp)

    if ! eval "$cmd" > /dev/null 2>$stderr_file; then
        echo -e "\e[31mError\n Command '$cmd' failed with output:\e[0m" 1>&2
        cat $stderr_file | awk '{print " \033[31m" $0 "\033[0m"}' 1>&2
        rm -f $stderr_file
        exit 1
    fi

    rm -f $stderr_file
}

# Function to print OK message
print_ok () {
    echo -e "\e[32mOK\e[0m"
}

# Default values
df_os_ver="almalinux9"
df_vm_tmpl_id="9000"
df_vm_tmpl_name="ubuntu-2404"
df_vm_username="root"
df_vm_password="password"
df_vm_sshkey=""
df_vm_timezone="Asia/Ho_Chi_Minh"
#Path download
df_os_centos7="https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2"
df_os_centos8=""
df_os_centos9="https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-x86_64-9-latest.x86_64.qcow2"
df_os_alma8="https://repo.almalinux.org/almalinux/8/cloud/x86_64/images/AlmaLinux-8-GenericCloud-latest.x86_64.qcow2"
df_os_alma9="https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
df_os_rocky8="https://dl.rockylinux.org/pub/rocky/8/images/x86_64/Rocky-8-GenericCloud-Base.latest.x86_64.qcow2"
df_os_rocky9="https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"

# Prompt for user input
read -p "Enter OS (default: ${df_os_ver}): " os_ver
os_ver="${os_ver:-$df_os_ver}"

