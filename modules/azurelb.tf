# Create Public IP Address for the Load Balancer

resource "azurerm_public_ip" "lb" {
  count               = "${var.az_lb_type == "public" ? 1 : 0}"
  name                = "${var.az_env}-${var.az_prefix}-lb-pubip"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${var.az_location}"
  allocation_method   = "${var.az_pubip_address_alloc}"
  domain_name_label   = "${var.az_env}-${var.az_name}-lb"
  tags                = "${var.az_tags}"
}

# create and configure Azure Public or Private Load Balancer 

resource "azurerm_lb" "lb" {
  name                = "${var.az_env}-${var.az_name}-lb"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${var.az_location}"
  tags                = "${var.az_tags}"

  frontend_ip_configuration {
    name                          = "${var.az_lb_ft_name}"
    public_ip_address_id          = "${var.az_lb_type == "public" ? azurerm_public_ip.lb.id : ""}"
    subnet_id                     = "${var.az_lb_type == "private" ? element(azurerm_subnet.subnet.*.id, 1) : ""}"
    private_ip_address            = "${var.az_lb_type == "private" ? cidrhost(element(azurerm_subnet.subnet.*.address_prefix, 1), 1) : ""}"
    private_ip_address_allocation = "${var.az_lb_type == "private" ? var.az_lb_ft_priv_ip_addr_alloc : "Dynamic"}"
  }
}

# create Load Balancer Probe

resource "azurerm_lb_probe" "lb" {
  name                = "${var.az_name}-${var.az_lb_probes_port}-probe"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.lb.id}"
  protocol            = "${var.az_lb_probes_protocol}"
  port                = "${var.az_lb_probes_port}"
  request_path        = "${var.az_lb_probes_path}"
  number_of_probes    = "${var.az_lb_nb_probes}"
}

# Create Load Balance Rule

resource "azurerm_lb_rule" "lb" {
  name                           = "${var.az_name}-rule"
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.lb.id}"
  protocol                       = "${var.az_lb_rule_proto}"
  frontend_port                  = "${var.az_lb_rule_ft_port}"
  backend_port                   = "${var.az_lb_rule_bck_port}"
  frontend_ip_configuration_name = "${var.az_lb_ft_name}"
  probe_id                       = "${azurerm_lb_probe.lb.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lb.id}"
  depends_on                     = ["azurerm_lb_probe.lb", "azurerm_lb_backend_address_pool.lb"]
}

# Create Load Balancer Backend Pool

resource "azurerm_lb_backend_address_pool" "lb" {
  name                = "${var.az_env}-${var.az_name}-bck-pool"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.lb.id}"
}
