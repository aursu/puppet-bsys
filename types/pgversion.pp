# up to February 16, 2026: PostgreSQL 18.2, 17.8, 16.12, 15.16, 14.21, 13.23 Released!
# https://www.postgresql.org/docs/release/
type Bsys::PGVersion =
  Pattern[/^(1[3-6]\.[0-9]|13\.(2[0-3]|1[0-9])|14\.(2[0-1]|1[0-9])|15\.1[0-6]|16\.1[0-2]|17\.[0-8]|18\.[0-2])/]
