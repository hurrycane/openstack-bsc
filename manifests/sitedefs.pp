$ntpservers = [ "0.debian.pool.ntp.org", "1.debian.pool.ntp.org", "2.debian.pool.ntp.org" ]

$monitored_nodes = [ { "name" => "node1.test.cadmio.org", "ip" => "46.137.48.255" } ]

# host on which the munin master is located
$monitoring_host = "178.79.146.215"

$mysql_password = "distributedCluster"

$cluster_password = "testing"
$service_token = "testing"

# type of virtualisation
$libvirt_type = "qemu"

# controller node address
$controller_node_ip = "127.0.0.1"

# fixed range for cluster IP addresses
$fixed_range = "192.168.0.0/24"

node default {
	include ntp
	include sudo
	include users
  include git
#	include mysql
}

class openstack-base-node {
  include users

  create_user { "stack":
    uid      => 1002,
    email    => "openstack@cadmio.org",
    home     => "/opt/stack",
    keyfiles => [ "openstack.pub"]
  }

  include nova
  include keystone
  include glance
  include nova-compute
  include nova-api
  include nova-volumes
  include nova-network
}

node "ip-10-59-62-96.eu-west-1.compute.internal" {
  include openstack-base-node
  include mysql
}

#node "ip-10-58-111-96.eu-west-1.compute.internal" {
#	include nova-common
#	include nova-compute
#	include nova-scheduler
#	include nova-network
#	include nova-api
#	include openstackx
#
#	include keystone
#	include glance
#}
