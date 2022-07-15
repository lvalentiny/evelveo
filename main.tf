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

resource "libvirt_cloudinit_disk" "commoninit" {
  name = "commoninit.iso"
  user_data = "${data.template_file.user_data.rendered}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/cloud_init.cfg")}"
}

resource "libvirt_domain" "homework" {
  name = "homework"
  memory = "2048"
  vcpu = 2

  provisioner "local-exec" {
    command = <<EOT
      pip3 install oschmod
      #oschmod 700 .ssh
      #oschmod 400 .ssh/id_rsa
      #oschmod 600 .ssh/id_rsa.pub
      oschmod 755 setup.py
      pip3 install -r requirements.txt
      python3 setup.py
      EOT
  }

  cloudinit = "${libvirt_cloudinit_disk.commoninit.id}"

  network_interface {
    network_name = "default"
    wait_for_lease = true
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

output "ip_addr" {
  value = libvirt_domain.homework.*.network_interface.0.addresses
}
