module "hetzner_cloud" {
  source = "./modules/hetzner-hcloud"

  # Variables for servers behind a Load balancer - start
  servers_behind_lb_count                = 2
  servers_behind_lb_name                 = "php-fpm"
  servers_behind_lb_image                = var.ubuntu_22_04
  servers_behind_lb_server_type          = var.cx11
  servers_behind_lb_location             = var.lb-location-nbg1-de # should be the same as in Load Balancer var.lb_location below
  servers_behind_lb_backups              = false
  servers_behind_lb_keep_disk            = true      # Keep the size of the disk if increasing a server size. It allows one to decrease back.
  servers_behind_lb_placement_group_name = "hosting" # Choose the desired name from previously created placement groups.
  servers_behind_lb_network_subnet_name  = "hosting" # Choose the desired name from previously created subnets. 
  servers_behind_lb_tz                   = "Europe/Kiev"
  servers_behind_lb_ipv4_enabled         = true
  servers_behind_lb_ipv6_enabled         = false
  servers_behind_lb_subnet_ip            = "10.10.1" # Use this format. The last number will calculate and add to the end of this IP address.
  servers_behind_lb_labels = {
    load_balancer_name     = "http-low" # Choose the desired name from previously created Load balancers. 
    firewall_ssh           = "yes"
    firewall_monitoring    = "yes"
    firewall_no_cloudflare = "yes"
  }
  # Variables for servers behind a Load balancer - end

  # Add Other Servers if needs
  servers_others = [
    {
      name                 = "redis"
      image                = var.ubuntu_22_04
      server_type          = var.cx11
      location             = var.lb-location-nbg1-de # should be the same as in Load Balancer var.lb_location below
      backups              = false
      keep_disk            = true      # Keep the size of the disk if increasing a server size. It allows one to decrease back.
      placement_group_name = "hosting" # Choose the desired name from previously created placement groups.
      network_subnet_name  = "hosting" # Choose the desired name from previously created subnets. 
      tz                   = "Europe/Kiev"
      ipv4_enabled         = true
      ipv6_enabled         = false
      ip                   = "10.10.0.100" # You might assign an IP address manually if you don't want to change the IP and recreate a server for each terraform apply. Look at the ip_range_network below.
      labels = {
        firewall_ssh        = "yes"
        firewall_monitoring = "yes"
      }
    },
    {
      name                 = "mysql"
      image                = var.ubuntu_22_04
      server_type          = var.cx11
      location             = var.lb-location-nbg1-de # should be the same as in Load Balancer var.lb_location below
      backups              = false
      keep_disk            = true      # Keep the size of the disk if increasing a server size. It allows one to decrease back.
      placement_group_name = "hosting" # Choose the desired name from previously created placement groups.
      network_subnet_name  = "hosting" # Choose the desired name from previously created subnets. 
      tz                   = "Europe/Kiev"
      ipv4_enabled         = true
      ipv6_enabled         = false
      ip                   = "10.10.0.101" # You might assign an IP address manually if you don't want to change the IP and recreate a server for each terraform apply. Look at the ip_range_network below.
      labels = {
        firewall_ssh        = "yes"
        firewall_monitoring = "yes"
      }
    }
  ]

  # Certificates
  certificates = [
    {
      name        = "jazzfest.link"
      certificate = null
      private_key = null
      domains = [
        "*.jazzfest.link",
        "jazzfest.link"
      ]
      labels = {
        "managed"    = "true"
        "managed_by" = "Terraform"
      }
    }
  ]

