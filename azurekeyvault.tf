resource "azurerm_key_vault" "vault_unseal" {
  name                            = "testvaultvault"
  location                        = "${azurerm_resource_group.rg.location}"
  resource_group_name             = "${azurerm_resource_group.rg.name}"
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  tenant_id                       = "${data.azurerm_client_config.current.tenant_id}"

  sku {
    name = "standard"
  }

  tags = "${var.tf_az_tags}"
}

resource "azurerm_key_vault_access_policy" "vault_unseal_spn" {
  count               = "${var.tf_az_vault_nb_instance}"
  vault_name          = "${azurerm_key_vault.vault_unseal.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

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

resource "azurerm_key_vault_access_policy" "vault_unseal" {
  vault_name          = "${azurerm_key_vault.vault_unseal.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  tenant_id  = "${data.azurerm_client_config.current.tenant_id}"
  object_id  = "3ee10c6d-5b7d-49f7-a91d-83db61c38923"
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

resource "azurerm_key_vault_key" "vault_unseal" {
  name       = "generated-certificate"
  vault_uri  = "${azurerm_key_vault.vault_unseal.vault_uri}"
  key_type   = "RSA"
  key_size   = 2048
  depends_on = ["azurerm_key_vault_access_policy.vault_unseal_spn","azurerm_key_vault_access_policy.vault_unseal"]

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}
