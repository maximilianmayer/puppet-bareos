# Class: bareos
# ===========================
#
# Install a bareos enterprise class backup instance.
#
# Parameters
# ----------
#
# Here is the list of parameters used by this module.
#
# * `manage_repo`
#   Specify if the module should manage the yum repository
#   Default value is true
#
# * `type_fd`
#   Specify if file descriptor components should be installed
#   Default value is false
#
# * `type_sd`
#   Specify if storage daemon components should be installed
#   Default value is false
#
# * `type_dir`
#   Specify if director components should be installed
#   Default value is false
#
# * `type_webui`
#   Specify if webui components should be installed
#   Default value is false
#
# * `db_password`
#   Specify the database password
#   Default value is 0nly4install
#
# * `db_password_hash`
#   Specify the database password hash
#   Default value is *31F96A5E321BF3E06E35668ED982CC2447CF5B3F
#
# * `client_password`
#   Specify the client password
#   Default value is client-password-for-bareos
#
# * `monitor_password`
#   Specify the monitor password
#   Default value is monitor-password-for-bareos
#
# * `storage_password`
#   Specify the storage daemon password
#   Default value is storage-password-for-bareos
#
# * `storage_daemon`
#   Specify the storage daemon that should be used
#   Default value is storage-daemon.domain.local
#
# * `mail_hub`
#   Specify the mail hub that should be used
#   Default value is mail-hub.domain.local
#
# * `mail_group`
#   Specify the mail group that should be used
#   Default value is bareos-list@domain.local
#
# * `backup_clients`
#   Specify the clients that should be backuped
#   Default value is no client
#
# * `webui_user`
#   Specify the webui user and password
#   Default value is admin with webui-password-for-bareos
#
# Variables
# ----------
#
# No additonal variables are required for this module
#
# Examples
# --------
#
# @example
#    class { 'bareos':
#      type_fd => true,
#      type_sd => true,
#      type_dir => true,
#      client_password => 'Start123!',
#      monitor_password => 'Start123!',
#      storage_password => 'Start123!',
#      storage_daemon => 'bac-sd.example.local',
#      mail_hub => 'mail.example.local',
#      mail_group => 'bac-group@example.local',
#      backup_clients => [ 'client1.example.local', 'client2.example.local' ]
#    }
#
# Authors
# -------
#
# Thomas Bendler <project@bendler-net.de>
#
# Copyright
# ---------
#
# Copyright 2016 Thomas Bendler, unless otherwise noted.
#
class bareos (
  Boolean $manage_repo      = true,
  Boolean $type_fd          = false,
  Boolean $type_sd          = false,
  Boolean $type_dir         = false,
  Boolean $type_webui       = false,
  String $db_password       = $bareos::params::db_password,
  String $db_password_hash  = $bareos::params::db_password_hash,
  String $client_password   = $bareos::params::client_password,
  String $monitor_password  = $bareos::params::monitor_password,
  String $storage_password  = $bareos::params::storage_password,
  String $storage_daemon    = $bareos::params::storage_daemon,
  String $mail_hub          = $bareos::params::mail_hub,
  String $mail_group        = $bareos::params::mail_group,
  Array $backup_clients     = [],
  Hash $webui_user          = { 'admin' => 'webui-password-for-bareos' }
) inherits bareos::params {


  # Start workflow
  if $bareos::params::linux {
    class{'bareos::install': } ->
    class{'bareos::config': } ~>
    class{'bareos::run': } ->
    Class['bareos']
  }
  else {
    warning('The current operating system is not supported!')
  }
}
