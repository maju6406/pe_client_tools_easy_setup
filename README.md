# pe_client_tools_easy_setup

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with pe_client_tools_easy_setup](#setup)
    * [What pe_client_tools_easy_setup affects](#what-pe_client_tools_easy_setup-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pe_client_tools_easy_setup](#beginning-with-pe_client_tools_easy_setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description
This module installs and configures PE client tools on your machine
## Setup
### What pe_client_tools_easy_setup affects

This module will install files into /etc/puppetlabs/client-tools and /etc/puppetlabs/puppet/ssl/certs

### Setup Requirements
This module assumes PE is already installed, and the agent is running on the client.

#### Pre-Install Steps
Install this module by running these command first on the master as root:  
`puppet module install beersy-pe_client_tools_easy_setup`  

Then add these values to your hiera file (ex, /etc/puppetlabs/code/environments/production/hieradata/common.yaml)

* pe_client_tools_easy_setup::client_tools_package_path: CLIENT_TOOLS_PACKAGE_PATH
* pe_client_tools_easy_setup::pe_server_certname: PE_SERVER_CERTNAME
* pe_client_tools_easy_setup::access_token_path: ACCESS_TOKEN_PATH

Replace the values before running:
* **CLIENT_TOOLS_PACKAGE_PATH** = Path to client tools .msi,.rpm, or .dmg
* **PE_SERVER_CERTNAME** = certname of the PE Master (must match the name in the ca.pem file)
* **ACCESS_TOKEN_PATH**  = Where to find the access token

### Install Steps

If you are using hiera, run this command:
`puppet apply -e "include ::pe_client_tools_easy_setup"`

If you are not using hiera you can specify the parameters at the command line:  
`puppet apply -e "class { 'pe_client_tools_easy_setup': pe_server_certname => 'PE_SERVER_CERTNAME', client_tools_package_path => 'CLIENT_TOOLS_PACKAGE_PATH', access_token_path => 'ACCESS_TOKEN_PATH'}"`

## Release Notes/Contributors/Etc.

1.0.1 Updated metadata.json with supported OS & PE versions
1.0.0 Initial release
