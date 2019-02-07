# Create Network Nic to use with VM
resource "azurerm_network_interface" "vault" {
  count                     = "${var.tf_az_vault_nb_instance}"
  name                      = "${var.tf_az_env}-${var.tf_az_prefix}-vault-nic-${count.index}"
  location                  = "${var.tf_az_location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"

  ip_configuration {
    name                          = "ipconf${count.index}"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
  }

  tags = "${var.tf_az_tags}"
}

# Create Azure Vault Server Instances
resource "azurerm_virtual_machine" "vault" {
  count                 = "${var.tf_az_vault_nb_instance}"
  name                  = "${var.tf_az_env}-${var.tf_az_prefix}-vault-${count.index}"
  location              = "${var.tf_az_location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${element(azurerm_network_interface.vault.*.id, count.index)}"]
  vm_size               = "${var.tf_az_instance_type}"
  availability_set_id   = "${azurerm_availability_set.avset.id}"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.tf_az_env}-${var.tf_az_prefix}-vault-${count.index}-osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.tf_az_env}-${var.tf_az_prefix}-vault-${count.index}"
    admin_username = "${var.global_admin_username}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.global_admin_username}/.ssh/authorized_keys"
      key_data = "${element(var.ssh_public_key, 0)}"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = "${var.tf_az_tags}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "vault" {
  count                   = "${var.tf_az_vault_nb_instance}"
  network_interface_id    = "${element(azurerm_network_interface.vault.*.id, count.index)}"
  ip_configuration_name   = "${element(azurerm_network_interface.vault.*.ip_configuration.0.name, count.index)}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.lb.id}"
}
