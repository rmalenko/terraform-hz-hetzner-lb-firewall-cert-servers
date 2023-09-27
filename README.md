# terraform.io
This module uses service app.terraform.io to store terraform.tfstate. It's might free for your requirements.
![Hetzner cloud](https://raw.githubusercontent.com/rmalenko/terraform-hz-hetzner-lb-firewall-cert-servers/main/documents/hetzner_cloud.drawio.png)

You must have an account and prepare the environment running the command `terraform login`. This will create a file in your home directory `~/.terraform.d/credentials.tfrc.json`

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "vx1......g"
    }
  }
}
```

Also, you may comment all in file `02-backend.tf` to stop using terraform.io

# Hetzner

## Cloud

If this is your first time doing it, log in to <https://console.hetzner.cloud/> and create a project. Go to the newly created project. On the left side, click security, add the SSH public key, and create an API token.
Put the token into `terraform.tfvars`

Also, additional keys will be created and stored in folder `./keys` and added to the Hetzner project created before.

![Hetzner API key](https://raw.githubusercontent.com/rmalenko/terraform-hz-hetzner-lb-firewall-cert-servers/main/documents/API_tokens_Hetzner_Cloud.png)

## DNS

If you are going to use Hetzner DNS service, which allows you to use Letsencrypt with automatic renewal by Hetzner, then you need to create a DNS API key and put it to `terraform.tfvars`

![Hetzner DNS](https://raw.githubusercontent.com/rmalenko/terraform-hz-hetzner-lb-firewall-cert-servers/main/documents/API_tokens_Hetzner_DNS.png)

## `terraform.tfvars`
```hcl
hcloud_token     = "2...gym"
htzner_dns_token = "c...4Vz"

```

## Hetzner Load Balancer, basic network, placement group and firewall

For example, file `03-servers.tf`

- variables `servers_behind_lb_*` used to create many identical servers behind the Load Balancer. For example, PHP-FPM servers. `servers_behind_lb_count = 2` creates two servers with names `php-fpm-001` and `php-fpm-002`

- variable `servers_others` you can add servers as many as you wish. Each of the others can have their name, size, and tags.

Hetzner allows use labels to attach servers to Load Balancer and/or firewalls.

In the example below, all servers with the label `load_balancer_name = "http-low"` will attach to the Load balancer with the name `http-low`. Also, we created four firewalls, but only `firewall_ssh`, `firewall_monitoring`, and `firewall_no_cloudflare` will be attached to a server with these labels.

```hcl
servers_behind_lb_labels = {
    load_balancer_name     = "http-low" # Choose the desired name from previously created Load balancers. 
    firewall_ssh           = "yes"
    firewall_monitoring    = "yes"
    firewall_no_cloudflare = "yes"
  }
```

In this case only two firewalls will be attached to a server with these labels.

```hcl
labels = {
        firewall_ssh        = "yes"
        firewall_monitoring = "yes"
  }
```

As long as we have a private subnet, we can assign an IP address automatically. However, each run of `terraform apply` can change the IP addresses and recreate a server. To avoid this behavior, I use the possibility to add IP addresses `servers_behind_lb_subnet_ip = "10.10.1"` for servers behind the LB. In this case, the last number will be calculated and added to the end of this IP address.

For other servers `servers_others.ip = "10.10.0.100"`  look at the `ip_range_network` below in `Networks and subnets` configuration.

## Certificates

Just provide domain names for certificates.

## Firewall rules

Names:

- `ssh` - allow access and response to ping from anywhere
- `monitoring` - allows access from prometheus.domain.com
- `no-cloudflare` - allows 80 and 443 ports from anywhere
- `cloudflare` - allows 80 and 443 ports only from the Cloudflare service

## Networks and subnets

In the example, two networks with subnets. You may add more.
