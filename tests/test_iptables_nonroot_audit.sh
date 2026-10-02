#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/firewall/audit_iptables.sh"
tmp_dir=$(mktemp -d)
trap 'rm -rf "${tmp_dir}"' EXIT HUP INT TERM
mkdir "${tmp_dir}/bin"
printf '#!/bin/sh\necho "DROP all -- 0.0.0.0/0 127.0.0.0/8"\n' > "${tmp_dir}/bin/iptables"
chmod +x "${tmp_dir}/bin/iptables"
PATH="${tmp_dir}/bin:${PATH}"

os_name=Linux
audit_mode=1
my_id=1000
use_sudo=0
secure=""
insecure=""
notice=""
print_function() { :; }
check_message() { :; }
check_linux_package() { :; }
check_linux_service() { :; }
inc_secure() { secure="$1"; }
inc_insecure() { insecure="$1"; }
notice_message() { notice="$1"; }

audit_iptables

[ -z "${secure}" ] && [ -z "${insecure}" ] && [ -n "${notice}" ] || {
  echo "Non-root audit fabricated a firewall result" >&2
  exit 1
}

echo "non-root iptables audit is reported as unavailable"
