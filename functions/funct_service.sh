
# funct_service
#
# Service audit routine wrapper, sends to appropriate function based on service type
#
# service_name    = Name of service
# correct_status  = What the status of the service should be, ie enable/disabled
#.

funct_service () {
  if [ "$os_name" = "SunOS" ]; then
    service_name=$1
    correct_status=$2
    if [ `expr "$service_name" : "svc:"` = 4 ]; then
      funct_svcadm_service $service_name $correct_status
    else
      funct_initd_service $service_name $correct_status
      funct_inetd_service $service_name $correct_status
    fi
  fi
}
