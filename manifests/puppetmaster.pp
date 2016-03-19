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
define sshkey::puppetmaster
(
  $ensure  = 'present',
  $type    = 'ssh-rsa',
  $bits    = undef,
  $comment = $name,

  $dir          = undef,
  $public_file  = undef,
  $private_file = undef,

  $ssh_keygen = undef,
  $test       = undef,
)
{
  include ::sshkey::params
  include ::sshkey::puppetmaster::dir

  if ($ensure == 'present')
  {
    $file_ensure = 'file'
  }
  else
  {
    $file_ensure = $ensure
  }

  $_bits = pick($bits, $type ?
  {
    /(ssh-rsa|rsa)/         => 2048,
    /(ssh-dss|dsa)/         => 1024,
    'ecdsa-sha2-nistp256'   => 256,
    'ecdsa-sha2-nistp384'   => 384,
    'ecdsa-sha2-nistp521'   => 521,
    /(ssh-ed25519|ed25519)/ => 256,
  })

  $_dir          = pick($dir, $::sshkey::params::dir)
  $_public_file  = pick($public_file, "${_dir}/${name}.pub")
  $_private_file = pick($private_file, "${_dir}/${name}")

  $_ssh_keygen = pick($ssh_keygen, $::sshkey::params::ssh_keygen)
  $_test       = pick($test, $::sshkey::params::test)

  if ($ensure == 'present')
  {
    exec
    { "::sshkey::puppetmaster::generate::${name}":
      command => "${_ssh_keygen} -t ${type} -b ${_bits} -C ${comment} -f ${_private_file}",
      onlyif  => "${_test} ! -f ${_public_file} -o ! -f ${_private_file}",
    }

    Class['::sshkey::puppetmaster::dir']              -> Exec["::sshkey::puppetmaster::generate::${name}"]
    Exec["::sshkey::puppetmaster::generate::${name}"] -> File[$_public_file]
    Exec["::sshkey::puppetmaster::generate::${name}"] -> File[$_private_file]
  }

  file
  { $_public_file:
    ensure => $file_ensure,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0444',
  }

  file
  { $_private_file:
    ensure => $file_ensure,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0400',
  }
}
