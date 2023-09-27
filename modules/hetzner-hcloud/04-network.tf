locals {
  network_map = { for network in var.networks : network.name => network }
}

resource "hcloud_network" "default" {
  for_each          = local.network_map
  name              = each.key
  ip_range          = each.value.ip_range_network
  labels            = each.value.labels
  delete_protection = each.value.delete_protection
}

resource "hcloud_network_subnet" "default" {
  for_each     = hcloud_network.default
  network_id   = each.value.id
  type         = lookup(local.network_map[each.key], "network_type", "cloud")
  network_zone = lookup(local.network_map[each.key], "network_zone", "eu-central")
  ip_range     = lookup(local.network_map[each.key], "ip_range_subnet", null)
  vswitch_id   = lookup(local.network_map[each.key], "vswitch_id", null)
}

