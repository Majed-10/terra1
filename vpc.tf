data "alicloud_zones" "default" {
  available_disk_category     = "cloud_efficiency"
  available_resource_creation = "VSwitch"
}


# Create a new ECS instance for VPC
resource "alicloud_vpc" "vpc" {
  vpc_name   = "myvpc2"
  cidr_block = "10.0.0.0/8"
}

resource "alicloud_vswitch" "public" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = "10.0.8.0/24"
  zone_id      = data.alicloud_zones.default.zones.0.id
#   vswitch_name = "public-vswitch"
}

resource "alicloud_vswitch" "public1" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = "10.0.10.0/24"
  zone_id      = data.alicloud_zones.default.zones.1.id
#   vswitch_name = "public1 devrent zone(1)-vswitch"Defrit avabelty zone 
}

resource "alicloud_vswitch" "private" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = "10.0.7.0/24"
  zone_id      = data.alicloud_zones.default.zones.0.id
#  vswitch_name = "private-vswitch"
}


resource "alicloud_nat_gateway" "nat" {
  vpc_id           = alicloud_vpc.vpc.id
  nat_type         = "Enhanced"
  nat_gateway_name = "nat"
  vswitch_id       = alicloud_vswitch.public.id
  payment_type     = "PayAsYouGo"
}

resource "alicloud_eip_address" "eip_nat" {
  netmode              = "public"
  bandwidth            = "100"
  internet_charge_type = "PayByTraffic"
  payment_type         = "PayAsYouGo"
}

resource "alicloud_eip_association" "eip" {
  allocation_id = alicloud_eip_address.eip_nat.id
  instance_id   = alicloud_nat_gateway.nat.id
  instance_type = "Nat"
}

resource "alicloud_snat_entry" "http_privat_nat" {
  snat_table_id     = alicloud_nat_gateway.nat.snat_table_ids
  source_vswitch_id = alicloud_vswitch.private.id
  snat_ip           = alicloud_eip_address.eip_nat.ip_address
}

resource "alicloud_route_table" "Route" {
  description      = "private route"
  vpc_id           = alicloud_vpc.vpc.id
  route_table_name = "Route"
  associate_type   = "VSwitch"
}
resource "alicloud_route_entry" "privateroute_entry" {
  route_table_id        = alicloud_route_table.Route.id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "NatGateway"
  nexthop_id            = alicloud_nat_gateway.nat.id
}


resource "alicloud_route_table_attachment" "pr" {
  vswitch_id     = alicloud_vswitch.private.id
  route_table_id = alicloud_route_table.Route.id
}