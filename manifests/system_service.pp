# == Class synapse::service
#
# This class is meant to be called from synapse
# It ensure the service is running
#
class synapse::system_service {
  $config_file = $synapse::config_file

  case $::osfamily {
    'RedHat','Amazon': {
      file { '/etc/init/synapse.conf':
        owner   => 'root',
        group   => 'root',
        mode    => 0444,
        content => template('synapse/synapse.conf.upstart.erb'),
      }
    }
    'Debian': {
      case $synapse::service_upstart {
        true,'true': {
          file { '/etc/init/synapse.conf':
            owner   => 'root',
            group   => 'root',
            mode    => 0444,
            content => template('synapse/synapse.conf.upstart.erb'),
          }
        }
        default: {
          file { '/etc/init.d/synapse' :
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            mode    => '0744',
            content => template('synapse/synapse.init.erb'),
          }
        }
      }
    }
    default: {
      fail("no supported service script for ${::operatingsystem}")
    }
  }

  service { 'synapse':
    ensure     => $synapse::service_ensure,
    enable     => str2bool($synapse::service_enable),
    hasstatus  => true,
    hasrestart => true,
  }
}
