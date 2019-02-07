data "azurerm_client_config" "current" {}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.tf_az_env}-${var.tf_az_name}-rg"
  location = "${var.tf_az_location}"
  tags     = "${var.tf_az_tags}"
}

# Create Virtual Network in the Resource Group
resource "azurerm_virtual_network" "net" {
  name                = "${var.tf_az_env}-${var.tf_az_name}-net"
  location            = "${var.tf_az_location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  address_space       = ["${var.tf_az_net_addr_space}"]
  dns_servers         = "${var.tf_az_dns_servers}"
  tags                = "${var.tf_az_tags}"
}

# Create subnets attached to Virtual Network
resource "azurerm_subnet" "subnet" {
  name                 = "${var.tf_az_env}-${var.tf_az_name}-${var.tf_az_subnet_names[count.index]}"
  virtual_network_name = "${azurerm_virtual_network.net.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefix       = "${var.tf_az_subnet_prefixes[count.index]}"
  count                = "${length(var.tf_az_subnet_names)}"
}

# Create Storage Account inside Resource Group
resource "azurerm_storage_account" "storageaccount" {
  name                     = "${lower(var.tf_az_storage_account_name)}"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  location                 = "${var.tf_az_location}"
  account_tier             = "${var.tf_az_storage_account_tier}"
  account_replication_type = "${var.tf_az_storage_account_repl}"
  tags                     = "${var.tf_az_tags}"
}

resource "azurerm_availability_set" "avset" {
  count                        = "${var.tf_az_lb_conf}"
  name                         = "${var.tf_az_env}-${var.tf_az_prefix}-avset"
  location                     = "${var.tf_az_location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

# Create Public IP Address for the Load Balancer
resource "azurerm_public_ip" "lb" {
  count               = "${var.tf_az_lb_type == "public" ? 1 : 0}"
  name                = "${var.tf_az_env}-${var.tf_az_name}-lb-pubip"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${var.tf_az_location}"
  allocation_method   = "${var.tf_az_pubip_address_alloc}"
  tags                = "${var.tf_az_tags}"
}

# create and configure Azure Load Balancer 

resource "azurerm_lb" "lb" {
  name                = "${var.tf_az_env}-${var.tf_az_name}-lb"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${var.tf_az_location}"
  tags                = "${var.tf_az_tags}"

  frontend_ip_configuration {
    name                 = "${var.tf_az_ft_name}"
    public_ip_address_id = "${azurerm_public_ip.lb.id}"
  }
}

resource "azurerm_lb_probe" "lb" {
  name                = "${var.tf_az_name}-${var.tf_az_lb_probes_port}-probe"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.lb.id}"
  protocol            = "${var.tf_az_lb_probes_protocol}"
  port                = "${var.tf_az_lb_probes_port}"
  request_path        = "${var.tf_az_lb_probes_path}"
  number_of_probes    = "${var.tf_az_lb_nb_probes}"
}

resource "azurerm_lb_rule" "lb" {
  name                           = "${var.tf_az_name}-rule"
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.lb.id}"
  protocol                       = "${var.tf_az_lb_rule_proto}"
  frontend_port                  = "${var.tf_az_lb_rule_ft_port}"
  backend_port                   = "${var.tf_az_lb_rule_bck_port}"
  frontend_ip_configuration_name = "${var.tf_az_ft_name}"
  probe_id                       = "${azurerm_lb_probe.lb.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lb.id}"
  depends_on                     = ["azurerm_lb_probe.lb", "azurerm_lb_backend_address_pool.lb"]
}

resource "azurerm_lb_backend_address_pool" "lb" {
  name                = "${var.tf_az_env}-${var.tf_az_name}-bck-pool"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.lb.id}"
}

# Create Security Group related to VMs
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.tf_az_env}-${var.tf_az_prefix}-sg"
  location            = "${var.tf_az_location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  tags                = "${var.tf_az_tags}"

  security_rule {
    name                       = "allow_remote_access_to_bastion"
    description                = "Allow SSH connection to Bastion"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_remote_access_to_vault_servers"
    description                = "Allow SSH connection to Vault Servers"
    priority                   = 900
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8200"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
