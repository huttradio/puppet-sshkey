# Class: sshkey
# ===========================
#
# Full description of class sshkey here.
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
#    class { 'sshkey':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Callum Dickinson <callum@huttradio.co.nz>
#
# Copyright
# ---------
#
# Copyright 2016 Hutt Community Radio and Audio Archives Charitable Trust.
#
class sshkey::params
{
  case $::osfamily
  {
    'Debian':
    {
      $ssh_keygen = '/usr/bin/ssh-keygen'
      $test       = '/usr/bin/test'
    }

    'RedHat':
    {
      $ssh_keygen = '/usr/bin/ssh-keygen'
      $test       = '/usr/bin/test'
    }

    'FreeBSD':
    {
      $ssh_keygen = '/usr/bin/ssh-keygen'
      $test       = '/bin/test'
    }

    default:
    {
      $ssh_keygen = '/usr/bin/ssh-keygen'
      $test       = '/usr/bin/test'
    }
  }

  if (versioncmp($puppetversion, '4.0.0') < 0)
  {
    $puppet_conf_dir = '/etc/puppet'
  }
  else
  {
    $puppet_conf_dir = '/etc/puppetlabs/puppet'
  }

  $dir = "${puppet_conf_dir}/sshkey"
}