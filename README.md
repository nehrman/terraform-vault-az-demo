# A complete Automated Deployment of Vault Cluster on Azure

The main goal of this project is to demonstrate how to :
- Bootstrap Azure Infrastructure composed of 
    - A bastion Host 
    - A Public or Private Load Balancer
    - At least 2 Vault and 3 Consul Nodes
- Configure Azure Key Vault and a Key for Vault Auto-Unseal
- Auto Generate Ansible file to deploy Vault And Consul on Azure Virtual Machines

## Pre Requisites

The only things you need are:
- terraform on your laptop (can be downloaded [here](https://terraform.io)) or using the one provided by Azure on Azure Shell.
- Git to allow you to clone the repo
- A SSH private and public key

And of course, an Application with Service Principal on Azure with correct rights to do things. :)


## How to use it 

- Clone the repo on your laptop or Azure Shell :

```
$ git clone https://github.com/nehrman/terraform-vault-az-demo
```

- Copy and rename **terraform.tfvars.example** :

```
$ cp terraform.tfvars.example terraform.tfvars
```

- Customize **tfvars** file with your own values :

```
################################################################################
#                                                                              #
# This file must be rename (without .example) and customize for your own need. #
#                                                                              #
################################################################################

# Username that will be used to connect to VMs and by Ansible Playbook

global_admin_username = "yourname"

# SSH Keys that will be used to connect to nodes

id_rsa_path = "~/.ssh/id_rsa"
ssh_public_key = ["ssh-rsa kjdkjdkjskdfhsjd;v,,wxkvcjfdlqsjk"]

# Global Variables to determine location, name and more 

tf_az_location = "francecentral"
tf_az_name     = "demo"
tf_az_env      = "dev"
tf_az_prefix   = "hashi"

# Be careful with storage account name. Must be lower case (it's in the code) and not more than 16 characters

tf_az_storage_account_name = "hashivaultsto"

# Here, enter the number of instance you want to deploy

tf_az_bastion_nb_instance = "1"
tf_az_consul_nb_instance  = "3"
tf_az_vault_nb_instance   = "2"

# Package's version to install on nodes 

consul_version  = "1.4.2"
vault_version   = "1.0.2"
```

## Variables


## Outputs



## You want more ??? 

Have a look to variables.tf and customize what you need regarding :

- With or Without Load Balancer
- Private or Public Load Balancer
- And more ....

## Special thanks

* **Joern Stenkamp** - For the inspiration on auto generated ansible inventory [Github](https://github.com/joestack)
* **Brian Shumate** - For his incredilble Ansible Roles [Github](https://github.com/brianshumate)

## Authors

* **Nicolas Ehrman** - *Initial work* - [Hashicorp](https://www.hashicorp.com)

