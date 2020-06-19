resource "openstack_networking_secgroup_v2" "sg-ssh-pmalatin" {
  name                 = "sg-ssh-pmalatin"
  description          = "SSH"
  delete_default_rules = true
}