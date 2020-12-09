# monit

[![Puppet Forge Version](http://img.shields.io/puppetforge/v/soli/monit)](https://forge.puppetlabs.com/soli/monit)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/soli/monit)](https://forge.puppetlabs.com/soli/monit)
[![Puppet Forge feedback score](https://img.shields.io/puppetforge/f/soli/monit)](https://forge.puppetlabs.com/soli/monit)
[![Puppet Forge endorsement](https://img.shields.io/puppetforge/e/soli/monit)](https://forge.puppetlabs.com/soli/monit)
[![Build Status](https://travis-ci.com/solution-libre/puppet-monit.svg?branch=master)](https://travis-ci.com/solution-libre/puppet-monit)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with monit](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with monit](#beginning-with-monit)
3. [Usage - Configuration options and additional functionality](#usage)
    * [Enable Monit Dashboard](#enable-monit-dashboard)
    * [Add a check](#add-a-check)
    * [Remove a check](#remove-a-check)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors](#contributors)

## Module Description

This module installs and configures [Monit](http://mmonit.com/monit/).
It allows you to enable HTTP Dashboard an to add check from a file.

## Setup

### Setup Requirements

**WARNING:** For RedHat systems, you may need to add an additional repository like the [EPEL repository](http://fedoraproject.org/wiki/EPEL).
You can use the module [stahnma-epel](https://forge.puppetlabs.com/stahnma/epel) to do this.

### Beginning with monit

```puppet
include ::monit
```

## Usage

### Enable Monit Dashboard

```puppet
class { 'monit':
  httpd          => true,
  httpd_address  => '172.16.0.3',
  httpd_password => 'CHANGE_ME',
}
```

### Add a check

Using the source parameter:

```puppet
monit::check { 'ntp':
  source => "puppet:///modules/${module_name}/ntp",
}
```

Or using the content parameter with a string:

```puppet
monit::check { 'ntp':
  content => 'check process ntpd with pidfile /var/run/ntpd.pid
  start program = "/etc/init.d/ntpd start"
  stop  program = "/etc/init.d/ntpd stop"
  if failed host 127.0.0.1 port 123 type udp then alert
  if 5 restarts within 5 cycles then timeout
',
}
```

Or using the content parameter with a template:

```puppet
monit::check { 'ntp':
  content => template("${module_name}/ntp.erb"),
}
```

### Remove a check

```puppet
monit::check { 'ntp':
  ensure => absent,
}
```

## Reference

See [REFERENCE.md](https://github.com/solution-libre/puppet-monit/blob/master/REFERENCE.md)

## Limitations

RedHat and Debian family OSes are officially supported. Tested and built on Debian and CentOS.

## Development

[Solution Libre](https://www.solution-libre.fr) modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great.


[Fork this module on GitHub](https://github.com/solution-libre/puppet-monit/fork)

## Contributors

The list of contributors can be found at: https://github.com/solution-libre/puppet-monit/graphs/contributors
