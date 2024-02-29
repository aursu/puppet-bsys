#!/usr/bin/env bash
# Install Yum as a task
#
# From https://github.com/puppetlabs/puppetlabs-puppet_agent/blob/main/tasks/install_shell.sh

# Timestamp
now () {
    date +'%H:%M:%S %z'
}

# Logging functions instead of echo
log () {
    echo "$(now) ${1}"
}

info () {
    log "INFO: ${1}"
}

warn () {
    log "WARN: ${1}"
}

critical () {
    log "CRIT: ${1}"
}

# Check whether a command exists - returns 0 if it does, 1 if it does not
exists() {
  if command -v $1 >/dev/null 2>&1
  then
    return 0
  else
    return 1
  fi
}

if [ -n "$PT_retry" ]; then
  retry=$PT_retry
else
  retry=5
fi

# detect yum
if exists yum >/dev/null 2>&1; then
  version=($(yum --version))
  installed_version="${version[0]}"
else
  installed_version=uninstalled
fi

# Error if non-root
if [ $(id -u) -ne 0 ]; then
  echo "bsys::install_yum task must be run as root"
  exit 1
fi

# Retrieve Platform and Platform Version
# Utilize facts implementation
if [ -f "$PT__installdir/facts/tasks/bash.sh" ]; then
  # Use facts module bash.sh implementation
  platform=$(bash $PT__installdir/facts/tasks/bash.sh "platform")
  platform_version=$(bash $PT__installdir/facts/tasks/bash.sh "release")

  # Handle CentOS
  if test "x$platform" = "xCentOS"; then
    platform="el"

  # Handle Rocky
  elif test "x$platform" = "xRocky"; then
    platform="el"

  # Handle Oracle
  elif test "x$platform" = "xOracle Linux Server"; then
    platform="el"
  elif test "x$platform" = "xOracleLinux"; then
    platform="el"

  # Handle Scientific
  elif test "x$platform" = "xScientific Linux"; then
    platform="el"
  elif test "x$platform" = "xScientific"; then
    platform="el"

  # Handle RedHat
  elif test "x$platform" = "xRedHat"; then
    platform="el"

  # Handle AlmaLinux
  elif test "x$platform" = "xAlmalinux"; then
    platform="el"
  fi
else
  echo "This module depends on the puppetlabs-facts module"
  exit 1
fi

if test "x$platform" = "x"; then
  critical "Unable to determine platform version!"
  exit 1
fi

# Mangle $platform_version to pull the correct build
# for various platforms
major_version=$(echo $platform_version | cut -d. -f1)
case $platform in
  "el")
    platform_version=$major_version
    ;;
  "Fedora")
    platform_version=$major_version;;
    ;;
  "Amzn"|"Amazon Linux")
    case $platform_version in
      "2") platform_version="7";;
    esac
    ;;
esac

if test "x$platform_version" = "x"; then
  critical "Unable to determine platform version!"
  exit 0
fi

# Run command and retry on failure
# run_cmd CMD
run_cmd() {
  eval $1
  rc=$?

  if test $rc -ne 0; then
    attempt_number=0
    while test $attempt_number -lt $retry; do
      info "Retrying... [$((attempt_number + 1))/$retry]"
      eval $1
      rc=$?

      if test $rc -eq 0; then
        break
      fi

      info "Return code: $rc"
      sleep 1s
      ((attempt_number=attempt_number+1))
    done
  fi

  return $rc
}

install_yum() {
  if test "x$installed_version" != "xuninstalled"; then
    info "Version ${installed_version} detected..."
    exit 0
  fi

  if exists dnf >/dev/null 2>&1; then
    run_cmd "dnf install -y yum"
  elif exists microdnf >/dev/null 2>&1; then
    run_cmd "microdnf install -y yum"
  fi

  if test $? -ne 0; then
    critical "Installation failed"
    exit 1
  fi
}

case $platform in
  "el")
    info "Red hat like platform! Lets get you a Yum..."
    install_yum
    ;;
  "Amzn"|"Amazon Linux")
    info "Amazon platform! Yum is already installed."
    install_yum
    ;;
  "Fedora")
    info "Fedora platform! Lets get the Yum..."
    install_yum
    ;;
  "Debian")
    info "Debian platform! It is DEB platform..."
    exit 0
    ;;
  "Linuxmint"|"LinuxMint")
    info "Mint platform! It is DEB platform..."
    exit 0
    ;;
  "Ubuntu")
    info "Ubuntu platform! It is DEB platform..."
    exit 0
    ;;
  *)
    critical "Sorry $platform is not supported yet!"
    exit 0
    ;;
esac
