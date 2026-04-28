output "app_node_name" {
  value = docker_container.app_server.name 
}

output "monitor_node_name" {
  value = docker_container.monitor_node.name 
}