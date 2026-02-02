#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_opengl
#
# OpenGL. Not required unless running a GUI. Not required on a server.
#.

audit_opengl () {
  print_function "audit_opengl"
  string="OpenGL"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      check_sunos_service "svc:/application/opengl/ogl-select:default" "disabled"
    fi
  else
    na_message "${string}"
  fi
}
