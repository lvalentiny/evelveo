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
  count= "${resource.libvirt_pool.default != "null" ? 0 : 1}"
  name = "default"
  type = "dir"
  path = "/var/lib/libvirt/images/"
}

resource "libvirt_network" "default" {
  count= "${resource.libvirt_network.default != "null" ? 0 : 1}"
  name = "default"
  mode      = "nat"
  domain    = "homework"
  addresses = ["192.168.122.0/24"]
  dhcp {
    enabled = true
  }
}

resource "libvirt_volume" "centos8-qcow2" {
  name = "centos8.qcow2"
  pool = "default"
  source = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2"
  format = "qcow2"
}

# get user data info
data "template_file" "user_data" {
  template = "${file("${path.module}/cloud_init.cfg")}"
}

# Use CloudInit to add the instance
resource "libvirt_cloudinit_disk" "commoninit" {
  count = "${resource.libvirt_cloudinit_disk.commoninit != "null" ? 0 : 1}"
  name = "commoninit.iso"
  pool = "default" # List storage pools using virsh pool-list
  user_data      = "${data.template_file.user_data.rendered}"
}

resource "libvirt_domain" "homework" {
  name = "homework"
  memory = "2048"
  vcpu = 2

  network_interface {
    network_name = "default"
  }


  disk {
    volume_id = "${libvirt_volume.centos8-qcow2.id}"
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