plan bsys::locale (
  TargetSpec $targets,
  String $locale = 'en_US.UTF-8',
) {
  run_plan('facts', 'targets' => $targets)
  run_task('bsys::apt_update', $targets)

  return apply($targets) {
    bsys::locale { $locale: }
  }
}
