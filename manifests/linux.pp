#

class pe_client_tools_easy_setup::linux  (
    String $pe_server_certname = 'master',
    String $access_token_path  = '~/.puppetlabs/token',
    String $client_tools_package_path  = '/tmp/pe-client-tools.rpm',
    String $certname = 'ca.pem',
){

  file { '/etc/puppetlabs/puppet/ssl/certs':
    ensure => 'directory',
  }

  file { '/etc/puppetlabs/client-tools':
    ensure => 'directory',
  }

  exec { 'create ca.pem file':
    command => "/usr/bin/curl -k -o /etc/puppetlabs/puppet/ssl/certs/ca.pem https://${pe_server_certname}:8140/puppet-ca/v1/certificate/ca",
    creates => '/etc/puppetlabs/puppet/ssl/certs/${certname}',
    require => File['/etc/puppetlabs/puppet/ssl/certs'],
  }

  file { "/etc/puppetlabs/puppet/ssl/certs/${certname}":
    ensure  => file,
    mode    => '0444',
    require => Exec['create ca.pem file'],
  }

  file { '/etc/puppetlabs/client-tools/orchestrator.conf':
    ensure  => file,
    content => epp('pe_client_tools_easy_setup/orchestrator.conf.epp',
                  {'pe_server_certname' => $pe_server_certname, 'access_token_path' => $access_token_path}, 'certname' => $certname),
  }

  file { '/etc/puppetlabs/client-tools/puppet-access.conf':
    ensure  => file,
    content => epp('pe_client_tools_easy_setup/puppet-access.conf.epp', {'pe_server_certname' => $pe_server_certname, 'access_token_path' => $access_token_path}, 'certname' => $certname),
  }

  file { '/etc/puppetlabs/client-tools/puppet-code.conf':
    ensure  => file,
    content => epp('pe_client_tools_easy_setup/puppet-code.conf.epp', {'pe_server_certname' => $pe_server_certname, 'access_token_path' => $access_token_path}, 'certname' => $certname),
  }

  file { '/etc/puppetlabs/client-tools/puppetdb.conf':
    ensure  => file,
    content => epp('pe_client_tools_easy_setup/puppetdb.conf.epp', {'pe_server_certname' => $pe_server_certname, 'access_token_path' => $access_token_path}, 'certname' => $certname),
  }

  file { $client_tools_package_path: }

  package { 'client tools rpm':
    source   => $client_tools_package_path,
    provider => 'rpm',
    require  => File[$client_tools_package_path]
  }

}
