<<<<<<< HEAD
# mini-lakehouse-aws-glue-snowflake
=======
\# Mini Lakehouse (AWS + Glue/Spark + optional Snowflake)



Goal: practice building a small but realistic data platform:

\*\*Postgres (RDS) → S3 (raw) → Glue PySpark (curated) → (Athena or Snowflake) → metrics\*\*



\## Architecture

(put diagram here later)



\## Stack

\- Source DB: Postgres (local Docker first, optional RDS later)

\- Storage: S3

\- Transform: AWS Glue (PySpark)

\- Catalog: Glue Data Catalog (Crawler)

\- Optional warehouse: Snowflake



\## Repo structure

\- infra/        IaC (Terraform)

\- src/lambda/   incremental extract DB → S3

\- src/glue/     Glue PySpark job raw → curated

\- sql/          schema + seed + optional Snowflake SQL

\- scripts/      deploy/teardown helpers

\- docs/         notes, screenshots, architecture



\## Milestones

\- \[ ] Step 1: define schema + generate seed data

\- \[ ] Step 2: land raw tables into S3 (incremental)

\- \[ ] Step 3: Glue crawler + catalog

\- \[ ] Step 4: Glue PySpark job → curated zone

\- \[ ] Step 5: query curated (Athena) or load to Snowflake

\- \[ ] Step 6: produce 2–3 metrics tables + definitions



\## Cost safety

\- Always tear down AWS resources after tests.

\- Keep datasets small.

\- Use minimal Glue workers and run jobs only when needed.

>>>>>>> cba7590 (Step 0: repo base)
