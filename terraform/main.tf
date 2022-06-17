terraform {
	required_providers {
		docker = {
			source  = "kreuzwerker/docker"
			version = "~> 2.16.0"
		}
	}
}

provider "docker" {
	host = "unix:///var/run/docker.sock"
}

resource "null_resource" "create_volumes_folder" {
	provisioner "local-exec" {
		command = <<EOT
			mkdir -vp $(pwd)/data/docker;
			mkdir -vp $(pwd)/data/alma;
			sleep 3;
		EOT
	}
}

resource "docker_network" "dind_alma_net" {
	name = "dind_alma_network"
	driver = "bridge"
	ipam_config {
		subnet = "10.10.100.0/29"
		gateway = "10.10.100.6"
	}
}

resource "docker_volume" "dind_docker_vol" {
	name = "docker_alma_volume"
	driver = "local"
	driver_opts = {
		"type"   = "none"
		"device" = "${abspath(path.module)}/data/docker"
		"o"      = "bind"
	}
}

resource "docker_volume" "dind_alma_vol" {
	name = "alma_dind_volume"
	driver = "local"
	driver_opts = {
		"type"   = "none"
		"device" = "${abspath(path.module)}/data/alma"
		"o"      = "bind"
	}
}

data "docker_registry_image" "dind_image_almalinux" {
	name = "ghcr.io/manprint/almalinux-dind:8.6-terraform"
}

resource "docker_image" "dind_almalinux_image" {
	name = data.docker_registry_image.dind_image_almalinux.name
	pull_triggers = [data.docker_registry_image.dind_image_almalinux.sha256_digest]
	keep_locally = true
}

resource "docker_container" "dind_almalinux_container" {
	depends_on = [ null_resource.create_volumes_folder ]
	image = data.docker_registry_image.dind_image_almalinux.name
	name  = "almalinux_dind"
	hostname = "almalinux.local"
	restart = "no"
	privileged = true
	volumes {
		volume_name = docker_volume.dind_docker_vol.name
		container_path  = "/var/lib/docker"
	}
	volumes {
		volume_name = docker_volume.dind_alma_vol.name
		container_path  = "/home/alma"
	}
	volumes {
		host_path = "/sys/fs/cgroup"
		container_path  = "/sys/fs/cgroup"
	}
	ports {
		internal = 2375
		external = 2375
		protocol = "tcp"
	}
	networks_advanced {
		name = docker_network.dind_alma_net.name
		ipv4_address = "10.10.100.1"
	}
}