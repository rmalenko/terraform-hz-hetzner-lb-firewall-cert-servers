variable "hcloud_token" {
  type        = string
  description = "Hetzner API token"
  sensitive   = true
}

variable "htzner_dns_token" {
  type        = string
  description = "Hetzner DNS token"
  sensitive   = true
}

variable "count_of_servers_behind_lb" {
  description = "Number of servers behind a LB"
  type        = number
  default     = 3
}

# Network start
# variable "networks" {
#   description = "The list of networks to be managed, with each list element being a tuple of (name/ip_range/subnet_bits)."
#   type        = list(tuple([string, string, number]))
#   default = [
#     ["kubernetes", "10.20.0.0/8", 1],
#     ["lb-internal", "10.10.0.0/8", 8]
#   ]

#   validation {
#     condition = can([
#       for network in var.networks : regex("\\w+", network[0])
#     ])
#     error_message = "All networks must have a valid name specified."
#   }

#   validation {
#     condition = can([
#       for network in var.networks : regex("[[:xdigit:]]+", network[1])
#     ])
#     error_message = "All networks must have a valid ip_range specified."
#   }

#   validation {
#     condition = can([
#       for network in var.networks : regex("[[:digit:]]+", network[2])
#     ])
#     error_message = "All networks must have valid subnet_bits specified."
#   }
# }

variable "subnet_start" {
  description = "Which subnet offset to start at."
  type        = number
  default     = 1
}

variable "subnet_count" {
  description = "The number of subnets to create."
  type        = number
  default     = 1
}

variable "labels" {
  description = "The map of labels to be assigned to all managed resources."
  type        = map(string)
  default = {
    "managed"    = "true"
    "managed_by" = "Terraform"
  }
}
# Network end

# LB and Datacenter - start
variable "dc-nuremberg-de" {
  type        = string
  default     = "nbg1-dc3"
  description = "Nuremberg 1 virtual DC 3, DE"
}

variable "dc-helsinki-fi" {
  type        = string
  default     = "hel1-dc2"
  description = "Helsinki 1 virtual DC 2, FI"
}

variable "dc-falkenstein-de" {
  type        = string
  default     = "fsn1-dc14"
  description = "Falkenstein 1 virtual DC 14, DE"
}

variable "dc-ashburn-us" {
  type        = string
  default     = "ash-dc1"
  description = "Ashburn DC1, Ashburn, VA, us-east, US"
}

variable "dc-hillsboro-us" {
  type        = string
  default     = "hil-dc1"
  description = "Hillsboro virtual DC 1, us-west, US"
}

variable "lb11" {
  type        = string
  default     = "lb11"
  description = "Low performance. €5.39 / mo"
}

variable "lb21" {
  type        = string
  default     = "lb21"
  description = "Medium performance. €16.40 / mo"
}

variable "lb31" {
  type        = string
  default     = "lb31"
  description = "High performance. €32.90 / mo"
}

variable "lb-location-hel1-fi" {
  type        = string
  default     = "hel1"
  description = "Helsinki 1 virtual DC 2, FI"
}

variable "lb-location-ash-us" {
  type        = string
  default     = "ash"
  description = "Ashburn virtual DC 1, US"
}

variable "lb-location-nbg1-de" {
  type        = string
  default     = "nbg1"
  description = "Nuremberg DC Park 1, DE"
}

variable "lb-location-hil-us" {
  type        = string
  default     = "hil"
  description = "Hillsboro, OR, US"
}

variable "lb-location-fsn1-de" {
  type        = string
  default     = "fsn1"
  description = "Falkenstein DC Park 1, DE"
}
# LB and Datacenter - end

# Image - start
# curl -H "Authorization: Bearer 2I...ym" 'https://api.hetzner.cloud/v1/images'
variable "ubuntu_22_04" {
  type        = string
  default     = "ubuntu-22.04"
  description = "Ubuntu 22.04"
}

variable "debian-11" {
  type        = string
  default     = "debian-11"
  description = "Debian 11"
}

variable "centos-stream-9" {
  type        = string
  default     = "centos-stream-9"
  description = "CentOS Stream 9"
}

# Image - end

# Servers - start
# curl -H "Authorization: Bearer 2I...ym" 'https://api.hetzner.cloud/v1/server_types'
variable "cx11" {
  type        = string
  default     = "cx11"
  description = "cores: 1 memory: 2.0, disk: 20, price_monthly: 3.29"
}

variable "cx21" {
  type        = string
  default     = "cx21"
  description = "cores: 2 memory: 4.0, disk: 40, price_monthly: 4.85"
}

variable "cx31" {
  type        = string
  default     = "cx31"
  description = "cores: 2 memory: 8.0, disk: 80, price_monthly: 9.2"
}

variable "cx41" {
  type        = string
  default     = "cx41"
  description = "cores: 4 memory: 16, disk: 160, price_monthly: 16.9"
}

variable "cx51" {
  type        = string
  default     = "cx51"
  description = "cores: 8 memory: 32, disk: 240, price_monthly: 32.4"
}

variable "cpx11" {
  type        = string
  default     = "cpx11"
  description = "cores: 2 memory: 2, disk: 40, price_monthly: 3.85"
}

variable "cpx21" {
  type        = string
  default     = "cpx21"
  description = "cores: 3 memory: 4, disk: 80, price_monthly: 7.05"
}

variable "cpx31" {
  type        = string
  default     = "cpx31"
  description = "cores: 4 memory: 8, disk: 160, price_monthly: 13.1"
}

variable "cpx41" {
  type        = string
  default     = "cpx41"
  description = "cores: 8 memory: 16, disk: 240, price_monthly: 24.7"
}

variable "cpx51" {
  type        = string
  default     = "cpx51"
  description = "cores: 16 memory: 32, disk: 360, price_monthly: 54.4"
}

variable "ccx12" {
  type        = string
  default     = "ccx12"
  description = "CCX12 Dedicated CPU. cores: 16 memory: 32, disk: 360, price_monthly: 54.4"
}

variable "ccx22" {
  type        = string
  default     = "ccx22"
  description = "CCX22 Dedicated CPU. cores: 4 memory: 16, disk: 160, price_monthly: 37.9"
}

variable "ccx32" {
  type        = string
  default     = "ccx32"
  description = "ccx32 Dedicated CPU. cores: 8 memory: 32, disk: 240, price_monthly: 76.4"
}

variable "ccx42" {
  type        = string
  default     = "ccx42"
  description = "ccx42 Dedicated CPU. cores: 16 memory: 64, disk: 360, price_monthly: 153.4"
}

# Servers - end