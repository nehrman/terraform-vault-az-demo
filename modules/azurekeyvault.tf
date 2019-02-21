# here, we define a random id that will be used by Azure Key Vault Name.

resource "random_id" "vault_unseal" {
  byte_length = "4"
}

# Create the Azure Key Vault Configuration. Be careful with the name that must be unique inside Azure.

resource "azurerm_key_vault" "vault_unseal" {
  name                            = "${var.az_prefix}vault${random_id.vault_unseal.id}"
  location                        = "${azurerm_resource_group.rg.location}"
  resource_group_name             = "${azurerm_resource_group.rg.name}"
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  tenant_id                       = "${data.azurerm_client_config.current.tenant_id}"

  sku {
    name = "standard"
  }

  tags = "${var.az_tags}"
}

# Create the Access Policy for Vault Virtual Machines to allow them to have access to the key faut auto-unseal process.

resource "azurerm_key_vault_access_policy" "vault_unseal_spn" {
  count        = "${var.az_vault_nb_instance}"
  key_vault_id = "${azurerm_key_vault.vault_unseal.id}"

  tenant_id  = "${data.azurerm_client_config.current.tenant_id}"
  object_id  = "${element(azurerm_virtual_machine.vault.*.identity.0.principal_id, count.index)}"
  depends_on = ["azurerm_key_vault.vault_unseal"]

  key_permissions = [
    "get",
    "list",
    "update",
    "create",
    "delete",
    "unwrapKey",
    "wrapKey",
  ]

  secret_permissions = [
    "get",
    "list",
    "set",
    "delete",
  ]

  certificate_permissions = [
    "get",
    "list",
    "update",
    "create",
    "delete",
  ]
}

# Create Access Policy to authorize the Service Principal Name used for Terraform operations to create the Key.

resource "azurerm_key_vault_access_policy" "vault_unseal" {
  key_vault_id = "${azurerm_key_vault.vault_unseal.id}"

  tenant_id  = "${data.azurerm_client_config.current.tenant_id}"
  object_id  = "${data.azurerm_client_config.current.service_principal_object_id}"
  depends_on = ["azurerm_key_vault.vault_unseal"]

  key_permissions = [
    "get",
    "list",
    "update",
    "create",
    "delete",
    "unwrapKey",
    "wrapKey",
  ]

  secret_permissions = [
    "get",
    "list",
    "set",
    "delete",
  ]

  certificate_permissions = [
    "get",
    "list",
    "update",
    "create",
    "delete",
  ]
}

# Create Azure Key Vault key to be used for Vault Auto-Unseal.

resource "azurerm_key_vault_key" "vault_unseal" {
  name         = "generated-certificate"
  key_vault_id = "${azurerm_key_vault.vault_unseal.id}"
  key_type     = "RSA"
  key_size     = 2048
  depends_on   = ["azurerm_key_vault_access_policy.vault_unseal_spn", "azurerm_key_vault_access_policy.vault_unseal"]

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}
