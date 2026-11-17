# up to November 13, 2026: PostgreSQL 19 RC 2, 18.7, 17.12, 16.16, 15.20 and 14.25 Released!
# https://www.postgresql.org/docs/release/
type Bsys::PGVersion =
  Pattern[/^(1[4-7]\.[0-9]|14\.(2[0-5]|1[0-9])|15\.(1[0-9]|20)|16\.1[0-6]|17\.1[0-2]|18\.[0-7])/]
