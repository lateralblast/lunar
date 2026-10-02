#!/bin/sh

# csv_quote
#
# Quote one CSV field, doubling embedded double quotes.
#.

csv_quote () {
  csv_quoted=$( printf '%s' "${1}" | sed 's/"/""/g' )
  printf '"%s"' "${csv_quoted}"
}
