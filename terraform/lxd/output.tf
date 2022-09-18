output "lxd_remote_ipv4" {
  value = local.lxd_remote_ipv4
}

output "wp_app_ipv4" {
  value = lxd_container.app-server.ipv4_address
}

output "wp_bdd_ipv4" {
  value = lxd_container.bdd-server.ipv4_address
}

output "raw_ssh_user" {
  value = local.raw_ssh_user
}
