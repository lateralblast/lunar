#!/bin/sh

script_dir=$( CDPATH= cd "$(dirname "$0")" && pwd )
. "${script_dir}/../main/check_os_release.sh"

print_function () {
  :
}

get_ubuntu_codename "11.10"
if [ "${ubuntu_codename}" != "oneiric" ]; then
  printf 'Ubuntu 11.10 mapped to %s instead of oneiric\n' "${ubuntu_codename}" >&2
  exit 1
fi

printf 'Ubuntu 11.10 codename mapping passed\n'
