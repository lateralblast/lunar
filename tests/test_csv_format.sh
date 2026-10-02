#!/bin/sh

script_dir=$( CDPATH= cd "$(dirname "$0")" && pwd )
. "${script_dir}/../main/csv.sh"

row="$(csv_quote 'audit_aws_sns'),$(csv_quote 'Check SNS'),$(csv_quote 'PASS:SNS topic has subscribers, review "subscribers"'),$(csv_quote '')"
expected='"audit_aws_sns","Check SNS","PASS:SNS topic has subscribers, review ""subscribers""",""'

if [ "${row}" != "${expected}" ]; then
  printf 'Unexpected CSV row:\n%s\nExpected:\n%s\n' "${row}" "${expected}" >&2
  exit 1
fi

test_root=$( mktemp -d "${TMPDIR:-/tmp}/lunar-csv-test.XXXXXX" ) || exit 1
trap 'rm -rf "${test_root}"' 0 HUP INT TERM
default_path=$( csv_prepare_output "" "${test_root}/csv" "lunar_test.csv" ) || exit 1
if [ "${default_path}" != "${test_root}/csv/lunar_test.csv" ] || [ ! -d "${test_root}/csv" ]; then
  printf 'Default CSV directory was not prepared: %s\n' "${default_path}" >&2
  exit 1
fi

explicit_path=$( csv_prepare_output "${test_root}/custom reports/results.csv" "${test_root}/unused" "ignored.csv" ) || exit 1
if [ "${explicit_path}" != "${test_root}/custom reports/results.csv" ] || [ ! -d "${test_root}/custom reports" ]; then
  printf 'Explicit CSV parent directory was not prepared: %s\n' "${explicit_path}" >&2
  exit 1
fi

printf 'CSV formatting and output path checks passed\n'
