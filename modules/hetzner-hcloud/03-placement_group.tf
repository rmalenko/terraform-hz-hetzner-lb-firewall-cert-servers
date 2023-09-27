resource "hcloud_placement_group" "hosting" {
  for_each = var.placement_group
  name     = each.key
  type     = each.value.type
  labels   = each.value.labels
}
