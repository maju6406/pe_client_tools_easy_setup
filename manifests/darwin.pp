#

class pe_client_tools_easy_setup::darwin (
    String $pe_server_certname = 'master',
    String $access_token_path  = '~/.puppetlabs/token',
    String $client_tools_package_path  = '/tmp/pe-client-tools.dmg',
){

      file { '/etc/puppetlabs/puppet/ssl/certs':
        ensure => 'directory',
      }

      exec { 'create ca.pem file':
        command => "curl -k -o ca.pem https://${pe_server_certname}:8140/puppet-ca/v1/certificate/ca",
        creates => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
        mode    => '0444',
        require => File['/etc/puppetlabs/puppet/ssl/certs'],
      }

      file { '/etc/puppetlabs/client-tools/orchestrator.conf':
        ensure  => file,
        content => epp('orchestrator.conf.epp'),
      }

      file { '/etc/puppetlabs/client-tools/puppet-access.conf':
        ensure  => file,
        content => epp('puppet-access.conf.epp'),
      }

      file { '/etc/puppetlabs/client-tools/puppet-code.conf':
        ensure  => file,
        content => epp('puppet-code.conf.epp'),
      }

      file { '/etc/puppetlabs/client-tools/puppetdb.conf':
        ensure  => file,
        content => epp('puppetdb.conf.epp'),
      }

      file { $client_tools_package_path: }

      exec { 'mount client-tools':
        command => "hdiutil mount ${client_tools_package_path}",
        require => File[$client_tools_package_path],
      }

      exec { 'run installer':
        command => 'installer -pkg /Volumes/pe-client-tools*/pe-client-tools*.pkg  -target /',
        require => Exec['mount client-tools'],
      }

      exec { 'unmount dmg':
        command => 'umount /Volumes/pe-client-tools*',
        require => Exec['run installer'],
      }

}
