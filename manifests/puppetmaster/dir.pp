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
class sshkey::puppetmaster::dir
(
  $ensure = 'present',
  $owner  = 'puppet',
  $group  = 'puppet',
  $mode   = '0400',

  $dir = $::sshkey::params::dir,
) inherits sshkey::params
{
  if ($ensure == 'present')
  {
    $directory_ensure = 'directory'
  }
  else
  {
    $directory_ensure = $ensure
  }

  file
  { $dir:
    ensure => $directory_ensure,
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }
}
