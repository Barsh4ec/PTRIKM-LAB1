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

resource "docker_network" "lab8_net" {
  name = "lab8-network"
}

resource "docker_container" "app_server" {
  name  = "web-app-local"
  image = docker_image.ubuntu_ssh.image_id

  networks_advanced {
    name = docker_network.lab8_net.name
  }
  
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  ports { 
    internal = 80
    external = 8082
  } # App

  ports {
    internal = 22
    external = 2223
  } # SSH communication port
}

resource "docker_container" "monitor_node" {
  name  = "monitor_node"
  image = docker_image.ubuntu_ssh.image_id
  networks_advanced {
    name = docker_network.lab8_net.name
  }

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  ports {
  internal = 22
  external = 2224
  } # SSH communication port
}
//test