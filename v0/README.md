# Version 0: Setup your work environment
## Create GPG key
- Generate key: `gpg --full-generate-key`
- Display key id: `gpg --list-secret-keys --keyid-format=long`
- Export public key in text mode: `gpg --armor --export 72156100710AAC1C`
- Export secret key: `gpg --output mygpgkey_sec.gpg --armor --export-secret-key`

For more information: https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key

## Generate a keypair
You will need a keypair to SSH to your VMs. Generate one and add the public part in a directory called _credentials_
```bash
ssh-keygen -t ed25519 #Choose the default file location
mkdir credentials
ln -s ~/.ssh/id_ed25519.pub credentials/
```

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

### OpenStack credentials setup
You will be provided a encrypted file containing your OpenStack credentials.

#### Decrypt the credentials
Run the following command to decipher the file: `gpg --output doc --decrypt cloud.yaml.gpg`
You should obtain a text file containing the following fields:
- auth_url
- password
- project_id
- project_name
- user_domain_name
- username
- identity_api_version
- interface
- region_name

#### Setup OpenStack variable environments
The easiest way to configure OpenStack is by using environment variables. Adapt the following lines with your credentials and put them in a file called _credentials/openrc.sh_.
```bash
export OS_AUTH_URL=<auth_url>
export OS_IDENTITITY_API_VERSION=<identity_api_version>
export OS_USERNAME=<username>
export OS_PASSWORD=<password>
export OS_TENANT_NAME=<project_name>
export OS_TENANT_ID=<project_id>
export OS_REGION_NAME=<region_name>
export OS_USER_DOMAIN_NAMEexport OS_USER_DOMAIN_NAME=${OS_USER_DOMAIN_NAME:-"<user_domain_name>"}
export OS_PROJECT_DOMAIN_NAME=${OS_PROJECT_DOMAIN_NAME:-"<user_domain_name>"}
```

You can then charge the variable by running the following commands. 
```bash
source openrc.sh
```
**NB:** You will have to run this command every time you open a new terminal.

## Setup Terraform
### Install Terraform
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

### Credentials setup
Although it is possible to specify credentials in _provider.tf_, Terraform also works with OpenStack environment variables.

## Setup ansible
```bash
# Use the same python venc than for openstack
python3 -m venv env
python3 -m pip install ansible
```

## Setup SSH config
Add the following lines to _~/.ssh/config_ to make SSH easier.
```
Host *
    StrictHostKeyChecking no #avoid SSH warning in case of VM recreation
    User ubuntu
```