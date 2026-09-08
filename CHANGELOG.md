# Changelog

All notable changes to this project will be documented in this file.

## Release 0.12.0

**Features**

* New function **`bsys::is_private_ip($address, $include_loopback = false)`** - whether an address is in private, non-routable space. Written for deciding what a service may bind to or be reached on. Ranges are compared with Ruby's `IPAddr` rather than string prefixes, because prefix matching gets `172.16.0.0/12` wrong: a check for `172.` also accepts `172.0`-`172.15` and `172.32`-`172.255`, which are public address space. Covers RFC 1918 for IPv4 and RFC 4193 unique local addresses (`fc00::/7`) for IPv6. Loopback is opt-in via the second argument - it is private in the sense of unreachable, but a service told to bind it is usually a mistake, so a caller that means it has to say so. Deliberately **not** treated as private: `169.254.0.0/16` and `fe80::/10` (link-local, which is what you get when DHCP failed) and `100.64.0.0/10` (RFC 6598 carrier NAT, the provider's space rather than yours). An address that cannot be parsed raises rather than returning false, because answering "not private" for a typo would let it through the very check meant to catch it.

## Release 0.11.7

**Features**

* Updated PostgreSQL version type to support latest available versions as of August 13, 2026
* Added support for PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24

**Bugfixes**

**Known Issues**

* PostgreSQL 13 is no longer accepted by `Bsys::PGVersion` (upstream end-of-life on November 13, 2025)

## Release 0.11.6

**Features**

* Added `bsys::copy_fail` class for immediate mitigation of CVE-2026-31431 by blacklisting and unloading the `algif_aead` kernel module

**Bugfixes**

**Known Issues**

## Release 0.11.5

**Features**

* Updated PostgreSQL version type to support latest available versions as of February 16, 2026
* Added support for PostgreSQL 18.2, 17.8, 16.12, 15.16, 14.21, 13.23

**Bugfixes**

**Known Issues**

## Release 0.11.4

**Features**

* Updated PostgreSQL version type to support latest available versions as of August 14, 2025
* Added support for PostgreSQL 17.6, 16.10, 15.14, 14.19, 13.22

**Bugfixes**

**Known Issues**

## Release 0.1.0

**Features**

* Added `bsys::repo` class to update Yum/Apt cache

**Bugfixes**

**Known Issues**

## Release 0.2.0

**Features**

* Added `bsys::systemctl::daemon_reload` to reload systemd config

**Bugfixes**

**Known Issues**

## Release 0.3.1

**Features**

* Added `certbase` and `keybase` into params

**Bugfixes**

**Known Issues**

## Release 0.4.1

**Features**

* Added common parameters for Web servers
* Added `pkibase` parameter

**Bugfixes**

**Known Issues**

## Release 0.5.0

**Features**

* Added EPEL repository for RedHat based systems

**Bugfixes**

**Known Issues**

## Release 0.6.0

**Features**

* Added bsys::tools::package in order to use corporate repos

**Bugfixes**

**Known Issues**

## Release 0.6.1

**Features**

* Added `bsys::tools::yum` to install yum package on RedHat 8+
* Added Rocky Linux 9

**Bugfixes**

**Known Issues**

## Release 0.6.2

**Features**

* Added Bolt task `bsys::install_yum` to install yum package on RedHat 8+

**Bugfixes**

**Known Issues**

## Release 0.6.3

**Features**

* Updated PostgreSQL to the latest version as of 8th February 2024

**Bugfixes**

**Known Issues**

## Release 0.7.0

**Features**

* Added class `bsys::timezone` to manage TimeZone settings on OS
* Added Bsys::Unixpath type which allow only Unix like absolute paths

**Bugfixes**

**Known Issues**

## Release 0.7.1

**Features**

* Updated PostgreSQL to the latest version as of 1st July 2024
* PDK upgrade

**Bugfixes**

**Known Issues**

## Release 0.7.2

**Features**

* Updated PostgreSQL to the latest version as of 13th September 2024

**Bugfixes**

**Known Issues**

## Release 0.8.0

**Features**

* Added /etc/login.defs management

**Bugfixes**

**Known Issues**

## Release 0.9.0

**Features**

* Added NodeJS ownership resources

**Bugfixes**

**Known Issues**

## Release 0.10.3

**Features**

* Added more /etc/login.defs parameters
* Added PostgreSQL 17.2 to the latest version as of 13th December 2024
* Added irqbalance daemon management

**Bugfixes**

**Known Issues**

## Release 0.11.1

**Features**

* Added Bolt task `bsys::apt_update`
* Added Bolt plan `bsys::locale`
* Added class `bsys::locale` to generate locale.

**Bugfixes**

**Known Issues**

## Release 0.11.2

**Features**

* Added PostgreSQL 17.4 and other latest available version as of 27th March 2025

**Bugfixes**

**Known Issues**

## Release 0.11.3

**Features**

* Added PostgreSQL latest available versions as of 12th June 2025

**Bugfixes**

**Known Issues**
