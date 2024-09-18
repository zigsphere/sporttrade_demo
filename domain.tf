#resource "linode_domain" "devops_domain" {
#  type      = "master"
#  domain    = var.domain
#  soa_email = var.email
#}

resource "linode_domain_record" "a_record" {
  domain_id   = "2978631" # This domain wasnt already being managed by Terraform
  name        = var.domain
  record_type = "A"
  target      = linode_nodebalancer.devops_bookmarks.ipv4
  depends_on  = [linode_nodebalancer.devops_bookmarks]
}