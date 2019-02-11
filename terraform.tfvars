################################################################################
#                                                                              #
# This file must be rename (without .example) and customize for your own need. #
#                                                                              #
################################################################################

# Username that will be used to connect to VMs and by Ansible Playbook

global_admin_username = "hashiadmin"

# SSH Keys that will be used to connect to nodes

id_rsa_path = "/Users/nicolas/.ssh/id_rsa_az"
ssh_public_key = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4oo5BbgZwTRrm9H0gVBveYV6Rx/7ORskgz0MGcAfTRFlYfkpnZFDEox9B1xBavWUCpIKwTLgHwzcepiQ9+8hK280pMpCqnp5Q3e2EGJ3tHji6vPhZFNFjhq2b8nhY1aQFxt31L3pX2kZwjPa5cfRkeyUCwxqbbyar5sks8JxBA2l+KhelM1fR8jcXHF9MUWHfxL8bjw9AmD24p3j35UmU3yQZGShITvFdEgnLOaOXjwqylrTK0XzV4R0AO7sJrse97xZaD3jYUEFCxqf1xo2rRSD2y2goQ8WnVv66Ep9CVg/jMG99UCWNCfKZSCsopM4xBP5h5YOSC6QyBDBjXfT/ nicolas@MacBook-Pro-de-Nicolas.local"]

# Global Variables to determine location, name and more 

az_location = "francecentral"
az_name     = "demo"
az_env      = "dev"
az_prefix   = "hashi"

# Be careful with storage account name. Must be lower case (it's in the code) and not more than 16 characters

az_storage_account_name = "hashivaultsto"

# Here, enter the number of instance you want to deploy

az_bastion_nb_instance = "1"
az_consul_nb_instance  = "3"
az_vault_nb_instance   = "2"

# Package's version to install on nodes 

consul_version  = "1.4.2"
vault_version   = "1.0.2"

