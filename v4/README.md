# Introduction

In this step I will setup a fully redunded prometheus using 2 servers in active/passive mode. These 2 servers will share a common volume.

I choose not to create an arbiter

# technical choices

# Setup

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
- Add the bastion public IPv4 in 

# Improvements
