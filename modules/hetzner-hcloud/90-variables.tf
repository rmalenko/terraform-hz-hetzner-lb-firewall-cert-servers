variable "placement_group" {
  description = "Placement group configurations"
  type = map(object({
    type   = string
    labels = map(string)
  }))
}


# SSH - start
variable "name_firewall_ssh" {
  type        = string
  default     = "cloudflare"
  description = "Name of the Firewall"
}

variable "labels_firewall_ssh" {
  type = map(string)
  default = {
    name = "cloudflare"
  }
  description = "User-defined labels (key-value pairs) should be created with for Cloudflare firewall SSH"
}

variable "firewall_ssh_label_selector" {
  type = list(object({
    label_selector = optional(string)
    server         = optional(number)
  }))
  default = [{
    label_selector = "name=ssh"
  }]
  description = "User-defined labels (key-value pairs) should be created with"
}

variable "firewall_ssh" {
  type = list(object({
    direction       = string
    protocol        = string
    port            = optional(string)
    source_ips      = optional(list(string))
    destination_ips = optional(list(string))
    description     = optional(string)
  }))
  description = "Configuration of a rule SSH"
}
# SSH - end

# Firewal Base_monitoring - start
variable "name_firewall_monitoring" {
  type        = string
  default     = "base-monitoring"
  description = "Name of the Firewall"
}

variable "labels_firewall_monitoring" {
  type = map(string)
  default = {
    name = "base-monitoring"
  }
  description = "User-defined labels (key-value pairs) should be created with for Monitoring firewall"
}

variable "firewall_monitoring" {
  type = list(object({
    direction       = string
    protocol        = string
    port            = optional(string)
    description     = optional(string)
    source_ips      = optional(list(string))
    destination_ips = optional(list(string))
  }))
  description = "Configuration of a Rule for monitoring Firewall"
}

variable "firewall_monitoring_label_selector" {
  type = list(object({
    label_selector = optional(string)
    server         = optional(number)
  }))
  default = [{
    label_selector = "name=base-monitoring"
  }]
  description = "Resources the firewall should be assigned to"
}
# Firewal Base_monitoring - end

# Firewal no_cloudflare - start
variable "name_firewall_no_cloudflare" {
  type        = string
  default     = "no-cloudflare"
  description = "Name of the Firewall"
}

variable "labels_firewall_no_cloudflare" {
  type = map(string)
  default = {
    name = "no-cloudflare"
  }
  description = "User-defined labels (key-value pairs) should be created with for no-Cloudflare firewall HTTP/HTTPs"
}

variable "firewall_no_cloudflare_label_selector" {
  type = list(object({
    label_selector = optional(string)
    server         = optional(number)
  }))
  default = [{
    label_selector = "name=no-cloudflare"
  }]
  description = "User-defined labels (key-value pairs) should be created with"
}

variable "rules_firewall_no_cloudflare" {
  type = list(object({
    direction       = string
    protocol        = string
    port            = optional(string)
    description     = optional(string)
    source_ips      = optional(list(string))
    destination_ips = optional(list(string))
  }))
  description = "Configuration of a rule HTTP/HTTP no cloudflare"
}
# Frewall no-cloudflare - end

# Firewal cloudflare - start
variable "name_firewall_cloudflare" {
  type        = string
  default     = "cloudflare"
  description = "Name of the Firewall"
}

variable "labels_firewall_cloudflare" {
  type = map(string)
  default = {
    name = "cloudflare"
  }
  description = "User-defined labels (key-value pairs) should be created with for Cloudflare firewall HTTP/HTTPs"
}

variable "firewall_cloudflare_label_selector" {
  type = list(object({
    label_selector = optional(string)
    server         = optional(number)
  }))
  default = [{
    label_selector = "name=cloudflare"
  }]
  description = "User-defined labels (key-value pairs) should be created with"
}

variable "rules_firewall_cloudflare" {
  type = list(object({
    direction       = string
    protocol        = string
    port            = optional(string)
    source_ips      = optional(list(string))
    destination_ips = optional(list(string))
    description     = optional(string)
  }))
  description = "Configuration of a rule HTTP/HTTP no cloudflare"
}
# Frewall cloudflare - end

variable "networks" {
  description = "Network configuration for hosting"
  type = list(object({
    name                     = string
    ip_range_network         = string
    network_type             = string
    network_zone             = string
    delete_protection        = bool
    ip_range_subnet          = string
    expose_routes_to_vswitch = bool
    vswitch_id               = optional(string)
    labels                   = map(string)
  }))
}

variable "servers_others" {
  description = "Server configurations"
  type = list(object({
    name                 = string
    image                = string
    server_type          = string
    location             = string
    backups              = bool
    keep_disk            = bool
    placement_group_name = string
    network_subnet_name  = string
    labels               = map(string)
    ipv4_enabled         = bool
    ipv6_enabled         = bool
    ip                   = string
  }))
}

variable "servers_behind_lb_count" { type = number }
variable "servers_behind_lb_name" { type = string }
variable "servers_behind_lb_image" { type = string }
variable "servers_behind_lb_server_type" { type = string }
variable "servers_behind_lb_location" { type = string }
variable "servers_behind_lb_backups" { type = bool }
variable "servers_behind_lb_keep_disk" { type = bool }
variable "servers_behind_lb_placement_group_name" { type = string }
variable "servers_behind_lb_network_subnet_name" { type = string }
variable "servers_behind_lb_tz" { type = string }
variable "servers_behind_lb_ipv4_enabled" { type = bool }
variable "servers_behind_lb_ipv6_enabled" { type = bool }
variable "servers_behind_lb_subnet_ip" { type = string }
variable "servers_behind_lb_labels" { type = map(string) }

variable "tz" {
  type        = string
  default     = "Europe/Kiev"
  description = "Server timezone"
}


variable "lb_name" {
  description = "Load balancer name"
  type        = string
  default     = "http-low"
}

variable "network_for_lb" {
  description = "Network for Load balancer"
  type        = string
  default     = "hosting"
}


variable "load_balancer_type" {
  description = "Load balancer type"
  type        = string
}

variable "lb_location" {
  description = "Load balancer location"
  type        = string
}

variable "algorithm_type" {
  description = "Load balancer algorithm type"
  type        = string
  default     = "round_robin"
}

variable "lb_labels" {
  description = "Load balancer labels"
  type        = map(string)
  default = {
    type       = "http",
    managed_by = "Terraform"
  }
}


variable "certificates" {
  description = "The list of certificate objects to be managed. Each certificate object supports the following parameters: 'name' (string, required), 'certificate' (string, required if imported), 'private_key' (string, required if imported), 'domains' (list of domain names, required if managed), 'labels' (map of KV pairs, optional)."
  type = list(
    object({
      name        = string
      certificate = string
      private_key = string
      domains     = list(string)
      labels      = map(string)
    })
  )
}