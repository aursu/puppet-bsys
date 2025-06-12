# up to 8th February 2024: PostgreSQL 16.2, 15.6, 14.11, 13.14, and 12.18 Released!
# https://www.postgresql.org/docs/release/
type Bsys::PGVersion =
  Pattern[/^(13\.(2[01]|1?[0-9])|14\.(1[0-8]|[0-9])|15\.(1[0-3]|[0-9])|16\.[0-9]|17\.[0-5])/]
