resource "linode_firewall" "internal_devops_nodes" {
  label = "internal-devops-nodes-firewall"

  inbound {
    label    = "allow-devops-port"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "80"
    #ipv4     = ["${linode_nodebalancer.devops_bookmarks.ipv4}/32"] # This does not work per Linode Support
    ipv4 = ["192.168.255.0/24"]
  }

  # Allow SSH for troubleshooting purposes, but not required
  dynamic "inbound" {
    for_each = length(var.hq_home_ip) > 0 ? [1] : []
    content {
      label    = "allow-inbound-SSH"
      action   = "ACCEPT"
      protocol = "TCP"
      ports    = "22"
      ipv4     = ["${var.hq_home_ip}/32"]
    }
  }

  outbound_policy = "ACCEPT"
  inbound_policy  = "DROP"

  linodes = linode_instance.devops_nodes[*].id

}