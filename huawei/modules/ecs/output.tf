output "ecs_ids" {
  value = huaweicloud_compute_instance.main[*].id
}

output "ecs_ips" {
  value = huaweicloud_compute_instance.main[*].access_ip_v4
}
