#

class pe_client_tools_easy_setup::windows  (
    String $pe_server_certname = 'master',
    String $access_token_path  = '~/.puppetlabs/token',
    String $client_tools_package_path  = '/tmp/pe-client-tools.msi',
){

    file { 'C:\\ProgramData\\PuppetLabs\\puppet\\etc\\ssl\\certs':
      ensure => 'directory',
    }

    download_file { 'Download ca.pem from master' :
      url                   => "https://${pe_server_certname}:8140/puppet-ca/v1/certificate/ca",
      destination_directory => 'C:\\ProgramData\\PuppetLabs\\puppet\\etc\\ssl\\certs\\ca.pem'
    }

    file { 'C:\\ProgramData\\PuppetLabs\\client-tools\\orchestrator.conf':
      ensure  => file,
      content => epp('orchestrator.conf.epp'),
    }

    file { 'C:\\ProgramData\\PuppetLabs\\client-tools\\puppet-access.conf':
      ensure  => file,
      content => epp('puppet-access.conf.epp'),
    }

    file { 'C:\\ProgramData\\PuppetLabs\\client-tools\\puppet-code.conf':
      ensure  => file,
      content => epp('puppet-code.conf.epp'),
    }

    file { 'C:\\ProgramData\\PuppetLabs\\client-tools\\puppetdb.conf':
      ensure  => file,
      content => epp('puppetdb.conf.epp'),
    }

    file { $client_tools_package_path: }

    exec { 'mount client-tools':
      command => "msiexec /i  ${client_tools_package_path}",
      require => File[$client_tools_package_path],
    }

}
