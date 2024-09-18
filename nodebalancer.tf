resource "linode_nodebalancer" "devops_bookmarks" {
  label                = "devops_bookmarks_example"
  region               = var.linode_region
  client_conn_throttle = 20
}

resource "linode_nodebalancer_config" "devops_bookmarks" {
  nodebalancer_id = linode_nodebalancer.devops_bookmarks.id
  port            = 80
  protocol        = "http"
  check           = "http"
  check_path      = "/"
  check_attempts  = 3
  check_timeout   = 2
  check_interval  = 5
  algorithm       = "roundrobin"
}

resource "linode_nodebalancer_node" "devops_bookmarks" {
  count           = var.node_count
  mode            = "accept"
  nodebalancer_id = linode_nodebalancer.devops_bookmarks.id
  config_id       = linode_nodebalancer_config.devops_bookmarks.id
  address         = "${element(linode_instance.devops_nodes.*.private_ip_address, count.index)}:80"
  label           = "devopsbookmarks_example"
  weight          = 50

  lifecycle {
    replace_triggered_by = [linode_instance.devops_nodes]
  }
}