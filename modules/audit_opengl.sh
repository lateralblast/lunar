# audit_opengl
#
# OpenGL. Not required unless running a GUI. Not required on a server.
#.

audit_opengl () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      verbose_message "OpenGL"
      service_name="svc:/application/opengl/ogl-select:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
