define dhcp::server::ddns ($dnsupdatekey,
                           $dnsupdatekeylocation,
                           $dnsupdatezones,
                           $nameservers) {

  $context = '/files/etc/dhcp/dhcpd.conf'
  $config = "/etc/dhcp/dhcpd.conf.ddns"
  $include = "include[. = '${config}']"

# Create a file to update the DNS entries of static leases. 
# The file contains each zones to update by the DHCP server
  file { $config:
    ensure  => $ensure,
    owner   => root,
    group   => root,
    content => template("${module_name}/dhcpd.conf.ddns.erb"),
    require => Class['dhcp::server::config'],
    notify  => Class['dhcp::server::service']
  }

# Include the dynamic dns file in dhcpd.conf.
  augeas { "include-${name}.conf":
    context => $context,
    changes => "set ${include} ${config}",
    require => File[$config]
  }
}

