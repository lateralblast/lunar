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
        for service_name in "svc:/application/database/postgresql_83:default_32bit" \
          "svc:/application/database/postgresql_83:default_64bit" \
          "svc:/application/database/postgresql:version_81" \
          "svc:/application/database/postgresql:version_82" \
          "svc:/application/database/postgresql:version_82_64bit"; do
          check_sunos_service $service_name disabled
        done
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      service_name="postgresql"
      check_linux_service $service_name off
    fi
  fi
}
