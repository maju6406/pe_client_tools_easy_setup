#

class pe_client_tools_easy_setup::windows  (
    String $pe_server_certname = 'master',
    String $access_token_path  = '~/.puppetlabs/token',
    String $client_tools_package_path  = 'C:\\Windows\\Temp\\pe-client-tools.msi',
){

    file { 'C:\\ProgramData\\PuppetLabs\\puppet\\etc\\ssl\\certs':
      ensure => 'directory',
    }

    file { 'C:\\ProgramData\\PuppetLabs\\client-tools':
      ensure => 'directory',
    }

    $download_ca_ps1 = @(EOT)
    $url = "https://<%= $pe_server_certname %>:8140/puppet-ca/v1/certificate/ca"
    $path = "C:\\ProgramData\\PuppetLabs\\puppet\\etc\\ssl\\certs\\ca.pem"
    [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
    $webClient = new-object System.Net.WebClient
    $webClient.DownloadFile( $url, $path )
      | EOT

    file { 'C:\\Windows\\Temp\\download_ca.ps1':
        ensure  => file,
        content => inline_epp($download_ca_ps1,{'pe_server_certname' => $pe_server_certname}),
    }

    exec { 'download ca file':
      command => 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -File C:\\Windows\\Temp\\download_ca.ps1',
      require => File['C:\\Windows\\Temp\\download_ca.ps1'],
    }

    file { 'C:\\ProgramData\\PuppetLabs\\client-tools\\orchestrator.conf':
      ensure  => file,
      content => epp('pe_client_tools_easy_setup/orchestrator.conf.epp',{'pe_server_certname' => $pe_server_certname, 'access_token_path' => $access_token_path}),
    }

    file { 'C:\\ProgramData\\PuppetLabs\\client-tools\\puppet-access.conf':
      ensure  => file,
      content => epp('pe_client_tools_easy_setup/puppet-access.conf.epp',{'pe_server_certname' => $pe_server_certname, 'access_token_path' => $access_token_path}),
    }

    file { 'C:\\ProgramData\\PuppetLabs\\client-tools\\puppet-code.conf':
      ensure  => file,
      content => epp('pe_client_tools_easy_setup/puppet-code.conf.epp',{'pe_server_certname' => $pe_server_certname, 'access_token_path' => $access_token_path}),
    }

    file { 'C:\\ProgramData\\PuppetLabs\\client-tools\\puppetdb.conf':
      ensure  => file,
      content => epp('pe_client_tools_easy_setup/puppetdb.conf.epp',{'pe_server_certname' => $pe_server_certname, 'access_token_path' => $access_token_path}),
    }

    file { $client_tools_package_path: }

    package { 'client tools msi':
      source   => $client_tools_package_path,
      require  => File[$client_tools_package_path]
    }
}
