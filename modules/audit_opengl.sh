#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_opengl
#
# OpenGL. Not required unless running a GUI. Not required on a server.
#.

audit_opengl () {
  print_module "audit_opengl"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      verbose_message     "OpenGL"                                     "check"
      check_sunos_service "svc:/application/opengl/ogl-select:default" "disabled"
    fi
  fi
}
