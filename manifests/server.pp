# == Class: omd::server
#
# This class installs and configures omd.
#
# This works on Debian and RedHat like systems.
# Puppet Version >= 3.4.0
#
# === Parameters
#
# [*ensure*]
#   Ensure parameter. Common package 'ensure' or version.
#   defaults to _installed_
#
# [*repo*]
#   Which repo to use stable/testing
#   defaults to _stable_
#
# [*sites*]
#   Omd::sites to create, give hash with name and option.
#   defaults to _{ 'default' => {} }_
#
# [*sites_defaults*]
#   Defaults hash for all site to create with $sites.
#   defaults to _{}_
#
# === Examples
#
# include omd::server
#
# === Authors
#
# Frederik Wagner <wagner@wagit.de>
#
# === Copyright
#
# Copyright 2014 Frederik Wagner
#
class omd::server (
  $ensure         = $omd::server::params::ensure,
  $repo           = $omd::server::params::repo,
  $sites          = $omd::server::params::sites,
  $sites_defaults = $omd::server::params::sites_defaults,
) inherits omd::server::params {
  validate_re($ensure, ['^installed|latest|absent|purged$',
                        '^\d\.\d\d$'])
  validate_re($repo, '^stable|testing$')
  validate_hash($sites)

  contain 'omd::server::install'

  create_resources('omd::site', $sites, $sites_defaults)

}
