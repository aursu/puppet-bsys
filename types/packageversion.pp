type Bsys::PackageVersion = Variant[
  Boolean,
  Pattern[/^[0-9]+/],
  Bsys::Ensure::Package,
]
