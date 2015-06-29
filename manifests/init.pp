# == Class: fixleapsecond
#
# Work around to avoid leap second.
#
class fixleapsecond (
  $enable_fix                  = false,
  $use_workaround              = false,
) {

  validate_absolute_path($fix_localscratch_path)

# convert stringified booleans for enable_fix
  if is_bool($enable_fix) {
    $enable_fix_real = $enable_fix
  }
  else {
    $enable_fix_real = str2bool($enable_fix)
  }

# convert stringified booleans for use_workaround
  if is_bool($use_workaround) {
    $use_workaround_real = $use_workaround
  }
  else {
    $use_workaround_real = str2bool($use_workaround)
  }

# Work around for avoid leap second
  if ( $enable_fix_real == true ) {
# Backup ntpd in /etc/sysconfig at first time run
    case "${::osfamily}-${::lsbmajdistrelease}" {
      'Suse-10', 'Suse-11': {
        exec { 'backup_sysconfig_ntp':
	  command => 'cp /etc/sysconfig/ntpd /etc/sysconfig/ntpd.ori',
          path    => '/bin:/usr/bin',
	  unless  => 'test -f /etc/sysconfig/ntpd.ori',
	}
      }
      'RedHat-5', 'RedHat-6':{
        exec { 'backup_sysconfig_ntp':
          command => 'cp /etc/sysconfig/ntpd /etc/sysconfig/ntpd.ori',
          path    => '/bin:/usr/bin',
          unless  => 'test -f /etc/sysconfig/ntpd.ori',
	}
      }
      default: {
        fail('backup_sysconfig_ntp is only supported on Suse 10&11, RHEL 5&6.')
        }
      }

# Usr workaround
    if ( $use_workaround_real == true ) {
      case "${::osfamily}-${::lsbmajdistrelease}" {
        'Suse-10', 'Suse-11': {
          exec { 'use_workaround':
            command => 'sed -i \'s/="/="-x /\' /etc/sysconfig/ntpd; /sbin/service ntp restart',
            path    => '/bin:/usr/bin',
            unless  => 'test -f /etc/sysconfig/ntpd && grep "\-x" /etc/sysconfig/ntpd',
          }
        }
	'RedHat-5', 'RedHat-6':{
          exec { 'use_workaround':
	    command => 'sed -i \'s/="/="-x /\' /etc/sysconfig/ntpd; /sbin/service ntp restart',
            path    => '/bin:/usr/bin',
            unless  => 'test -f /etc/sysconfig/ntpd && grep "\-x" /etc/sysconfig/ntpd',
	  }
	}
        default: {
          fail('use_workaround is only supported on Suse 10&11, RHEL 5&6.')
        }
      }
    }
    if ( $use_workaround_real == false ) {
      case "${::osfamily}-${::lsbmajdistrelease}" {
        'Suse-10', 'Suse-11': {
          exec { 'restore_workaround':
            command => 'sed -i \'s/="-x /="/\' /etc/sysconfig/ntpd; /sbin/service ntp restart',
            path    => '/bin:/usr/bin',
            unless  => 'test -f /etc/sysconfig/ntpd.ori && test -f /etc/sysconfig/ntpd.ori && grep "\-x " /etc/sysconfig/ntpd',
          }
        }
        'RedHat-5', 'RedHat-6':{
          exec { 'restore_workaround':
            command => 'sed -i \'s/="-x /="/\' /etc/sysconfig/ntpd; /sbin/service ntp restart',
            path    => '/bin:/usr/bin',
            onlyif  => 'test -f /etc/sysconfig/ntpd.ori && test -f /etc/sysconfig/ntpd.ori && grep "\-x " /etc/sysconfig/ntpd',
          }
        }
        default: {
          fail('restore_workaround is only supported on Suse 10&11, RHEL 5&6.')
        }
      }

    }
  }
}
