#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2009
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_kubernetes_perms
#
# Check Kubernetes permissions
#
# Refer to Section(s) 1.1.1-39 Page(s) 13-88   CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 1.4.1-21 Page(s) 109-128 CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 1.5.1-7  Page(s) 151-164 CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 1.6.1-8  Page(s) 165-180 CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 1.7.1-7  Page(s) 181-194 CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 2.1.1-14 Page(s) 195-222 CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 2.2.1-10 Page(s) 223-242 CIS Kubernetes Benchmark v1.4.0
#
# Still to be completed
#.

audit_kubernetes_perms () {
  print_function "audit_kubernetes_perms"
  if [ "${os_name}" = "Linux" ] || [ "${os_name}" = "Darwin" ]; then
    verbose_message "Kubernetes permissions" "check"
    check_file="/var/lib/etcd"
    if [ -f "${check_file}" ]; then
      check_file_perms    "${check_file}" "0700" "etcd" "etcd"
    fi
    for check_file in /etc/kubernetes/admin.conf /etc/kubernetes/scheduler.conf /etc/kubernetes/controller-manager.conf /etc/kubernetes/kubelet.conf; do
      if [ -f "${check_file}" ]; then
        check_file_perms  "${check_file}" "0644" "root" "root"
      fi
    done
    check_dir="/etc/kubernetes/pki"
    if [ -d "${check_dir}" ]; then
      file_list=$( find   "${check_dir}" -name "*.crt" -type f -maxdepth 1 )
      for check_file in ${file_list}; do
        check_file_perms  "${check_file}" "0644" "root" "root"
      done
      file_list=$( find   "${check_dir}" -name "*.key" -type f -maxdepth 1 )
      for check_file in ${file_list}; do
        check_file_perms  "${check_file}" "0600" "root" "root"
      done
    fi
  fi
}