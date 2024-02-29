# @summary Install package if ensure is set.
#
# A defined type to manage package installations with support for corporate
# repositories and OS-specific configurations.
#
# @example Using a corporate repository
#   bsys::tools::package { 'git':
#     ensure              => 'latest',
#     corporate_repo      => 'corporate-repo',
#     corporate_repo_only => true,
#   }
#
# @param package_name The name of the package to be installed.
# @param ensure The version of the package to ensure is installed. Can be 'present',
#               'absent', 'latest', or a specific version.
#               If undefined, the package is not managed.
# @param corporate_repo Specifies the corporate repository or repositories to
#               use for the package installation. Can be a string or an array
#               of strings.
# @param corporate_repo_only If true, only the corporate repository(ies) will
#               be used for installation. If false, the corporate repository(ies)
#               will be added to the list of enabled repositories.
#
define bsys::tools::package (
  String $package_name = $name,
  Optional[Bsys::PackageVersion] $ensure = undef,
  Optional[
    Variant[
      String,
      Array[String]
    ]
  ] $corporate_repo = undef,
  Boolean $corporate_repo_only = true,
) {
  include bsys::params

  if $bsys::params::redhat and $corporate_repo {
    $corporate_repo_list = $corporate_repo ? {
      String  => [$corporate_repo],
      default => $corporate_repo,
    }
    $package_provider = $bsys::params::package_provider

    if $package_provider == 'dnf' {
      if $corporate_repo_only {
        $package_install_options = $corporate_repo_list.reduce([]) |$memo, $repo| { $memo + ['--repo', $repo] }
      }
      else {
        $package_install_options = $corporate_repo_list.reduce([]) |$memo, $repo| { $memo + ['--enablerepo', $repo] }
      }
    }
    else {
      $enabled_repos = $corporate_repo_list.reduce([]) |$memo, $repo| { $memo + ['--enablerepo', $repo] }
      if $corporate_repo_only {
        $package_install_options = ['--disablerepo', '*'] + $enabled_repos
      }
      else {
        $package_install_options = $enabled_repos
      }
    }
  }
  else {
    $package_install_options = []
    $package_provider = undef
  }

  if $ensure {
    $package_ensure = $ensure ? {
      String  => $ensure,
      default => 'installed',
    }

    package { $package_name:
      ensure          => $package_ensure,
      provider        => $package_provider,
      install_options => $package_install_options,
    }
  }
}
