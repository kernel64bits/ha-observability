# Introduction
Let's automate what we did in v1 using terraform. I also added the following improvements: 
- Setup DNS server in the subnet ressource
- node-exporter

# Setup
## Provision the infrastructure

### Terraform
**NB:** No need to generate a token, terraform can use the openstack environment variables

Run the following commands to provision the infrastructure
```bash
cd ha-observability/v2
terraform workspace new test_terraform
terraform init
terraform plan
```

### Some manual steps
Since I have limited time, there are a couple of things I did not automate.

#### Get bastion IP addresses
The bastion "public" IP addresses are generated dynamically by OVH
```bash
openstack server list
```

#### Bastion network route configuration
The private network gateway is messing up with the bastion public IPv4 configuration. The fastest way I found was to remove the default route to the router (it's not going to survive a reboot): 

```bash
ssh <bastion_ipv6_address> # it's not gonna work with the IPv4
ip route del default via 10.0.0.1
# Check that you can now SSH using
```

## Ansible

Run the following command to install 

```bash
ansible-playbook -i inventory/hosts global-config.yml node-exporter.yml prometheus.yml
```

# Use
```bash

```