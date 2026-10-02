#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/cron/audit_cron_allow.sh"

cron_base_dir=/tmp/test-cron
at_base_dir=/tmp/test-at
set_cron_allow_paths
[ "${cron_file}" = /tmp/test-cron/cron.allow ] || {
  echo "cron allow path was not derived from cron_base_dir" >&2
  exit 1
}
[ "${at_file}" = /tmp/test-at/at.allow ] || {
  echo "at allow path was not derived from at_base_dir" >&2
  exit 1
}

echo "cron allow path mapping passed"
