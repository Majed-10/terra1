# Create a new Security in a VPC
resource "alicloud_security_group" "mysql" {
  name        = "redis"
  description = "redis allow"
  vpc_id      = alicloud_vpc.vpc.id
}
resource "alicloud_security_group_rule" "allow_all_sshSQL" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.mysql.id
  source_security_group_id = alicloud_security_group.bastion.id
}

resource "alicloud_security_group_rule" "allow_all_http" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "3306/3306"
  priority          = 1
  security_group_id = alicloud_security_group.mysql.id
  source_security_group_id = alicloud_security_group.http.id
}
