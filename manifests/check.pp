# @summary
#   Adds a Monit check.
#
# @param content
#   Specifies the content of the configuration file. The `content` and `source` parameters are exclusive of each other.
#
# @param ensure
#   Tells Puppet whether the check should exist.
#
# @param source
#   Tells Puppet what is the path of the configuration file. The `content` and `source` parameters are exclusive of each other.
#
define monit::check (
  Optional[String]          $content = undef,
  Enum['present', 'absent'] $ensure  = present,
  Optional[String]          $source  = undef,
) {
  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['monit']) {
    fail('You must include the monit base class before using any monit defined resources')
  }

  # <variable validations>
  if $source and $content {
    fail 'Parameters source and content are mutually exclusive'
  }
  # </variable validations>

  file { "${::monit::config_dir}/${name}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => $source,
    content => $content,
    require => Package['monit'],
    notify  => Service['monit'],
  }
}
