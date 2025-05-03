#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_cde_spc
#
# CDE Subprocess control. Not required unless running CDE applications.
#.

audit_cde_spc () {
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      verbose_message     "Subprocess control"            "check"
      check_sunos_service "svc:/network/cde-spc:default"  "disabled"
    fi
  fi
}
