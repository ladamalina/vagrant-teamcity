# Configure php-fpm service
#
# === Parameters
#
# [*config_file*]
#   The path to the fpm config file
#
# [*user*]
#   The user that runs php-fpm
#
# [*group*]
#   The group that runs php-fpm
#
# [*inifile*]
#   The path to ini file
#
# [*settings*]
#   Nested hash of key => value to apply to php.ini
#
# [*pool_base_dir*]
#   The folder that contains the php-fpm pool configs
#
# [*pool_purge*]
#   Whether to purge pool config files not created
#   by this module
#
# [*log_level*]
#   The php-fpm log level
#
# [*emergency_restart_threshold*]
#   The php-fpm emergency_restart_threshold
#
# [*emergency_restart_interval*]
#   The php-fpm emergency_restart_interval
#
# [*process_control_timeout*]
#   The php-fpm process_control_timeout
#
# [*log_owner*]
#   The php-fpm log owner
#
# [*log_group*]
#   The group owning php-fpm logs
#
# [*log_dir_mode*]
#   The octal mode of the directory
#
class php::fpm::config(
  $config_file                 = $::php::params::fpm_config_file,
  $user                        = $::php::params::fpm_user,
  $group                       = $::php::params::fpm_group,
  $inifile                     = $::php::params::fpm_inifile,
  $settings                    = {},
  $pool_base_dir               = $::php::params::fpm_pool_dir,
  $pool_purge                  = false,
  $log_level                   = 'notice',
  $emergency_restart_threshold = '0',
  $emergency_restart_interval  = '0',
  $process_control_timeout     = '0',
  $log_owner                   = $::php::params::fpm_user,
  $log_group                   = $::php::params::fpm_group,
  $log_dir_mode                = '0770',
  $root_group                  = $::php::params::root_group,
) inherits ::php::params {

  validate_string($user)
  validate_string($group)
  validate_string($inifile)
  validate_hash($settings)

  $number_re = '^\d+$'
  $interval_re = '^\d+[smhd]?$'

  validate_absolute_path($pool_base_dir)
  validate_string($log_level)
  validate_re($emergency_restart_threshold, $interval_re)
  validate_re($emergency_restart_interval, $interval_re)
  validate_re($process_control_timeout, $interval_re)
  validate_string($log_owner)
  validate_string($log_group)
  validate_re($log_dir_mode, $number_re)


  if $caller_module_name != $module_name {
    warning('php::fpm::config is private')
  }

  # Hack-ish to default to user for group too
  $log_group_final = $log_group ? {
    undef   => $log_owner,
    default => $log_group,
  }

  file { $config_file:
    ensure  => file,
    notify  => Class['::php::fpm::service'],
    content => template('php/fpm/php-fpm.conf.erb'),
    owner   => root,
    group   => $root_group,
    mode    => '0644',
  }

  file { $pool_base_dir:
    ensure => directory,
    owner  => root,
    group  => $root_group,
    mode   => '0755',
  }

  if $pool_purge {
    File[$pool_base_dir] {
      purge   => true,
      recurse => true,
    }
  }

  ::php::config { 'fpm':
    file   => $inifile,
    config => $settings,
    notify => Class['::php::fpm::service'],
  }
}
