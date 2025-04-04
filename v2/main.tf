resource "openstack_compute_keypair_v2" "mykey" {
  provider   = openstack.ovh
  name       = "mykey"
  public_key = file("../credentials/id_ed25519.pub")
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

# setup router
resource "openstack_networking_router_v2" "myrouter" {
  name                = "myrouter"
  external_network_id = data.openstack_networking_network_v2.ext_net.id
}

resource "openstack_networking_router_interface_v2" "myrouter_interface" {
  router_id = openstack_networking_router_v2.myrouter.id
  subnet_id = openstack_networking_subnet_v2.myprivatenet.id
}

resource "openstack_compute_instance_v2" "bastion" {
   provider = openstack.ovh
   name = "bastion"
   flavor_name = "d2-2"
   image_name = "Ubuntu 24.04"
   key_pair = openstack_compute_keypair_v2.mykey.name
   network {
     name = "Ext-Net"
   }
   network {
     uuid = openstack_networking_network_v2.mynetwork.id
     fixed_ip_v4 = "10.0.0.10"
   }
}

resource "openstack_compute_instance_v2" "prometheus" {
   provider = openstack.ovh
   name = "prometheus"
   flavor_name = "d2-2"
   image_name = "Ubuntu 24.04"
   key_pair = openstack_compute_keypair_v2.mykey.name
   network {
     uuid = openstack_networking_network_v2.mynetwork.id
     fixed_ip_v4 = "10.0.0.20"
   }
}
