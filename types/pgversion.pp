# up to August 14, 2025: PostgreSQL 17.6, 16.10, 15.14, 14.19, 13.22 Released!
# https://www.postgresql.org/docs/release/
type Bsys::PGVersion =
  Pattern[/^(13\.(2[0-2]|1?[0-9])|14\.(1?[0-9])|15\.(1[0-4]|[0-9])|16\.(10|[0-9])|17\.[0-6])/]
