# Setup your work environment

## Create GPG key

- Generate key: `gpg --full-generate-key`
- Display key id: `gpg --list-secret-keys --keyid-format=long`
- Export public key in text mode: `gpg --armor --export 72156100710AAC1C`
- Export secret key: `gpg --output mygpgkey_sec.gpg --armor --export-secret-key`

https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key

## Setup OpenStack

### Install OpenStack cli
```bash
apt update
apt install python3-pip python3-venv -y
python3 -m venv env
source env/bin/activate
(env)$ pip3 install --upgrade pip
(env)$ pip3 install python-openstackclient
```
https://help.ovhcloud.com/csm/fr-public-cloud-compute-prepare-openstack-api-environment?id=kb_article_view&sysparm_article=KB0050995

### Import OpenStack token

```bash
source openrc.sh
```

## Setup Terraform

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
