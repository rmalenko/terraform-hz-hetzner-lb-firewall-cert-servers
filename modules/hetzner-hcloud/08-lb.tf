# Adds a target to a Hetzner Cloud Load Balancer.

resource "hcloud_load_balancer" "load_balancer" {
  name               = var.lb_name
  load_balancer_type = var.load_balancer_type
  location           = var.lb_location
  algorithm {
    type = var.algorithm_type
  }
  labels = var.lb_labels
}

resource "hcloud_load_balancer_service" "https" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  protocol         = "https"
  listen_port      = 443
  destination_port = 80
  http {
    certificates = [for cert in hcloud_managed_certificate.certificates : cert.id]
  }
  health_check {
    protocol = "http"
    port     = 80
    interval = 10
    timeout  = 10
    retries  = 3
    http {
      path         = "/"
      status_codes = ["2??", "3??"]
      tls          = false
    }
  }
}

resource "hcloud_load_balancer_network" "hosting_network" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  network_id       = hcloud_network.default[var.network_for_lb].id
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  label_selector   = "load_balancer_name=${var.lb_name}"
  use_private_ip   = true
}

resource "hetznerdns_record" "wwwv4" {
  zone_id = hetznerdns_zone.jazzfest.id
  name    = "www"
  value   = hcloud_load_balancer.load_balancer.ipv4
  type    = "A"
  ttl     = 60
}

resource "hetznerdns_record" "atv4" {
  zone_id = hetznerdns_zone.jazzfest.id
  name    = "@"
  value   = hcloud_load_balancer.load_balancer.ipv4
  type    = "A"
  ttl     = 60
}

resource "hetznerdns_record" "wwwv6" {
  zone_id = hetznerdns_zone.jazzfest.id
  name    = "www"
  value   = hcloud_load_balancer.load_balancer.ipv6
  type    = "AAAA"
  ttl     = 60
}

resource "hetznerdns_record" "atv6" {
  zone_id = hetznerdns_zone.jazzfest.id
  name    = "@"
  value   = hcloud_load_balancer.load_balancer.ipv6
  type    = "AAAA"
  ttl     = 60
}