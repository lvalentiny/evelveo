terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}
resource "libvirt_pool" "default" {
  name = "default"
  type = "dir"
  path = "/var/lib/libvirt/images/"
}

resource "libvirt_volume" "almalinux8-qcow2" {
  name = "centos8.qcow2"
  pool = "default"
  source = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2"
  format = "qcow2"
}

resource "libvirt_domain" "test1" {
  name = "homework"
  memory = "2048"
  vcpu = 2

  network_interface {
    network_name = "default"
  }

  disk {
    volume_id = "${libvirt_volume.almalinux8-qcow2.id}"
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }

}
