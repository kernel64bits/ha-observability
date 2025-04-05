 # Version 1
 
 ## Introduction
 Setup basic infrastructure wit 2 servers:
 - Bastion
 - Prometheus server fetching its own metrics

 # Setup
 ## List resources
```bash
openstack flavor list
openstack network list # list network
openstack image list # On va prendre c3d02215-1b96-41b9-9854-4244f9c32c7b (ubuntu 24)
```

## Network
```bash
# setup keypair
openstack keypair create --public-key ~/.ssh/id_ed25519.pub mykey

# Setup network
```bash
openstack network create mynetwork # get network ID
openstack subnet create myprivatenet --network 42bd2edf-99bc-4616-bd54-e87b2329893b --subnet-range 10.0.0.0/24

# Setup router
openstack router create myrouter
openstack router add subnet myrouter myprivatenet
openstack router set --external-gateway Ext-Net myrouter
```

## Bastion

### Create server
```bash
openstack server create --flavor d2-2 --image c3d02215-1b96-41b9-9854-4244f9c32c7b --key-name mykey --network Ext-Net --network mynetwork bastion # a ameliorer pour pouvoir choisir les adresses IP
openstack server list # list existing server, get ip address
```

### Other setup
```bash
# Setup SOCKS proxy
ssh -D 1337 -q -C -N ubuntu@147.135.140.128
#https://ma.ttias.be/socks-proxy-linux-ssh-bypass-content-filters/
```

## Setup Prometheus
### Create server
```bash
openstack server create --flavor d2-2 --image c3d02215-1b96-41b9-9854-4244f9c32c7b --key-name mykey --network mynetwork promgraf
```

### Configure the server
```bash
ssh -J ubuntu@91.134.30.33 ubuntu@10.0.0.164 # ssh using the bastion

# Setup DNS
echo "DNS=8.8.8.8" >> /etc/systemd/resolved.conf; systemctl restart systemd-resolved

## Setup node exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz
tar -xzf ./node_exporter-*.tar.gz
./node_exporter-*/node_exporter # a mettre dans un systemd ou autre
# you can access metrics on port 9100

### Setup prometheus server
wget https://github.com/prometheus/prometheus/releases/download/v2.53.4/prometheus-2.53.4.linux-amd64.tar.gz
tar -xzf ./prometheus*.tar.gz
./prometheus*/prometheus
# you can access ui on port 9090, you may forever have a look at the metric node_memory_MemAvailable_bytes
```
