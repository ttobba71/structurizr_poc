    group "Managed Database on GCP" {
        postgresDb = softwareSystem "Managed PostgreSQL Database" "Separate PostgreSQL instances for each service" "DB" {
        }
    }