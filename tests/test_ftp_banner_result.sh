#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/ftp/audit_ftp_banner.sh"

os_name=AIX
audit_mode=1
language_suffix=en_US
temp_dir=/tmp
insecure_count=0
secure_count=0
print_function() { :; }
check_message() { :; }
command_message() { :; }
verbose_message() { :; }
inc_insecure() { insecure_count=$((insecure_count + 1)); }
inc_secure() { secure_count=$((secure_count + 1)); }
fix_message() { :; }
check_lslpp() { lslpp_check="${1}"; }
dspcat() { printf '%s\n' '9   Unauthorised'; }

audit_ftp_banner
[ "${insecure_count}" -eq 1 ] && [ "${secure_count}" -eq 0 ] || {
  echo "incorrect AIX FTP banner was not reported insecure" >&2
  exit 1
}

echo "FTP banner result passed"
