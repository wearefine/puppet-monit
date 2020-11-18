# @summary
#   Main class, includes all other classes.
#
# @example
#   class { 'monit': }
#
# @param alert_emails
#   Specifies one or more email addresses to send global alerts to. Default value: []
#
# @param check_interval
#   Specifies the interval between two checks of Monit. Default value: 120
#
# @param config_file
#   Specifies a path to the main config file. Default value: varies with operating system
#
# @param config_dir
#   Specifies a path to the config directory. Default value: varies with operating system
#
# @param config_dir_purge
#   Specifies if unmanaged files in the config directory should be purged. Default value: 'false'
#
# @param httpd
#   Specifies whether to enable the Monit Dashboard. Default value: 'false'
#
# @param httpd_port
#   Specifies the port of the Monit Dashboard. Default value: 2812
#
# @param httpd_address
#   Specifies the IP address of the Monit Dashboard. Default value: 'locahost'
#
# @param httpd_allow
#   Specifies the allow option of the Monit Dashboard. Default value: '0.0.0.0/0.0.0.0'
#
# @param httpd_user
#   Specifies the user to access the Monit Dashboard. Default value: 'admin'
#
# @param httpd_password
#   Specifies the password to access the Monit Dashboard. Default value: 'monit'
#
# @param logfile
#   Specifies the logfile directive value. Default value: '/var/log/monit.log'
#   It is possible to use syslog instead of direct file logging. (e.g. 'syslog facility log\_daemon')
#
# @param mailserver
#   If set to a string, alerts will be sent by email to this mailserver. Default value: undef
#   For more details, see: https://mmonit.com/monit/documentation/monit.html#Setting-a-mail-server-for-alert-delivery
#
# @param mailformat
#   Specifies the alert message format. Default value: undef
#   For more details, see: https://mmonit.com/monit/documentation/monit.html#Message-format
#
# @param manage_firewall
#   If true and if puppetlabs-firewall module is present, Puppet manages firewall to allow HTTP access for Monit Dashboard.
#   Default value: 'false'
#
# @param mmonit_address
#   *Requires at least Monit 5.0*<br />
#   Specifies the remote address of an M/Monit server to be used by Monit agent for report. If set to undef, M/Monit connection is disabled.
#   Default value: undef
#
# @param mmonit_https
#   *Requires at least Monit 5.0*<br />
#   Specifies wheither the protocol of the M/Monit server is HTTPs. Default value: 'true'
#
# @param mmonit_port
#   *Requires at least Monit 5.0*<br />
#   Specifies the remote port of the M/Monit server. Default value: 8443
#
# @param mmonit_user
#   *Requires at least Monit 5.0*<br />
#   Specifies the user to connect to the remote M/Monit server. Default value: 'monit'
#   If you set both user and password to an empty string, authentication is disabled.
#
# @param mmonit_password
#   *Requires at least Monit 5.0*<br />
#   Specifies the password of the account used to connect to the remote M/Monit server. Default value: 'monit'
#   If you set both user and password to an empty string, authentication is disabled.
#
# @param mmonit_without_credential
#   *Requires at least Monit 5.0*<br />
#   By default Monit registers credentials with M/Monit so M/Monit can smoothly communicate back to Monit and you don't have to register
#   Monit credentials manually in M/Monit. It is possible to disable credential registration setting this option to 'true'.
#   Default value: 'false'
#
# @param package_ensure
#   Tells Puppet whether the Monit package should be installed, and what version.
#   Valid options: 'present', 'latest', or a specific version number.
#   Default value: 'present'
#
# @param package_name
#   Tells Puppet what Monit package to manage. Default value: 'monit'
#
# @param service_ensure
#   Tells Puppet whether the Monit service should be running. Default value: 'running'
#
# @param service_manage
#   Tells Puppet whether to manage the Monit service. Default value: 'true'
#
# @param service_name
#   Tells Puppet what Monit service to manage. Default value: 'monit'
#
# @param start_delay *Requires at least Monit 5.0*
#   If set, Monit will wait the specified time in seconds before it starts checking services. Default value: 0
#
class monit (
  Array[String]                           $alert_emails              = $monit::params::alert_emails,
  Integer[0]                              $check_interval            = $monit::params::check_interval,
  String                                  $config_file               = $monit::params::config_file,
  String                                  $config_dir                = $monit::params::config_dir,
  Variant[Boolean, Enum['true', 'false']] $config_dir_purge          = $monit::params::config_dir_purge,
  Variant[Boolean, Enum['true', 'false']] $httpd                     = $monit::params::httpd,
  Integer[0, 65535]                       $httpd_port                = $monit::params::httpd_port,
  String                                  $httpd_address             = $monit::params::httpd_address,
  String                                  $httpd_allow               = $monit::params::httpd_allow,
  String                                  $httpd_user                = $monit::params::httpd_user,
  String                                  $httpd_password            = $monit::params::httpd_password,
  Optional[String]                        $logfile                   = $monit::params::logfile,
  Optional[String]                        $mailserver                = $monit::params::mailserver,
  Optional[Hash]                          $mailformat                = $monit::params::mailformat,
  Variant[Boolean, Enum['true', 'false']] $manage_firewall           = $monit::params::manage_firewall,
  Optional[String]                        $mmonit_address            = $monit::params::mmonit_address,
  Variant[Boolean, Enum['true', 'false']] $mmonit_https              = $monit::params::mmonit_https,
  Integer[0, 65535]                       $mmonit_port               = $monit::params::mmonit_port,
  String                                  $mmonit_user               = $monit::params::mmonit_user,
  String                                  $mmonit_password           = $monit::params::mmonit_password,
  Variant[Boolean, Enum['true', 'false']] $mmonit_without_credential = $monit::params::mmonit_without_credential,
  String                                  $package_ensure            = $monit::params::package_ensure,
  String                                  $package_name              = $monit::params::package_name,
  Variant[Boolean, Enum['true', 'false']] $service_enable            = $monit::params::service_enable,
  Enum['running', 'stopped']              $service_ensure            = $monit::params::service_ensure,
  Variant[Boolean, Enum['true', 'false']] $service_manage            = $monit::params::service_manage,
  String                                  $service_name              = $monit::params::service_name,
  Integer[0]                              $start_delay               = $monit::params::start_delay,
) inherits monit::params {
  # <stringified variable handling>
  if is_string($httpd) == true {
    $httpd_bool = str2bool($httpd)
  } else {
    $httpd_bool = $httpd
  }

  if is_string($manage_firewall) == true {
    $manage_firewall_bool = str2bool($manage_firewall)
  } else {
    $manage_firewall_bool = $manage_firewall
  }

  if is_string($service_enable) == true {
    $service_enable_bool = str2bool($service_enable)
  } else {
    $service_enable_bool = $service_enable
  }

  if is_string($service_manage) == true {
    $service_manage_bool = str2bool($service_manage)
  } else {
    $service_manage_bool = $service_manage
  }

  if is_string($mmonit_https) == true {
    $mmonit_https_bool = str2bool($mmonit_https)
  } else {
    $mmonit_https_bool = $mmonit_https
  }

  if is_string($mmonit_without_credential) == true {
    $mmonit_without_credential_bool = str2bool($mmonit_without_credential)
  } else {
    $mmonit_without_credential_bool = $mmonit_without_credential
  }

  if is_string($config_dir_purge) == true {
    $config_dir_purge_bool = str2bool($config_dir_purge)
  } else {
    $config_dir_purge_bool = $config_dir_purge
  }
  # </stringified variable handling>

  # <variable validations>
  validate_absolute_path($config_file)
  validate_absolute_path($config_dir)

  if $logfile and !($logfile =~ /^syslog(\s+facility\s+log_(local[0-7]|daemon))?/) {
    validate_absolute_path($logfile)
  }
  # </variable validations>

  # Use the monit_version fact if available, else use the default for the
  # platform.
  if defined('$::monit_version') and $::monit_version {
    $monit_version_real = $::monit_version
  } else {
    $monit_version_real = $monit::params::monit_version
  }

  if($start_delay + 0 > 0 and versioncmp($monit_version_real,'5') < 0) {
    fail("start_delay requires at least Monit 5.0. Detected version is <${monit_version_real}>.")
  }

  anchor { "${module_name}::begin": }
  -> class { "${module_name}::install": }
  -> class { "${module_name}::config": }
  ~> class { "${module_name}::service": }
  -> class { "${module_name}::firewall": }
  -> anchor { "${module_name}::end": }
}
