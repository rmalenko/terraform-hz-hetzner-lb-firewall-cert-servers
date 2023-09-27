# Firewal SSH - start
resource "hcloud_firewall" "ssh" {
  name   = var.name_firewall_ssh
  labels = var.labels_firewall_ssh

  dynamic "rule" {
    for_each = var.firewall_ssh
    content {
      direction       = rule.value.direction
      protocol        = rule.value.protocol
      port            = rule.value.port
      source_ips      = rule.value.source_ips
      destination_ips = rule.value.destination_ips
      description     = rule.value.description
    }
  }

  dynamic "apply_to" {
    for_each = var.firewall_ssh_label_selector
    content {
      label_selector = apply_to.value.label_selector
      server         = apply_to.value.server
    }
  }
}

# Firewal monitoring - start
resource "hcloud_firewall" "monitoring" {
  name   = var.name_firewall_monitoring
  labels = var.labels_firewall_monitoring

  dynamic "rule" {
    for_each = var.firewall_monitoring

    content {
      direction       = rule.value.direction
      protocol        = rule.value.protocol
      port            = rule.value.port
      source_ips      = rule.value.source_ips
      destination_ips = rule.value.destination_ips
      description     = rule.value.description
    }
  }

  dynamic "apply_to" {
    for_each = var.firewall_monitoring_label_selector

    content {
      label_selector = apply_to.value.label_selector
      server         = apply_to.value.server
    }
  }
}

# Firewal NO Cloudflare - start
resource "hcloud_firewall" "no_cloudflare" {
  name   = var.name_firewall_no_cloudflare
  labels = var.labels_firewall_no_cloudflare

  dynamic "rule" {
    for_each = var.rules_firewall_no_cloudflare

    content {
      direction       = rule.value.direction
      protocol        = rule.value.protocol
      port            = rule.value.port
      source_ips      = rule.value.source_ips
      destination_ips = rule.value.destination_ips
      description     = rule.value.description
    }
  }

  dynamic "apply_to" {
    for_each = var.firewall_no_cloudflare_label_selector

    content {
      label_selector = apply_to.value.label_selector
      server         = apply_to.value.server
    }
  }
}

# Firewal With Cloudflare - start
resource "hcloud_firewall" "with_cloudflare" {
  name   = var.name_firewall_cloudflare
  labels = var.labels_firewall_cloudflare

  dynamic "rule" {
    for_each = var.rules_firewall_cloudflare

    content {
      direction       = rule.value.direction
      protocol        = rule.value.protocol
      port            = rule.value.port
      source_ips      = rule.value.source_ips
      destination_ips = rule.value.destination_ips
      description     = rule.value.description
    }
  }

  dynamic "apply_to" {
    for_each = var.firewall_cloudflare_label_selector

    content {
      label_selector = apply_to.value.label_selector
      server         = apply_to.value.server
    }
  }
}
