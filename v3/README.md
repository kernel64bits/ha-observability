# Introduction

Now that we have an automated infrastructure provisioning and configuration, let's add some redundancy.

## Instance choice
I'm moving the environment provided by OVH (so far I was using my personal OVH account).
Some instance provided in the lab scilabus are not available. I prefer to use smaller instance with horizontal scaling -> c2-7.

For some reason the default security group is now stricter than on my previous personal openstack project and it block all IPv6 by default.

## Step 1
For now we are limited to the instance size (50 GB) and SLA (99,99% according to  the [OVH website](https://us.ovhcloud.com/legal/sla/public-cloud/)).
One solution could be to use external storage. Prometheus is not yet compatible with object storage (experimental for now accordint to their [website](https://prometheus.io/docs/specs/prw/remote_write_spec_2_0/)). 

So we can try to add a basic cloud storage volume. This will higly increase the amount fo data that we can store (I did not find the size limit though) and their survivability (because of data replication). It is also possible to create snapshots. However the SLA will decrease to 99,9%. We will deal with that later.

To do this I have to adapt the Terraform config to configure the volume, and Ansible to format it and mount it correctly.

The terraform & Ansible commands are the same than in v2

## Step 2
A very basic solution to improve availability would be to setup a second independant Prometheus server. In case of failure of the first instance, data would still be available on the second one. We could also imagine methods to resynchronize data between nodes. The downsides would be: network traffic mutiplied by 2 and no scaling improvement.

Apart from the data synchronization this solution is very easy to setup (just copy paste some code) and not very satifsying so I won't waste time implementing it.
