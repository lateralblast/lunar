# audit_kubernetes_etcd
#
# Refer to Section(s) 1.1.1-39 Page(s) 13-88   CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 1.4.1-21 Page(s) 109-128 CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 1.5.1-7  Page(s) 151-164 CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 1.6.1-8  Page(s) 165-180 CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 1.7.1-7  Page(s) 181-194 CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 2.1.1-14 Page(s) 195-222 CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 2.2.1-10 Page(s) 223-242 CIS Kubernetes Benchmark v1.4.0
#
# Still to be completed
#.

audit_kubernetes_etcd () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    daemon_check=$( ps -ef | grep "etcd" |grep -v grep )
    if [ "$daemon_check" ]; then
      check_file="/etc/kubernetes/manifests/etcd.yaml"
      if [ -f "$check_file" ]; then
        check_file_perms $check_file 0644 root root
        check_file_value is $check_file "--client-cert-auth" eq "true" hash
        check_file_value set $check_file "--cert-file" eq "na" hash
        check_file_value set $check_file "--key-file" eq "na" hash
        check_file_value is $check_file "--peer-client-cert-auth" eq "true" hash
        check_file_value is $check_file "--peer-auto-tls" eq "false" hash
        check_file_value set $check_file "--trusted-ca-file" eq "na" hash
      fi
    fi
  fi
}