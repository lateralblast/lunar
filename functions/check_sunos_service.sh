
# check_sunos_service
#
# Service audit routine wrapper, sends to appropriate function based on service type
#
# service_name    = Name of service
# correct_status  = What the status of the service should be, ie enable/disabled
#.

check_sunos_service () {
  if [ "$os_name" = "SunOS" ]; then
    temp_name=$1
    temp_status=$2
    if [ "$temp_name" = "disable" ] || [ "$temp_name" = "enable" ]; then
      service_name=$temp_status
      if [ "$temp_name" = "disable" ]; then
        correct_status="disabled"
      else
        correct_status="enabled"
      fi
    else
      service_name=$temp_name
      correct_status=$temp_status
    fi
    if [ $( expr "$service_name" : "svc:" ) = 4 ]; then
      check_svcadm_service $service_name $correct_status
    else
      check_initd_service $service_name $correct_status
      check_inetd_service $service_name $correct_status
    fi
  fi
}
