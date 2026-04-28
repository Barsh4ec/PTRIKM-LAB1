terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "ubuntu_ssh" {
  name = "rastasheep/ubuntu-sshd"
}

resource "docker_container" "app_server" {
  name  = "web-app-local"
  image = docker_image.node_base.image_id
  
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  ports { 
    internal = 80
    external = 8082
  } # App
  
  ports {
    internal = 9100
    external = 9100
  } # Node Exporter

  ports {
  internal = 22
  external = 2223
  } # SSH communication port
}

resource "docker_container" "monitor_node" {
  name  = "monitor_node"
  image = docker_image.node_base.image_id

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }
  ports { 
    internal = 9090
    external = 9090
  } # Prometheus

  ports {
    internal = 3000
    external = 3000
  } # Grafana

  ports {
  internal = 22
  external = 2224
  } # SSH communication port
}

output "app_node_name" { value = web-app-local }
output "monitor_node_name" { value = docker_container.monitor_node.name }