# @summary NodeJS system parameters
#
# NodeJS system parameters
#
# @example
#   include bsys::nodejs::params
class bsys::nodejs::params {
  # NodeJS
  # RUN groupadd -g 1000 node \
  # && useradd -u 1000 -g node -s /bin/bash -m node
  $user     = 'node'
  $user_id  = 1000

  $group    = 'node'
  $group_id = 1000

  $user_shell = '/bin/bash'
}
