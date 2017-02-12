# audit_postgresql
#
# Turn off postgresql if not required
# Recommend removing this from base install as it slows down patching significantly
#.

audit_postgresql () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "PostgreSQL Database"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/application/database/postgresql_83:default_32bit"
        check_sunos_service $service_name disabled
        service_name="svc:/application/database/postgresql_83:default_64bit"
        check_sunos_service $service_name disabled
        service_name="svc:/application/database/postgresql:version_81"
        check_sunos_service $service_name disabled
        service_name="svc:/application/database/postgresql:version_82"
        check_sunos_service $service_name disabled
        service_name="svc:/application/database/postgresql:version_82_64bit"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      service_name="postgresql"
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
    fi
  fi
}
