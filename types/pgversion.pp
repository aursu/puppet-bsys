# up to August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
# https://www.postgresql.org/docs/release/
type Bsys::PGVersion =
  Pattern[/^(1[4-7]\.[0-9]|14\.(2[0-4]|1[0-9])|15\.1[0-9]|16\.1[0-5]|17\.1[0-1]|18\.[0-6])/]
