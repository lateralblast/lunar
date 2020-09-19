# audit_kubernetes_controller
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

audit_kubernetes_controller () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    daemon_check=$( ps -ef | grep "kube-controller-manager" | grep -v grep )
    if [ "$daemon_check" ]; then
      check_file="/etc/kubernetes/manifests/kube-controller-manager.yaml"
      if [ -f "$check_file" ]; then
        check_file_value is $check_file "--terminated-pod-gc-threshold" eq "10" hash
        check_file_value is $check_file "--use-service-account-credentials" eq "true" hash
        check_file_value set $check_file "--service-account-private-key-file" eq "na" hash
        check_file_value set $check_file "--root-ca-file" eq "na" hash
        check_file_value is $check_file "--feature-gates" eq "RotateKubeletServerCertificate=true" hash # yes
      fi
    fi
  fi
}