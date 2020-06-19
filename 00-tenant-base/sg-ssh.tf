resource "openstack_networking_secgroup_rule_v2" "allow_ssh_pmalatin" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "10.0.0.0/8"
  security_group_id = openstack_networking_secgroup_v2.sg-ssh-pmalatin.id
}

resource "openstack_networking_secgroup_rule_v2" "outbound_ssh_pmalatin" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg-ssh-pmalatin.id
}