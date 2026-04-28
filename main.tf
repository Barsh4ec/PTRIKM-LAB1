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
  image = docker_image.ubuntu_ssh.image_id
  
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  ports {
    internal = 80
    external = 8082
  }
  ports {
    internal = 22
    external = 2222
  }
}

output "container_ip" {
  value = "localhost"
}