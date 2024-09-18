terraform {
  backend "local" {
    path = "state_files/terraform.tfstate"
  }
}

provider "linode" {
  token = var.linode_token
}

data "linode_user" "devopsbookmarks" {
  username = var.linode_username
}

resource "linode_instance" "devops_nodes" {
  count  = var.node_count
  label  = "devopsbookmarks-node-${count.index + 1}"
  region = var.linode_region
  image  = var.linode_image
  type   = var.linode_type

  private_ip       = true
  authorized_users = [data.linode_user.devopsbookmarks.username]
  authorized_keys  = [chomp(file(var.ssh_key_pub))]
  root_pass        = var.root_password
  tags             = ["internal_devopsbookmarks"]

  provisioner "file" {
    source      = "files/nginx.conf"
    destination = "/tmp/nginx.conf"
    connection {
      type        = "ssh"
      user        = "root"
      private_key = chomp(file(var.ssh_key))
      host        = self.ip_address
      agent       = false
    }
  }

  provisioner "file" {
    source      = "files/sporttrade-example.devopsbookmarks.com.conf"
    destination = "/tmp/sporttrade-example.devopsbookmarks.com.conf"
    connection {
      type        = "ssh"
      user        = "root"
      private_key = chomp(file(var.ssh_key))
      host        = self.ip_address
      agent       = false
    }
  }

  provisioner "remote-exec" {
    inline = [
      "hostnamectl set-hostname ${self.label}",
      "sed 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' -i /etc/sudoers",
      "useradd -m -g users -G wheel -s /bin/bash ${var.linode_username}",
      "echo '${var.linode_username}:${var.root_password}' | chpasswd",
      "apt-get update && apt-get install -y curl git nginx",
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sh get-docker.sh",
      "git clone https://github.com/devopsbookmarks-org/devopsbookmarks.org.git /opt/devopsbookmarks",
      "docker build -f /opt/devopsbookmarks/Dockerfile -t devops /opt/devopsbookmarks",
      "docker run -p 3000:3000/tcp -d --name devops devops",
      "cp /tmp/nginx.conf /etc/nginx/nginx.conf",
      "cp /tmp/sporttrade-example.devopsbookmarks.com.conf /etc/nginx/sites-enabled/sporttrade.devopsbookmarks.com.conf",
      "systemctl reload nginx.service"

    ]
    connection {
      type        = "ssh"
      user        = "root"
      private_key = chomp(file(var.ssh_key))
      host        = self.ip_address
      agent       = false
    }
  }
}
