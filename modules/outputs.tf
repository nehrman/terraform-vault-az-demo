output "resource_group_id" {
  description = "id of resource group"
  value       = "${azurerm_resource_group.rg.id}"
}

output "resource_group_name" {
  description = "name of resource group"
  value       = "${azurerm_resource_group.rg.name}"
}

output "virtual_network_name" {
  description = "name of virtual network created in resource group"
  value       = "${azurerm_virtual_network.net.name}"
}

output "virtual_network_id" {
  description = "id of virtual network created in resource group"
  value       = "${azurerm_virtual_network.net.id}"
}

output "virtual_network_subnets_name" {
  description = "name of subnets created inside the new vNet"
  value       = "${azurerm_subnet.subnet.*.name}"
}

output "virtual_network_subnets_id" {
  description = "The ids of subnets created inside the new vNet"
  value       = "${azurerm_subnet.subnet.*.id}"
}

output "load_balancer_id" {
  description = "the id for the azurerm_lb resource"
  value       = "${azurerm_lb.lb.id}"
}

output "load_balancer_backend_pool_id" {
  description = "the id for the azurerm_lb_backend_address_pool resource"
  value       = "${azurerm_lb_backend_address_pool.lb.id}"
}

output "load_balancer_public_ip_address" {
  description = "the ip address for the azurerm_lb_public_ip resource"
  value       = "${azurerm_public_ip.lb.*.ip_address}"
}

output "bastion_virtual_machine_name" {
  description = "name of virtual machines"
  value       = "${azurerm_virtual_machine.bastion.*.name}"
}

output "bastion_network_interface_name" {
  description = "name of network interface attached to vm"
  value       = "${azurerm_network_interface.bastion.*.name}"
}

output "bastion_network_interface_private_ip" {
  description = "private ip addresses of the vm nics"
  value       = "${azurerm_network_interface.bastion.*.private_ip_address}"
}

output "bastion_network_interface_public_ip" {
  description = "private ip addresses of the vm nics"
  value       = "${azurerm_public_ip.bastion.*.ip_address}"
}
