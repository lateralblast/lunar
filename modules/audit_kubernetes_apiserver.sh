# audit_kubernetes_apiserver
#
# Refer to Section(s) 1.1.1-39 Page(s) 13-88 CIS Kubernetes Benchmark v1.4.0
#.

audit_kubernetes_apiserver () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    check_file="/etc/kubernetes/manifests/kube-apiserver.yaml"
    if [ -f "$check_file" ]; then
      check_file_value $check_file "--anonymous-auth" eq false hash 
    fi
  fi
}