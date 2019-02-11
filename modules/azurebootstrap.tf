# Grab Client Configu Information to resue it later.

data "azurerm_client_config" "current" {}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.az_env}-${var.az_name}-rg"
  location = "${var.az_location}"
  tags     = "${var.az_tags}"
}

# Create Virtual Network in the Resource Group
resource "azurerm_virtual_network" "net" {
  name                = "${var.az_env}-${var.az_name}-net"
  location            = "${var.az_location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  address_space       = ["${var.az_net_addr_space}"]
  dns_servers         = "${var.az_dns_servers}"
  tags                = "${var.az_tags}"
}

# Create subnets attached to Virtual Network
resource "azurerm_subnet" "subnet" {
  name                 = "${var.az_env}-${var.az_name}-${var.az_subnet_names[count.index]}"
  virtual_network_name = "${azurerm_virtual_network.net.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefix       = "${var.az_subnet_prefixes[count.index]}"
  count                = "${length(var.az_subnet_names)}"
}

# Create Storage Account inside Resource Group
resource "azurerm_storage_account" "storageaccount" {
  name                     = "${lower(var.az_storage_account_name)}"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  location                 = "${var.az_location}"
  account_tier             = "${var.az_storage_account_tier}"
  account_replication_type = "${var.az_storage_account_repl}"
  tags                     = "${var.az_tags}"
}

resource "azurerm_availability_set" "avset" {
  count                        = "${var.az_lb_conf}"
  name                         = "${var.az_env}-${var.az_prefix}-avset"
  location                     = "${var.az_location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

# Create Security Group related to VMs
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.az_env}-${var.az_prefix}-sg"
  location            = "${var.az_location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  tags                = "${var.az_tags}"

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
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8200"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
