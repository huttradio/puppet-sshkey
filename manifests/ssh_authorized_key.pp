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
define sshkey::ssh_authorized_key
(
  $ensure   = 'present',
  $options  = undef,
  $provider = 'parsed',
  $target   = undef,
  $user     = undef,

  $dir  = undef,
  $file = undef,
)
{
  include ::sshkey::params

  $_dir  = pick($dir, $::sshkey::params::dir)
  $_file = pick($file, "${_dir}/${name}.pub")

  $data = split(file($_file), ' ')
  $type = $data[0]
  $key  = $data[1]

  ssh_authorized_key
  { $name:
    ensure   => $ensure,
    key      => $key,
    options  => $options,
    provider => $provider,
    target   => $target,
    type     => $type,
    user     => $user,
  }
}
