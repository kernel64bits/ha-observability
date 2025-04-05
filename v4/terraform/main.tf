resource "openstack_compute_keypair_v2" "mykey" {
  provider   = openstack.ovh
  name       = "mykey"
  public_key = file("../../credentials/id_ed25519.pub")
}

data "openstack_networking_network_v2" "ext_net" {
  name = "Ext-Net"
}

resource "openstack_networking_network_v2" "mynetwork" {
  name           = "mynetwork"
}

resource "openstack_networking_subnet_v2" "myprivatenet" {
  name       = "myprivatenet"
  network_id = openstack_networking_network_v2.mynetwork.id
  cidr       = "10.0.0.0/24"
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "openstack_networking_router_v2" "myrouter" {
  name                = "myrouter"
  external_network_id = data.openstack_networking_network_v2.ext_net.id
}

resource "openstack_networking_router_interface_v2" "myrouter_interface" {
  router_id = openstack_networking_router_v2.myrouter.id
  subnet_id = openstack_networking_subnet_v2.myprivatenet.id
}

resource "openstack_networking_secgroup_v2" "openbar" {
  name        = "openbar"
  description = "Allow all traffic"
}

resource "openstack_networking_secgroup_rule_v2" "allow_all_ingress_ipv4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.openbar.id
  protocol          = null
}

resource "openstack_networking_secgroup_rule_v2" "allow_all_ingress_ipv6" {
  direction         = "ingress"
  ethertype         = "IPv6"
  security_group_id = openstack_networking_secgroup_v2.openbar.id
  protocol          = null
}

resource "openstack_compute_instance_v2" "bastion" {
   provider = openstack.ovh
   name = "bastion"
   flavor_name = "c2-7"
   image_name = "Ubuntu 24.04"
   key_pair = openstack_compute_keypair_v2.mykey.name
   security_groups = [openstack_networking_secgroup_v2.openbar.name]
   network {
     name = "Ext-Net"
   }
   network {
     uuid = openstack_networking_network_v2.mynetwork.id
     fixed_ip_v4 = "10.0.0.10"
   }
}

resource "openstack_compute_instance_v2" "prometheus1" {
   provider = openstack.ovh
   name = "prometheus1"
   flavor_name = "c2-7"
   image_name = "Ubuntu 24.04"
   key_pair = openstack_compute_keypair_v2.mykey.name
   security_groups = [openstack_networking_secgroup_v2.openbar.name]
   network {
     uuid = openstack_networking_network_v2.mynetwork.id
     fixed_ip_v4 = "10.0.0.20"
   }
}

resource "openstack_compute_instance_v2" "prometheus2" {
   provider = openstack.ovh
   name = "prometheus2"
   flavor_name = "c2-7"
   image_name = "Ubuntu 24.04"
   key_pair = openstack_compute_keypair_v2.mykey.name
   security_groups = [openstack_networking_secgroup_v2.openbar.name]
   network {
     uuid = openstack_networking_network_v2.mynetwork.id
     fixed_ip_v4 = "10.0.0.21"
   }
}

resource "openstack_blockstorage_volume_v3" "prometheus1-storage" {
  name        = "prometheus-storage"
  size        = 10 
  volume_type = "high-speed"
}

resource "openstack_compute_volume_attach_v2" "prometheus_attachment1" {
  instance_id = openstack_compute_instance_v2.prometheus1.id
  volume_id   = openstack_blockstorage_volume_v3.prometheus1-storage.id
}

resource "openstack_blockstorage_volume_v3" "prometheus2-storage" {
  name        = "prometheus-storage"
  size        = 10 
  volume_type = "high-speed"
}


resource "openstack_compute_volume_attach_v2" "prometheus_attachment2" {
  instance_id = openstack_compute_instance_v2.prometheus2.id
  volume_id   = openstack_blockstorage_volume_v3.prometheus2-storage.id
}