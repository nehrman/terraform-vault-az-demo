variable "global_admin_username" {
  default = "hashiadmin"
}

variable "id_rsa_path" {
  default = "~/.ssh/id_rsa_az"
}

variable "ssh_public_key" {
  type    = "list"
  default = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4oo5BbgZwTRrm9H0gVBveYV6Rx/7ORskgz0MGcAfTRFlYfkpnZFDEox9B1xBavWUCpIKwTLgHwzcepiQ9+8hK280pMpCqnp5Q3e2EGJ3tHji6vPhZFNFjhq2b8nhY1aQFxt31L3pX2kZwjPa5cfRkeyUCwxqbbyar5sks8JxBA2l+KhelM1fR8jcXHF9MUWHfxL8bjw9AmD24p3j35UmU3yQZGShITvFdEgnLOaOXjwqylrTK0XzV4R0AO7sJrse97xZaD3jYUEFCxqf1xo2rRSD2y2goQ8WnVv66Ep9CVg/jMG99UCWNCfKZSCsopM4xBP5h5YOSC6QyBDBjXfT/ nicolas@MacBook-Pro-de-Nicolas.local"]
}

variable "tf_az_name" {
  description = "Name used to create all resources except subnets"
  default     = "demo"
}

variable "tf_az_env" {
  description = "Environnement where the resources will be created"
  default     = "dev"
}

variable "tf_az_location" {
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  default     = "francecentral"
}

variable "tf_az_net_addr_space" {
  description = "The address space that is used by the virtual network."
  default     = "10.0.0.0/16"
}

# If no values specified, this defaults to Azure DNS 
variable "tf_az_dns_servers" {
  description = "The DNS servers to be used with vNet."
  default     = []
}

variable "tf_az_subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  default     = ["10.0.1.0/24"]
}

variable "tf_az_subnet_names" {
  description = "A list of public subnets inside the vNet."
  default     = ["subnet1"]
}

variable "tf_az_storage_account_name" {
  description = "Name used to create the Storage Account."
  default     = "hashidemoneh"
}

variable "tf_az_storage_account_tier" {
  description = "The type of Storage account. Standard or Premium are only the two validated options."
  default     = "Standard"
}

variable "tf_az_storage_account_repl" {
  description = "The type of replication to use with the Storage account. Valid options are LRS, GRS, RAGRS and ZRS"
  default     = "LRS"
}

variable "tf_az_tags" {
  description = "The tags to associate with your network and subnets."
  type        = "map"

  default {
    environment = "dev"
    owner       = "nehrman"
    purpose     = "Demo"
    cloud       = "arm"
  }
}

variable "tf_az_lb_type" {
  type        = "string"
  description = "Define which type of Load Balancer will be provided"
  default     = "public"
}

variable "tf_az_pubip_address_alloc" {
  description = "Define which type of Public IP address Allocation will be used. Valid options are Static, Dynamic."
  default     = "Static"
}

variable "tf_az_ft_name" {
  description = "Define the name of Frontend IP Configuration"
  default     = "hashi-vault-demo-lb"
}

variable "tf_az_lb_probes_protocol" {
  description = "Define the protocol used for LB probing"
  default     = "http"
}

variable "tf_az_lb_probes_port" {
  description = "Define the port used for LB probing"
  default     = "8200"
}

variable "tf_az_lb_probes_path" {
  description = "Define the path used for LB probing"
  default     = "/v1/sys/health"
}

variable "tf_az_lb_nb_probes" {
  description = "Define the number of failed probe attemps after which the endpoint is removed from the backend"
  default     = "5"
}

variable "tf_az_lb_rule_proto" {
  description = "Define the protocol used for LB Rule"
  default     = "TCP"
}

variable "tf_az_lb_rule_ft_port" {
  description = "Define the Frontend port of the LB"
  default     = "80"
}

variable "tf_az_lb_rule_bck_port" {
  description = "Define the backend port for the LB"
  default     = "8200"
}

variable "tf_az_bastion_nb_instance" {
  description = "Number of Bastion instances that will be deployed"
  default     = "1"
}

variable "tf_az_vault_nb_instance" {
  description = "Number of Vault instances that will be deployed"
  default     = "2"
}

variable "tf_az_consul_nb_instance" {
  description = "Number of Consul instances that will be deployed"
  default     = "3"
}

variable "tf_az_prefix" {
  description = "Prefix used to configure name of VMs. Ex : web"
  default     = "hashi"
}

variable "tf_az_instance_type" {
  description = "Define the type of instace to deplay"
  default     = "Standard_D2_V3"
}

variable "tf_az_lb_conf" {
  description = "Define if LB is needed or not."
  default     = true
}

variable "consul_role_bootstrap" {
  description = "Define the role of Consul Server Node"
  default     = "bootstrap"
}

variable "consul_role_server" {
  description = "Define the role of Consul Server Node"
  default     = "server"
}

variable "consul_version" {
  description = "Define the Consul version to deploy on Consul nodes"
  default     = "1.4.2"
}

variable "consul_remote_install" {
  description = "Define if Consul will be installed remotely or not"
  default     = "true"
}

variable "vault_version" {
  description = "Define the Vault version to deploy on Vault nodes"
  default     = "1.0.2"
}

variable "vault_remote_install" {
  description = "Define if Vault will be installed remotely or not"
  default     = "true"
}
