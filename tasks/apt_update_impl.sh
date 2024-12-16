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

# Error if non-root
if [ $(id -u) -ne 0 ]; then
  critical "bsys::apt_update task must be run as root"
  exit 1
fi

platform=
# Retrieve Platform and Platform Version
# Utilize facts implementation
if [ -f "$PT__installdir/facts/tasks/bash.sh" ]; then
  # Use facts module bash.sh implementation
  platform=$(bash $PT__installdir/facts/tasks/bash.sh "platform")
else
  critical "This module depends on the puppetlabs-facts module"
  exit 1
fi

if test "x$platform" = "x"; then
  critical "Unable to determine platform version!"
  exit 1
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

apt_update() {
  run_cmd "apt-get update"

  if test $? -ne 0; then
    critical "apt-get update failed"
    exit 1
  fi
}

case $platform in
  "Ubuntu"|"Debian")
    apt_update
    ;;
  *)
    exit 0
    ;;
esac
