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

