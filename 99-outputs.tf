output "server_ips_behind_lb" {
  value = module.hetzner_cloud.server_ips_behind_lb
}

output "server_ips_others" {
  value = module.hetzner_cloud.server_ips_others
}
