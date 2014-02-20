# audit_opengl
#
# OpenGL. Not required unless running a GUI. Not required on a server.
#.

audit_opengl () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "OpenGL"
      service_name="svc:/application/opengl/ogl-select:default"
      funct_service $service_name disabled
    fi
  fi
}
