locals {
  servers_map = { for server in var.servers_others : server.name => server }

  servers_behind_lb = [
    for i in range(1, var.servers_behind_lb_count + 1) : {
      name                        = format("${var.servers_behind_lb_name}-%03d", i)
      image                       = var.servers_behind_lb_image
      server_type                 = var.servers_behind_lb_server_type
      location                    = var.servers_behind_lb_location
      backups                     = var.servers_behind_lb_backups
      keep_disk                   = var.servers_behind_lb_keep_disk
      placement_group_name        = var.servers_behind_lb_placement_group_name
      network_subnet_name         = var.servers_behind_lb_network_subnet_name
      tz                          = var.servers_behind_lb_tz
      ipv4_enabled                = var.servers_behind_lb_ipv4_enabled
      ipv6_enabled                = var.servers_behind_lb_ipv6_enabled
      servers_behind_lb_subnet_ip = format("${var.servers_behind_lb_subnet_ip}.%d", i)
      labels                      = var.servers_behind_lb_labels
    }
  ]

  servers_map_behind_lb = { for server in local.servers_behind_lb : server.name => server }
}

data "hcloud_ssh_keys" "all_keys" {
}

resource "hcloud_server" "behind_lb" {
  for_each           = local.servers_map_behind_lb
  name               = each.key
  image              = each.value.image
  server_type        = each.value.server_type
  location           = each.value.location
  backups            = each.value.backups
  keep_disk          = each.value.keep_disk
  placement_group_id = hcloud_placement_group.hosting[each.value.placement_group_name].id
  ssh_keys           = data.hcloud_ssh_keys.all_keys.ssh_keys.*.name
  depends_on         = [tls_private_key.ED25519]
  labels             = each.value.labels

  network {
    network_id = hcloud_network.default[each.value.network_subnet_name].id
    ip         = each.value.servers_behind_lb_subnet_ip
  }

  public_net {
    ipv4_enabled = each.value.ipv4_enabled
    ipv6_enabled = each.value.ipv6_enabled
  }

  user_data = templatefile("${path.module}/templates/98-cloud_init.tftpl",
    {
      hostname                  = each.key
      fqdn                      = hetznerdns_zone.jazzfest.name
      prefer_fqdn_over_hostname = false
      package_update            = true
      package_upgrade           = true
      timezone                  = var.tz
      ssh_user_name_gitact      = "sshgitusername"
      public_key_ecdsa_git      = tls_private_key.ED25519.public_key_openssh
    }
  )
}

resource "hcloud_server" "others" {
  for_each           = local.servers_map
  name               = each.key
  image              = each.value.image
  server_type        = each.value.server_type
  location           = each.value.location
  backups            = each.value.backups
  keep_disk          = each.value.keep_disk
  placement_group_id = hcloud_placement_group.hosting[each.value.placement_group_name].id
  ssh_keys           = data.hcloud_ssh_keys.all_keys.ssh_keys.*.name
  depends_on         = [tls_private_key.ED25519]
  labels             = each.value.labels

  network {
    network_id = hcloud_network.default[each.value.network_subnet_name].id
    ip         = each.value.ip
  }

  public_net {
    ipv4_enabled = each.value.ipv4_enabled
    ipv6_enabled = each.value.ipv6_enabled
  }

  user_data = templatefile("${path.module}/templates/98-cloud_init.tftpl",
    {
      hostname                  = each.key
      fqdn                      = hetznerdns_zone.jazzfest.name
      prefer_fqdn_over_hostname = false
      package_update            = true
      package_upgrade           = true
      timezone                  = var.tz
      ssh_user_name_gitact      = "sshgitusername"
      public_key_ecdsa_git      = tls_private_key.ED25519.public_key_openssh
    }
  )
}