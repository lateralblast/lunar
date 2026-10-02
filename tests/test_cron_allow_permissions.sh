#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/cron/audit_cron_allow.sh"
expected="$(mktemp)"
actual="$(mktemp)"
trap 'rm -f "${expected}" "${actual}"' EXIT HUP INT TERM

check_file_perms() { printf '%s\n' "${1}" >> "${actual}"; }
printf '%s\n' /etc/crontab /etc/anacrontab /etc/cron.allow /etc/at.allow > "${expected}"
check_linux_cron_file_permissions
cmp -s "${expected}" "${actual}" || {
  echo "Linux cron permission checks missed an expected path" >&2
  exit 1
}

echo "cron permission paths passed"
