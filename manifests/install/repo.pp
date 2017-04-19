# == Class: bareos::install::repo
#
# This class contain the repository for bareos packages
#
class bareos::install::repo (
  String $bareos_version = '16.2'
){

	$bv_repo = regsubst($bareos_version,'\.','-')
  # Define repository
  case $facts['os']['name'] {
    'CentOS': {
      $repository_file = "c${::lsbmajdistrelease}_${bv_repo}.repo"
    }
    default: {
      $repository_file = "rhel${::lsbmajdistrelease}_${bv_repo}.repo"
    }
  }
  $module_repository_file = "puppet:///modules/bareos/repo/${repository_file}"

  # Create client defintion
  file { $bareos::params::package_repository:
    ensure => file,
    mode   => '0644',
    notify => Exec['rpm-key-import', 'yum-update-cache'],
    source => $module_repository_file;
  }

  # yum/rpm configuration
  exec { 'rpm-key-import':
    command     => "rpm --import http://download.bareos.org/bareos/release/${bareos_version}/CentOS_7/repodata/repomd.xml.key",
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }

  exec { 'yum-update-cache':
    command     => 'yum clean all && yum makecache',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }
}
