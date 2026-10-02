#!/bin/sh

# csv_quote
#
# Quote one CSV field, doubling embedded double quotes.
#.

csv_quote () {
  csv_quoted=$( printf '%s' "${1}" | sed 's/"/""/g' )
  printf '"%s"' "${csv_quoted}"
}

# csv_prepare_output
#
# Select the default CSV path when needed and create its parent directory.
#.

csv_prepare_output () {
  csv_candidate="${1}"
  if [ -z "${csv_candidate}" ]; then
    csv_candidate="${2}/${3}"
  fi
  csv_parent=$( dirname "${csv_candidate}" )
  if [ ! -d "${csv_parent}" ]; then
    mkdir -p "${csv_parent}" || return 1
  fi
  printf '%s' "${csv_candidate}"
}
