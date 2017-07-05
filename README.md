# duo_unix Puppet v3 Module (Inactive)

## Table of Contents

### [Overview](#overview-1)
### [Description](#description-1)
### [Installing](#installing-1)
### [Configuring](#configuring-1)
### [Reference](#reference-1)
### [Limitations](#limitations-1)

## Overview

The duo_unix Puppet module installs and manages duo_unix (`login_duo` or `pam_duo`).

## Description

The duo_unix module handles the deployment of duo_unix (`login_duo` or 
`pam_duo`) across a range of Linux distributions. The module will handle 
repository dependencies, installation of the duo_unix package, configuration 
of OpenSSH, and PAM alterations as needed.

For further information about duo_unix, view the official
[documentation](https://www.duosecurity.com/docs/duounix).

## Installing

```sh
puppet module install duosecurity-duo_unix
```

## Configuring

```ruby
# duo_unix.pp
class { 'duo_unix':
  usage     => 'login',
  ikey      => 'YOUR-IKEY-VALUE',
  skey      => 'YOUR-SKEY-VALUE',
  host      => 'YOUR-HOST-VALUE',
  pushinfo  => 'yes'
}
```

```sh
puppet apply duo_unix.pp
```

## Reference

### Classes

* `duo_unix` - Main class, includes all of the rest
* `duo_unix::apt` - Repository configuration for Apt-based distributions
* `duo_unix::generic` - Provides cross-platform resources
* `duo_unix::login` - Configuration of `login_duo` functionality
* `duo_unix::pam` - Configuration of `pam_duo` functionality
* `duo_unix::yum` - Repository configuration for Yum-based distributions

### Parameters

The following parameters are available to configure in the duo_unix module.
Please note that many parameters have default settings and some are required
while others are optional.

#### `usage [required]`
  This determines whether `login_duo` or `pam_duo` is utilized. Valid options are
  *login* or *pam*.

#### `ikey [required]`
  Configures the integration key (*ikey*) value.

#### `skey [required]`
  Configures the secret key (*skey*) value.

#### `host [required]`
  Configures the API host (*host*) value.

#### `fallback_local_ip [optional]`
  Configures whether or not to fallback to the server's IP. Valid options are 
  *yes* and *no*. The default is *no*.

#### `failmode [optional]`
  Configures how to fail if the Duo service is misconfigured. Valid options are 
  *safe* (open) and *secure* (closed). The default is *safe*.

#### `pushinfo [optional]`
  Configures whether to show command execution details in the push notification.
  Valid options are *yes* and *no*. The default is *no*.

#### `autopush [optional]`
  Configures whether to send a push automatically to a user if their phone is 
  capable. Valid options are *yes* and *no*. The default is *no*.

#### `prompts [optional]`
  Configures the number of times a user will be prompted to complete their second
  factor authentication. Valid options are *1*, *2*, and *3*. The default is *3*.

#### `accept_env_factor [optional]`
  Configures whether an environment variable can be configured with a passcode to
  complete the second factor authentication. Valid options are *yes* and *no*.
  The default is *no*.

#### `motd [optional]`
  Configures if a successful login will print `/etc/motd` to the user. This is
  only an option for `login_duo`. Valid options are *yes* and *no*. The default
  is *no*.

#### `group [optional]`
  Configures a Unix group that will have duo_unix enabled for the associated
  users. There is no default for this setting.

#### `http_proxy [optional]`
  Configures usage of the http_proxy environment variable. There is not default
  for this setting.

#### `manage_ssh [optional]`
  Configures whether or not to allow the module to manage the SSH service/package. 
  The default is *true*.

#### `manage_pam [optinal]`
  Configures whether or not to allow the module to manage the system PAM configuration.
  The default is *true*.

#### `pam_unix_control [optional]`
  Configures the PAM control value for pam_duo. The default is *requisite*.

#### `package_version [optional]`
  Configure which version of Duo Unix to use.
  The default is *latest*.

## Support and Limitations

This module built on and tested against Puppet 3.2.4. It does not yet support 
Puppet 4 and is no longer being actively developed. Duo continues to provide 
best-effort support for this module.

The module has been tested on:

* RedHat Enterprise Linux 6.4 (32/64-bit)
* RedHat Enterprise Linux 7.0 (64-bit)
* CentOS 5.11 (32/64-bit)
* CentOS 6.7 (32/64-bit)
* CentOS 7.1 (64-bit)
* Debian 6.0.10 (32/64-bit)
* Debian 7.9 (32/64-bit)
* Debian 8.2 (32/64-bit)
* Ubuntu 12.04.5 (32/64-bit)
* Ubuntu 14.04.3 (32/64-bit)

If you test the module on other Linux distributions (or different versions of 
the above), please provide feedback as able on successes or failures. 

**Caution:** The use of this module will edit OpenSSH and/or PAM configuration 
files depending on the usage defined. These modifications have only been tested
against default distribution configurations and could impact your settings. Be 
sure to test this module against non-production systems before attempting to 
deploy it across your critical infrastucture.

## Thanks
* Gregg Leventhal
* level99
* Denise Stockman
* Dan Cox
* Mark Stanislav
