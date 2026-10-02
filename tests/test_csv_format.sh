#!/bin/sh

script_dir=$( CDPATH= cd "$(dirname "$0")" && pwd )
. "${script_dir}/../main/csv.sh"

row="$(csv_quote 'audit_aws_sns'),$(csv_quote 'Check SNS'),$(csv_quote 'PASS:SNS topic has subscribers, review "subscribers"'),$(csv_quote '')"
expected='"audit_aws_sns","Check SNS","PASS:SNS topic has subscribers, review ""subscribers""",""'

if [ "${row}" != "${expected}" ]; then
  printf 'Unexpected CSV row:\n%s\nExpected:\n%s\n' "${row}" "${expected}" >&2
  exit 1
fi

printf 'CSV field quoting passed\n'
