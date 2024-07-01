# up to 8th February 2024: PostgreSQL 16.2, 15.6, 14.11, 13.14, and 12.18 Released!
# https://www.postgresql.org/docs/release/
type Bsys::PGVersion =
  Pattern[/^(12\.(1[0-9]|[0-9])|13\.(1[0-5]|[0-9])|14\.(1[0-2]|[0-9])|15\.[0-7]|16\.[0-3])/]
