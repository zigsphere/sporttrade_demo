# Sporttrade Terraform Demo

### This Demo runs the site http://sporttrade-example.devopsbookmarks.com

Using the my own provided `terraform.tfvars` file and utilizing the default variable defaults, this deploys a 3-node web server cluster behind an HTTP load balancer using Linode's provider.

![Diagram](https://s3.us-west-1.wasabisys.com/cdn.zigsphere.com/external/sporttrade_diagram.png "Diagram")

## The Terraform code will do the following:
 - Create the Linode instances. The number of instances can be provided in `terraform.tfvars`. If the number is increased or decreased, the appropriate changes will be made to the load balancer for the backend nodes.
 - Load balancer creation (nodebalancer). Will Create a public IP and add the web nodes to the backend as necessary with the health checks, interval, timeout, algorithm, etc. Port 80
 - Creation of the domain - The sporttrade-example.devopsbookmarks.com 'A' record will be created (or the domain specified in `terraform.tfvars`) once the load balancer is created and has an IP.
 - A Firewall is also added to the web nodes. Port 80 is being allowed by the load balancer internal subnet; however, nodes cannot be reached directly by the public internet. Port 22 is also being allowed (optional). This was for troubleshooting purposes. 
 - Nginx an Docker are being managed on each VM. Nginx files are placed onto each web node and copied to each directory respectively. 
 - The web application is a project I own (https://www.devopsbookmarks.com): https://github.com/devopsbookmarks-org/devopsbookmarks.org. This runs in Docker.


## Considerations
There is so much more that can be added to this, but were not implemented

- SSL (443). If I had my own CA and secrets manager, I could provide the load balancer a cert and key to make this SSL.
- Each web node builds the container locally. A container registry would decrease the web node build time dramatically. 
- Terraform modules could be used here, but for the sake of time, were not used. This is a single app, so modules weren't used.
- For the domain, the entire "devopsbookmarks.com" zone is not managed with Terraform, so this is why the ID of this particular zone is hardcoded in the `domain.tf` file. Otherwise, the ID would be pulled automatically

## Example terraform.tfvars file:
```
linode_token    = "XXXXXXXXXX"
root_password   = "Th15is@StrongPassword"
ssh_key_pub     = "~/.ssh/linode/id_rsa.pub"
ssh_key         = "~/.ssh/linode/id_rsa"
linode_username = "linode_username"
node_count      = 3
domain          = "sporttrade-example.devopsbookmarks.com"
email           = "joseph@josephziegler.com"
hq_home_ip      = "209.X.X.X" # optional
```

