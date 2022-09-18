resource "lxd_cached_image" "ubuntu1804" {
  source_remote = "ubuntu"
  source_image  = "18.04"
}

resource "lxd_container" "app-server" {
  name      = "${local.instance_name_prefix}-wp-app"
  image     = lxd_cached_image.ubuntu1804.fingerprint
  ephemeral = false

  config = {
    "boot.autostart" = true
  }

  file {
    target_file        = "/home/${local.raw_ssh_user}/.ssh/authorized_keys"
    source             = local.ssh_public_key_file
    create_directories = true
    mode               = "0750"
    uid                = 1000
    gid                = 1000
  }

  limits = {
    cpu = 1
  }
}

resource "lxd_container" "bdd-server" {
  name      = "${local.instance_name_prefix}-wp-bdd"
  image     = lxd_cached_image.ubuntu1804.fingerprint
  ephemeral = false

  config = {
    "boot.autostart" = true
  }

  file {
    target_file        = "/home/${local.raw_ssh_user}/.ssh/authorized_keys"
    source             = local.ssh_public_key_file
    create_directories = true
    mode               = "0750"
    uid                = 1000
    gid                = 1000
  }

  limits = {
    cpu = 1
  }
}
