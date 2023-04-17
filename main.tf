output "vpc" {
  value       = ibm_is_vpc.vpc.id
}

locals {
  zone  = "${var.region}-1"
  zone2 = "${var.region}-2"
  zone3 = "${var.region}-3"
}

resource "ibm_is_vpc" "vpc" {
  name                        = var.vpc_name
  resource_group              = data.ibm_resource_group.admins.id
  default_network_acl_name    = "${var.vpc_name}-acl-default"
  default_security_group_name = "${var.vpc_name}-sg-default"
  default_routing_table_name  = "${var.vpc_name}-router-default"
  address_prefix_management   = "auto"
  tags                        = ["project:${var.vpc_name}"]
}

resource "ibm_is_public_gateway" "pgw" {
  name           = "${var.vpc_name}-pgw"
  vpc            = ibm_is_vpc.vpc.id
  zone           = local.zone
  resource_group = data.ibm_resource_group.admins.id
}

resource "ibm_is_public_gateway" "pgw2" {
  name           = "${var.vpc_name}-pgw2"
  vpc            = ibm_is_vpc.vpc.id
  zone           = local.zone2
  resource_group = data.ibm_resource_group.admins.id
}

resource "ibm_is_public_gateway" "pgw3" {
  name           = "${var.vpc_name}-pgw3"
  vpc            = ibm_is_vpc.vpc.id
  zone           = local.zone3
  resource_group = data.ibm_resource_group.admins.id
}

resource "ibm_is_subnet" "subnet" {
  name                     = "${var.vpc_name}-subnet"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = local.zone
  total_ipv4_address_count = 256
  #ipv4_cidr_block = var.subnet
  resource_group = data.ibm_resource_group.admins.id
  public_gateway = ibm_is_public_gateway.pgw.id
  depends_on = [
    ibm_is_public_gateway.pgw,
    #ibm_is_vpc_address_prefix.prefix
  ]
}

resource "ibm_is_subnet" "subnet2" {
  name                     = "${var.vpc_name}-subnet2"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = local.zone2
  total_ipv4_address_count = 256
  #ipv4_cidr_block = var.subnet2
  resource_group = data.ibm_resource_group.admins.id
  public_gateway = ibm_is_public_gateway.pgw2.id
  depends_on = [
    ibm_is_public_gateway.pgw2,
    #ibm_is_vpc_address_prefix.prefix2
  ]
}

resource "ibm_is_subnet" "subnet3" {
  name                     = "${var.vpc_name}-subnet3"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = local.zone3
  total_ipv4_address_count = 256
  #ipv4_cidr_block = var.subnet3
  resource_group = data.ibm_resource_group.admins.id
  public_gateway = ibm_is_public_gateway.pgw3.id
  depends_on = [
    ibm_is_public_gateway.pgw3,
    #ibm_is_vpc_address_prefix.prefix3
  ]
}

data "ibm_resource_group" "admins" {
  name = "etevpc-admins"
}
