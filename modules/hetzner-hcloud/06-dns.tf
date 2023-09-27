resource "hetznerdns_zone" "jazzfest" {
  name = "jazzfest.link"
  ttl  = 3600
}

# resource "hetznerdns_record" "www" {
#   zone_id = hetznerdns_zone.jazzfest.id
#   name    = "www"
#   value   = "192.168.1.1"
#   type    = "A"
#   ttl     = 60
# }

# resource "hetznerdns_record" "at" {
#   zone_id = hetznerdns_zone.jazzfest.id
#   name    = "@"
#   value   = "192.168.1.1"
#   type    = "A"
#   ttl     = 60
# }