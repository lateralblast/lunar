# audit_postgresql
#
# Turn off postgresql if not required
# Recommend removing this from base install as it slows down patching significantly
#.

audit_postgresql () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "PostgreSQL Database"
      service_name="svc:/application/database/postgresql_83:default_32bit"
      funct_service $service_name disabled
      service_name="svc:/application/database/postgresql_83:default_64bit"
      funct_service $service_name disabled
      service_name="svc:/application/database/postgresql:version_81"
      funct_service $service_name disabled
      service_name="svc:/application/database/postgresql:version_82"
      funct_service $service_name disabled
      service_name="svc:/application/database/postgresql:version_82_64bit"
      funct_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "PostgreSQL Database"
    service_name="postgresql"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 5 off
  fi
}
