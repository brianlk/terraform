terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_network" "nginx" {
  name   = "docknet"
  driver = "bridge"
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
  depends_on = []
}

#  git clone https://github.com/acemilyalcin/sample-node-project.git
## build from Dockerfile
resource "docker_image" "nodejs" {
  name = "sample-node-project"
  build {
    context = "./sample-node-project"
    tag = ["sample-node-project:latest"]
  }
  depends_on = [null_resource.configmap]
}

# Run the container in network docknet
resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name = "xxx"
  ports {
    internal = 80
    external = 8000
  }
  networks_advanced {
    name    = docker_network.nginx.name
    aliases = ["docknet"]
  }
}

# Run the container in network docknet
resource "docker_container" "nodejs" {
  image = docker_image.nodejs.name
  name = "yyy"
  ports {
    internal = 3005
    external = 3005
  }
  networks_advanced {
    name    = docker_network.nginx.name
    aliases = ["docknet"]
  }
}
