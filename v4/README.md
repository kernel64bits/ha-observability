# Introduction

In this step I will setup a fully redunded prometheus using 2 servers in active/passive mode. These 2 servers will share a common volume. A VRRP will ensure the high availability.


## Shared volume
I initially thought I could use an openstack volume mounted on both VMs. According to the [OpenStack documentation](https://docs.openstack.org/cinder/latest/admin/volume-multiattach.html) it seems possible but it requires to create a new volume time, which I am not allowed to do.

So I had to think of a backup solution. I chose GlusterFS because it seemed to be the easiest to configure, but its scalability potential seems lower than Ceph. To keep it simple I decided to create the simplest cluster possible: only 2 nodes without arbiter.

To prevent concurence issues, 

# High availability
I chose to implement HA with VRRP (and its implementation keepalived) because it's the technology I master the most to solve this problem. In order to avoid concurrent writing keepalived will be in charge to keep Prometheus stopped on the backup node running on the master one. It is not ideal because we can imagine cases when both instances start writing on the same volume.

## Provision the infrastructure

Same as usual, use terraform to provision the infrastructure
```bash
cd ha-observability/v3
terraform workspace new test_terraform
terraform init
terraform plan
terraform apply
```
## Repair the bastion route

- Get the bastion IPv6 address `openstack server list`
- `ssh <bastion_ipv6> "sudo ip route del default via 10.0.0.1"`

## Configure the infrastructure
- Add the bastion public IPv4 in _ansible/inventory/hosts_
- `ansible-playbook -i inventory/hosts global-config.yml node-exporter.yml prometheus.yml glusterfs.yml keepalive.yml`

## Access the prometheus interface

- Create an SSH tunnel to the bastion `ssh -D 1337 -q -C -N <bastion>`
- Configure the SOCKS Proxy in your browser
- Access the prometheus web interface (ex: http://10.0.0.20:9090/graph?g0.expr=node_memory_MemAvailable_bytes)

NB: Since the VRRP is not reachable you have to specify the correct server IP

# Improvements
