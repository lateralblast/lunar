# audit_kubernetes_all
#
# Audit Kubernetes 
#
# All the Kubernetes specific tests
#.

audit_kubernetes_all () {
  audit_kubernetes_apiserver
  audit_kubernetes_scheduler
  audit_kubernetes_controller
  audit_kubernetes_etcd
  audit_kubernetes_kubelet
}

