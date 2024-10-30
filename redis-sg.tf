resource "alicloud_security_group" "http_redis" {
  name        = "redis"
  description = "redis allow"
  vpc_id      = alicloud_vpc.vpc.id
}




resource "alicloud_security_group_rule" "http_redissh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.http_redis.id
  source_security_group_id = alicloud_security_group.bastion.id

}


resource "alicloud_security_group_rule" "httpallow" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "6379/6379"
  priority          = 1
  security_group_id = alicloud_security_group.http_redis.id
  source_security_group_id = alicloud_security_group.http.id
  
}

 

