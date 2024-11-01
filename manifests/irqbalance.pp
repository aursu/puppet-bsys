# @summary Manages the irqbalance daemon based on system type (virtual or non-virtual).
#
# The irqbalance daemon is designed to distribute hardware interrupts across multiple CPUs
# in a way that improves overall system performance. This is particularly important for
# optimizing real-time performance, as it can help balance the load and reduce latency
# by preventing individual CPUs from being overloaded with interrupt processing tasks.
# However, in real-time or low-latency workloads, disabling irqbalance or configuring
# interrupts manually may be more effective, depending on the specific system and workload
# requirements.
#
# This class allows for automated management of irqbalance based on whether the system is
# virtual or non-virtual, as well as specific parameters that control whether the daemon
# should be enabled, disabled, or removed entirely.
#
# See documentation for details:
#   https://docs.redhat.com/en/documentation/red_hat_enterprise_linux_for_real_time/9/html/optimizing_rhel_9_for_real_time_for_low_latency_operation/assembly_binding-interrupts-and-processes_optimizing-rhel9-for-real-time-for-low-latency-operation
#
# @param manage_service
#   Boolean. If set to true, manages the irqbalance package and service.
#
# @param disable_service
#   Boolean. If set to true, disables and removes the irqbalance service on all systems,
#   including non-virtual ones.
#
# @example Default behavior (no management of irqbalance)
#   include bsys::irqbalance
#
# @example Manage irqbalance on non-virtual systems, removing it on virtual systems
#   class { 'bsys::irqbalance':
#     manage_service => true,
#   }
#
# @example Disable irqbalance on all systems
#   class { 'bsys::irqbalance':
#     manage_service   => true,
#     disable_service  => true,
#   }
class bsys::irqbalance (
  Boolean $manage_service = false,
  Boolean $disable_service = false,
) {
  # Determine if the system is virtual
  $is_virtual = $facts['is_virtual']

  # Logic for managing irqbalance package and service
  if $manage_service {
    if $disable_service or $is_virtual {
      # For virtual systems and when disable_service is true:
      # - Ensure the irqbalance package is absent
      # - Stop and disable the irqbalance service
      package { 'irqbalance':
        ensure => absent,
      }

      service { 'irqbalance':
        ensure => stopped,
        enable => false,
        before => Package['irqbalance'],
      }
    } else {
      # For non-virtual systems when disable_service is false:
      # - Ensure the irqbalance package is present
      # - Start and enable the irqbalance service
      package { 'irqbalance':
        ensure => present,
      }

      service { 'irqbalance':
        ensure  => running,
        enable  => true,
        require => Package['irqbalance'],
      }
    }
  }
}
