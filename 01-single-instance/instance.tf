# nasa security groupa, vytvorena v 00-tenant-base
data "openstack_networking_secgroup_v2" "sg-ssh-pmalatin" {
  name = "sg-ssh-pmalatin"
}

# toto je defaultna sg group, ktora je uz na OTC buildnuta aj bez tej nasej novej
data "openstack_networking_secgroup_v2" "sg-AgileAcademyTelIT-default" {
  name = "sg-AgileAcademyTelIT-default"
}

data "openstack_compute_keypair_v2" "pmalatin-keypair" {
  name = "pmalatin-keypair"
}

resource "openstack_blockstorage_volume_v2" "data0" {
  name = "data0"
  size = 4
}

resource "openstack_networking_port_v2" "primary_port" {
  network_id = local.network_id
#  network_id = "9e322103-7a52-4e15-b667-2ea8e2ca41ce" - taha z locals.tf
  security_group_ids = [
    data.openstack_networking_secgroup_v2.sg-ssh-pmalatin.id,
    data.openstack_networking_secgroup_v2.sg-AgileAcademyTelIT-default.id,
  ]
  admin_state_up = "true"
  fixed_ip {
    subnet_id = local.subnet_id
#    subnet_id  = "45463fd3-7491-4dcc-9040-b5ce6602da09" - taha z locals.tf
    ip_address = local.ip_address
#    ip_address = "10.14.253.52" - taha z locals.tf
  }
}

resource "openstack_compute_instance_v2" "pmalatin-vm" {
  name        = "pmalatin-vm"
  image_name  = "Standard_CentOS_7_latest"
  flavor_name = "s2.medium.1"
  key_pair    = data.openstack_compute_keypair_v2.pmalatin-keypair.name
  user_data   = file("mount_vm.sh")
# Nieco ako after script, mozeme nechat spustit script (see up) alebo zadefinujem user data EOF (see down)
#  user_data = <<EOF
#! /bin/bash
#systemctl stop firewalld
#touch test /mnt/data
#EOF

  network {
    port = openstack_networking_port_v2.primary_port.id
  }
}

resource "openstack_compute_volume_attach_v2" "data0" {
  instance_id = openstack_compute_instance_v2.pmalatin-vm.id
  volume_id   = openstack_blockstorage_volume_v2.data0.id
}

output "binding" {
  value = openstack_networking_port_v2.primary_port.binding
}

output "mac_address" {
  value = openstack_compute_instance_v2.pmalatin-vm.network[0].mac
}
