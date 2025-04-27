#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_pam_deny
#
# Add pam.deny to pam config files
#
# Refer to Section(s) 6.7   Page(s) 23  CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 6.3.3 Page(s) 162 CIS RHEL 5 Benchmark v2.1.0
#.

audit_pam_deny () {
  if [ "${os_name}" = "FreeBSD" ] || [ "${os_name}" = "Linux" ]; then
     verbose_message "PAM Deny Weak Authentication Services" "check"
    if [ "${os_name}" = "FreeBSD" ]; then
      if [ "${os_version}" -lt 5 ]; then
        check_append_file "/etc/pam.conf" "rexecd\tauth\trequired\tpam_deny.so" "hash"
        check_append_file "/etc/pam.conf" "rsh\tauth\trequired\tpam_deny.so"    "hash"
      else
        :
        # Need to insert code here
        # sed -i .preCIS -e 's/nologin/deny/g' /etc/pam.d/rsh /etc/pam.d/rexecd
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_append_file "/etc/pam.d/sshd" "auth\trequisite\tpam_deny.so" "hash"
    fi
  fi
}
