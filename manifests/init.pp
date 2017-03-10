# Class: pe_client_tools_easy_setup
# ===========================
#
# This module installs and configures PE client tools on your machine
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'pe_client_tools_easy_setup':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class pe_client_tools_easy_setup (
    String $client_tools_package_path,
    String $pe_server_certname = 'master',
    String $access_token_path  = '~/.puppetlabs/token',
){

  case $::kernel {
    'windows': {
      class {'pe_client_tools_easy_setup::windows':
        client_tools_package_path => $client_tools_package_path,
        pe_server_certname        => $pe_server_certname,
        access_token_path         => $access_token_path,
      }
    }
    'Linux': {
      class {'pe_client_tools_easy_setup::linux':
        client_tools_package_path => $client_tools_package_path,
        pe_server_certname        => $pe_server_certname,
        access_token_path         => $access_token_path,
      }
    }
    'Darwin': {
      class {'pe_client_tools_easy_setup::darwin':
        client_tools_package_path => $client_tools_package_path,
        pe_server_certname        => $pe_server_certname,
        access_token_path         => $access_token_path,
      }
    }
    default: {
      class {'pe_client_tools_easy_setup::linux':
        client_tools_package_path => $client_tools_package_path,
        pe_server_certname        => $pe_server_certname,
        access_token_path         => $access_token_path,
      }
    }
  }

}
