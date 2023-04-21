resource "cloudflare_record" "any_record_a" {
  zone_id = cloudflare_zone.domain_zone.id
  name    = "your-record-name"
  value   = "your-ipv4-address"
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "any_record_aaaa" {
  zone_id = cloudflare_zone.domain_zone.id
  name    = "your-record-name"
  value   = "some_ip_v6_address"
  type    = "AAAA"
  proxied = false
}