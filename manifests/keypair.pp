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
define sshkey::keypair
(
  $user,

  $ensure              = 'present',
  $manage_public_file  = true,
  $manage_private_file = true,

  $owner = undef,
  $group = undef,

  $target_dir          = undef,
  $target_public_file  = undef,
  $target_private_file = undef,

  $target_public_file_mode  = '0444',
  $target_private_file_mode = '0400',

  $dir          = undef,
  $public_file  = undef,
  $private_file = undef,
)
{
  include ::sshkey::params

  if ($ensure == 'present')
  {
    $file_ensure = 'file'
  }
  else
  {
    $file_ensure = $ensure
  }

  $_owner = pick($owner, $user)
  $_group = pick($group, $user)

  if ($user != 'root')
  {
    $_target_dir = pick($target_dir, "/home/${user}/.ssh")
  }
  else
  {
    $_target_dir = pick($target_dir, '/root/.ssh')
  }

  $_target_public_file  = pick($target_public_file, "${_target_dir}/${name}.pub")
  $_target_private_file = pick($target_private_file, "${_target_dir}/${name}")

  $_dir          = pick($dir, $::sshkey::params::dir)
  $_public_file  = pick($public_file, "${_dir}/${name}.pub")
  $_private_file = pick($private_file, "${_dir}/${name}")

  if ($manage_public_file)
  {
    file
    { $_target_public_file:
      ensure  => $file_ensure,
      content => file($_public_file),
      owner   => $_owner,
      group   => $_group,
      mode    => $target_public_file_mode,
    }
  }

  if ($manage_private_file)
  {
    file
    { $_target_private_file:
      ensure    => $file_ensure,
      content   => file($_private_file),
      show_diff => false,
      owner     => $_owner,
      group     => $_group,
      mode      => $target_private_file_mode,
    }
  }
}