  # Firewall rules
  name_firewall_ssh           = "ssh"
  firewall_ssh_label_selector = [{ label_selector = "firewall_ssh=yes" }]
  labels_firewall_ssh         = { name = "ssh" }
  firewall_ssh = [
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "22"
      description = "SSH allow access from anywhere"
      source_ips  = ["0.0.0.0/0", "::/0"]
    },
    {
      direction   = "in"
      protocol    = "icmp"
      description = "Responce to ping from anywhere"
      source_ips  = ["0.0.0.0/0", "::/0"]
    },
  ]

  name_firewall_monitoring           = "monitoring"
  firewall_monitoring_label_selector = [{ label_selector = "firewall_monitoring=yes" }]
  labels_firewall_monitoring         = { name = "monitoring" }
  firewall_monitoring = [
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "9100"
      description = "Nodeexporter. Allow access for prometheus.domain.com"
      source_ips = [
        "127.0.0.1/32",
      ]
    },
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "9323"
      description = "Docker. Allow access for prometheus.domain.com"
      source_ips = [
        "127.0.0.1/32",
      ]
    },
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "9253"
      description = "php-fpm_exporter. Allow access for prometheus.domain.com"
      source_ips = [
        "127.0.0.1/32",
      ]
    },
  ]

  name_firewall_no_cloudflare           = "no-cloudflare"
  firewall_no_cloudflare_label_selector = [{ label_selector = "firewall_no_cloudflare=yes" }]
  labels_firewall_no_cloudflare         = { name = "no-cloudflare" }
  rules_firewall_no_cloudflare = [
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "80"
      description = "HTTP allow access from anywhere"
      source_ips  = ["0.0.0.0/0", "::/0"]
    },
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "443"
      description = "HTTPs allow access from anywhere"
      source_ips  = ["0.0.0.0/0", "::/0"]
    },
  ]

  name_firewall_cloudflare           = "cloudflare"
  firewall_cloudflare_label_selector = [{ label_selector = "firewall_with_cloudflare=yes" }]
  labels_firewall_cloudflare         = { name = "with-cloudflare" }
  rules_firewall_cloudflare = [
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "80"
      description = "HTTP allow access only from Cloudflare"
      source_ips = [
        "103.21.244.0/22",
        "103.22.200.0/22",
        "103.31.4.0/22",
        "104.16.0.0/13",
        "104.24.0.0/14",
        "108.162.192.0/18",
        "131.0.72.0/22",
        "141.101.64.0/18",
        "162.158.0.0/15",
        "172.64.0.0/13",
        "173.245.48.0/20",
        "188.114.96.0/20",
        "190.93.240.0/20",
        "197.234.240.0/22",
        "198.41.128.0/17",
        "2400:cb00::/32",
        "2405:8100::/32",
        "2405:b500::/32",
        "2606:4700::/32",
        "2803:f800::/32",
        "2a06:98c0::/29",
        "2c0f:f248::/32",
      ]
    },
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "443"
      description = "HTTPs allow access only from Cloudflare"
      source_ips = [
        "103.21.244.0/22",
        "103.22.200.0/22",
        "103.31.4.0/22",
        "104.16.0.0/13",
        "104.24.0.0/14",
        "108.162.192.0/18",
        "131.0.72.0/22",
        "141.101.64.0/18",
        "162.158.0.0/15",
        "172.64.0.0/13",
        "173.245.48.0/20",
        "188.114.96.0/20",
        "190.93.240.0/20",
        "197.234.240.0/22",
        "198.41.128.0/17",
        "2400:cb00::/32",
        "2405:8100::/32",
        "2405:b500::/32",
        "2606:4700::/32",
        "2803:f800::/32",
        "2a06:98c0::/29",
        "2c0f:f248::/32",
      ]
    }
  ]

  # LB
  lb_name            = "http-low"
  load_balancer_type = var.lb11
  lb_location        = var.lb-location-nbg1-de
  algorithm_type     = "round_robin"
  network_for_lb     = "hosting" # A subnet name that should connect to this LB
  lb_labels = {
    type       = "http",
    managed_by = "Terraform"
  }

  # Networks and subnets
  networks = [
    {
      name                     = "hosting"
      ip_range_network         = "10.10.0.0/16"
      network_type             = "cloud"
      network_zone             = "eu-central"
      delete_protection        = false
      ip_range_subnet          = "10.10.0.0/16" # cidrsubnet doesn't use because network will be recreated destroy/create
      expose_routes_to_vswitch = false
      #   vswitch_id = ""
      labels = {
        purpose = "hosting",
        type    = "clients",
      }
    },
    {
      name                     = "kubernetes"
      ip_range_network         = "10.20.0.0/16"
      network_type             = "cloud"
      network_zone             = "us-east"
      delete_protection        = false
      ip_range_subnet          = "10.20.0.0/16" # cidrsubnet doesn't use because network will be recreated destroy/create
      expose_routes_to_vswitch = false
      #   vswitch_id = ""
      labels = {
        purpose = "kubernetes",
        type    = "clients",
      }
    }
  ]

  placement_group = {
    infrastructure = {
      type = "spread"
      labels = {
        purpose = "monitoring",
        type    = "prometheus",
      }
    }
    hosting = {
      type = "spread"
      labels = {
        purpose = "hosting",
        type    = "clients",
      }
    }
    kubernetes = {
      type = "spread"
      labels = {
        purpose = "kubernetes",
        type    = "clients",
      }
    }
  }
}
