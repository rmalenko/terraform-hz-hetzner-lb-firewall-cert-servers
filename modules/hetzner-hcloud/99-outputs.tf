# output "infrastructure_group_id" {
#   value = hcloud_placement_group.infrastructure.id
# }

# output "hosting_group_id" {
#   value = hcloud_placement_group.hosting.id
# }

# output "firewall_private-ds" {
#   value = hcloud_firewall.private-ds.id
# }

# output "firewall_Base_monitoring" {
#   value = hcloud_firewall.Base_monitoring.id
# }

# output "firewall_no_cloudflare" {
#   value = hcloud_firewall.no_cloudflare.id
# }

# output "firewall_with_cloudflare" {
#   value = hcloud_firewall.with_cloudflare.id
# }

# output "network_ids" {
#   description = "A map of all network objects indexed by ID."
#   value       = module.network.network_names
# }

output "private_key_rsa" {
  value     = trimspace(tls_private_key.rsa_4096.private_key_openssh)
  sensitive = true
}

output "public_key_rsa" {
  value     = trimspace(tls_private_key.rsa_4096.public_key_openssh)
  sensitive = true
}

output "private_key_ecdsa" {
  value     = trimspace(tls_private_key.ED25519.private_key_openssh)
  sensitive = true
}

output "public_key_ecdsa" {
  value     = trimspace(tls_private_key.ED25519.public_key_openssh)
  sensitive = true
}

# Lets encrypt certificates
locals {
  output_certificates = [
    for cert in merge(
      {
        for name, cert in hcloud_uploaded_certificate.certificates :
        name => merge(cert, {
          "private_key" = null
        })
      },
      hcloud_managed_certificate.certificates
    ) : cert
  ]
}

output "certificates" {
  description = "A list of all certificate objects."
  value       = local.output_certificates
}

output "certificate_ids" {
  description = "A map of all certificate objects indexed by ID."
  value = {
    for cert in local.output_certificates : cert.id => cert
  }
}

output "certificate_names" {
  description = "A map of all certificate objects indexed by name."
  value = {
    for cert in local.output_certificates : cert.name => cert
  }
}

output "certificate_ids_list" {
  value = tolist(
    [for cert in hcloud_managed_certificate.certificates : cert.id]
  )
}

output "server_ips_behind_lb" {
  value = {
    for k, v in hcloud_server.behind_lb : k =>
    {
      hostname    = v.name
      external_ip = v.ipv4_address
      internal_ip = v.network[*]["ip"]
    }
  }
}

output "server_ips_others" {
  value = {
    for k, v in hcloud_server.others : k =>
    {
      hostname    = v.name
      external_ip = v.ipv4_address
      internal_ip = v.network[*]["ip"]
    }
  }
}