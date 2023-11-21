resource "ovh_cloud_project_kube" "my_kube_cluster" {
  count        = var.nb_cluster
  service_name = var.service_name
  name         = "my_kube_cluster2"
  region       = var.region
}

resource "ovh_cloud_project_kube_nodepool" "my_pool" {
  count = var.nb_cluster
  service_name  = var.service_name
  kube_id       = ovh_cloud_project_kube.my_kube_cluster[count.index].id
  name          = "my-pool" //Warning: "_" char is not allowed!
  flavor_name   = var.flavor_name
  desired_nodes = var.nb_nodes
  max_nodes     = var.nb_nodes
  min_nodes     = 1
}

resource "local_file" "kubeconfig" {
    count       = var.nb_cluster
    content     = ovh_cloud_project_kube.my_kube_cluster[count.index].kubeconfig
    filename = "my-kube-cluster-${count.index}.yml"
}