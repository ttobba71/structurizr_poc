workspace "Account Opening" extends https://raw.githubusercontent.com/ttobba71/structurizr_poc/main/digital-services/gateway/workspace.dsl{

    model {
        group "Account Opening" {
            aoDomain = softwareSystem "Account Opening Domain API" "Abstraction layer that's familiar with all account opening data sources.  Only exposes an Avant contract." "domainService" {
                aoService = container "Account Opeining API" "Service exposing account opening model attributes." "serviceApi" {
                    group "FastAPI Web Container" {
                    }
                }
            }
        }
        kongApiGateway -> aoDomain "route to account opening domain service" "https" "internalWeb"
        aoDomain ->  postgresDb "persists data" "ORM" "pdb"
        aoService -> kafkaCluster "produces messages" "avro" "qmsg"
        kafkaCluster -> aoService "consumes messages" "avro" "qmsg"

    }

    views {
        //Account Opening (AO)
        systemContext aoDomain "AccountOpeningDomain" {
             include *
             autoLayout lr
        }
        container aoDomain "AccountOpeningApi" {
             include *
             autoLayout lr
        }
        component aoService "AccountOpeningModels" "The models supported in this service" {
             include * 
             autoLayout lr
        }
    }

}