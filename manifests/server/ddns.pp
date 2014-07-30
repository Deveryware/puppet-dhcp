# === Define Resource Type: dhcp::server::ddns
#
# This type will create the file to update the DNS entries of static leases.
# The file contains each zones to update by the DHCP server
#
# === Parameters
#
# [*dnsupdatekey*]
# The key name allowed to update DNS Zones
#
# [*dnsupdatekeylocation*]
# The key location
#
# [*dnsupdatezones*]
# DNS Zones to update
#
# [*nameservers*]
# Nameservers in DNS Zones
#
# === Examples
#
# include "/etc/bind/rndc.key";
#
# zone dw.com. {
#     primary 192.168.33.14;
#     key rndc.key;
# }
#
# zone 33.168.192.in-addr.arpa. {
#     primary 192.168.33.14;
#     key rndc.key;
# }
#
define dhcp::server::ddns ($dnsupdatekey,
                           $dnsupdatekeylocation,
                           $dnsupdatezones,
                           $nameservers) {

  $context = '/files/etc/dhcp/dhcpd.conf'
  $config = "/etc/dhcp/dhcpd.conf.ddns"
  $include = "include[. = '${config}']"

  file { $config:
    ensure  => $ensure,
    owner   => root,
    group   => root,
    content => template("${module_name}/dhcpd.conf.ddns.erb"),
    require => Class['dhcp::server::config'],
    notify  => Class['dhcp::server::service']
  }

  augeas { "include-${name}.conf":
    context => $context,
    changes => "set ${include} ${config}",
    require => File[$config]
  }
}

