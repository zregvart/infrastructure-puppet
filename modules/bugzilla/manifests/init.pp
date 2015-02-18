
class bugzilla (
  $required_packages = [], # Put required pacages for various CPAN libs, otherwise the puppet run with fail
  $cpan_modules      = [],
) {

  require apache
  require rootbin_asf

  package { $required_packages:
    ensure => 'latest',
  }

  perl::cpan::module { $cpan_modules:
    ensure  => 'present',
    require => Package[$required_packages],
  }

  file { ["/etc/bugzilla", "/etc/bugzilla/.puppet"]:
    ensure => directory,
    mode   => 0755,
    owner  => "root",
    group  => "root",
  }

  cron { 'bugcron':
    command => '/root/bin/bugcron.sh',
    user    => 'root',
    minute  => 15,
    hour    => 7,
    weekday => 0,
    environment => 'PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SHELL=/bin/sh',
    require => Class['rootbin_asf'],
  }

}
