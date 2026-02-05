#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# get_service_name_from_port_no
#
# Get the service name from the port number
#
# Arguments:
#   ${1} - Port number
#
# Returns:
#   Service name

get_service_name_from_port_no () {
  port_no="${1}"
  case "${port_no}" in
    3389) echo "RDP" ;;
    22)   echo "SSH" ;;
    *)    echo "Unknown" ;;
  esac
}


# cidr_to_mask
#
# Convert CIDR to netmask
#.

cidr_to_mask () {
  set -- $(( 5 - ($1 / 8) )) 255 255 255 255 $(( (255 << (8 - ($1 % 8))) & 255 )) 0 0 0
  if [ "${1}" -gt 1 ]; then
    shift "${1}" 
  else
    shift
  fi
  echo "${1-0}"."${2-0}"."${3-0}"."${4-0}"
}

# mask_to_cidr
#
# Convert netmask to CIDR
#.

mask_to_cidr () {
  x="${1##*255.}"
  set -- 0^^^128^192^224^240^248^252^254^ $(( (${#1} - ${#x})*2 )) "${x%%.*}"
  x=${1%%"${3}"*}
  echo $(( $2 + (${#x}/4) ))
}
