locals {
  instance_name_prefix      = terraform.workspace
  raw_ssh_user              = "ubuntu"
  lxd_remote_ipv4           = "192.168.2.20"
  wp_app_public_ssh_port    = "22001"
  wp_bdd_public_ssh_port    = "22002"
  ssh_public_key_file       = var.ssh_public_key_file
}
