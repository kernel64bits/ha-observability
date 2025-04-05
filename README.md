# HA-observability

## Introduction
The goal of this project was to setup a scalable and highly available timeseries database with a limited amount of time (hours)

## Working method
I am making the choice to work in an incremental way by starting with the simplest possible solution and improving it step by step. While this may not be the most efficient solution for a sprint project like that, it greatly increased my chances of delivering something that works and thus producing value.
This is also why I chose to spend a signigicat amount of time to automate my work: in case of problem I can quickly reset everything a come back to a working situation.

## Technology choice

### Infrastructure provisionning
From what I know there are 2 main solutions to automatically provision an OpenStack infrastructure: OpenStack Heat and Terraform. From my experience Terraform is easier to use (at least for basic things), even if its OpenStack provider documentation seems incomplete. Anyway ChatGPT is pretty good at translating OpenStack commands into Terraform code =p

### Infrastructure Configuration
I want to stay with solutions that I have already used, there are 3 of them: Ansible, Chef, and Cloud init. The Chef client/server architecture is a bit long to setup, Cloud init is too limited do do what I want, so I am chosing Ansible. It only only requires SSH and Python which is installed by default on Ubuntu.

### Timeseries solution
I am chosing Prometheus because it is a simple technology that I already know, and I am confident in my ability to deploy rapidly a working version of it. 
Its simplicity is also a drawback, Prometheus is known for its limited ability to scale but I choose to deal with that problem later.

### Virtualization
OpenStack was imposed. I chose to deploy services directly on the VMs because I thought that setting up an entire & reliable Kubernetes or other container system would have been too long.

### Security
I did not have much time to spend on the security so I stayed with the basics:
- Services deployed on VMs not accessible from the Internet
- A bastion server with only a SSH server running on it

### OS choice
I chose the latest Ubuntu LTS version because it is the OS I know the best. It also comes directly with Python installed so Ansible works out of the box. If I move to a container based architecture I would probably go for Alpine for its lightweight and secure aspect.

## Future improvements

### Pushing Prometheus to its limits
Even though its scaling abilities are limited 
- Vertical scaling by using more powerful VMs
- Using [federations](https://prometheus.io/docs/prometheus/latest/federation/): I have never used it but from what I have understood it is a solution that allows a Prometheus server to scrape selected time series from another server. So we could imagine a 2 level architeture:
- the first layer would include several different Prometheus service in charge of collecting metrics of different parts of the infrastructure.
- a second layer with only 1 prometheus service that collects aggregated data from the 1st layer.

### Beyond Prometheus
Thanos was specifically designed to solve Prometheus limitations. It supports natively horizontal scaling and object storage (so basically all our problems).


## Bonus questions
Here are a few other ideas on how to improve.

### Bench your infrastructure
Here are several ideas on how to do it:
- Deploy small VMs with node exporter

### Include a service discovery
I did not have much time to think about it. On OpenStack, I would go for a DNS-based Service Discovery. With containerizaton there must be inbuilt solutions.
In a more artisanal way there must be some solutions to pass the Terraform outputs to Ansible.

### Deploy with infrastructure as code & automation tools
Most of the deployment is already automated.

### Provide dashboards to exploit the newly created infrastructure
Deploying a Grafana service would be pretty easy. Since it is stateless (at least for the data visualization feature), redunding it would not be much of a problem.

### Collect metrics about your metrics infrastructure
Prometheus can monitor itself and node_exporter is deployed on the Prometheus nodes.