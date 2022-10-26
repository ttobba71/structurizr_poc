!constant ORGANISATION_NAME "Avant"
!constant GROUP_NAME "Engineering"

workspace "Avant System Architecture" "The high level architecture of customer entry and shared managed services." {

!identifiers hierarchical

    model {
        customer = person "Customers" "Anyone who uses Avant's loan, credit card, or banking systems." "End Users"

        !include cdn
        !include kafka
        !include kong
        !include rabbit
        !include userApplications
        !include database


        // cdn = softwareSystem "Content Deliver Network" "Caches content closer to a user's location." "cdn" {
        // }
        // group "User Applications" {
        //     mobileApp = softwareSystem "Mobile Application" "IOS and Android device applications enabling customers use to access and manage Avant products and services" "mobileui" {

        //     }
        //     webSite = softwareSystem "Website Application" "HTML and Javascript website enabling customers use to access and manage Avant products and services" "webui" {

        //     }
        // }        
        // group "Messaging Solutions Confluent" {
        //     kafkaCluster = softwareSystem "Kafka Messaging" "Durable messsage queuing solution" "eventMessage,kafka" {
        //         zookeeper = container "Apache Zookeeper" "A centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services" "zk"
        //         kafka = container "Kafka Node" "A event streaming platform" "kafkaNode"

        //     }

        //     rabbitMq = softwareSystem "RabbitMQ Messaging" "Publish/Subscribe queuing solution" "eventMessage,rabbitmq" {

        //     }
        // }
        // group "Managed Database on GCP" {
        //     postgresDb = softwareSystem "Managed PostgreSQL Database" "Separate PostgreSQL instances for each service" "DB" {
        //     }
        // }

        // group "API Gateway" {
        //     kongApiGateway = softwareSystem "API Gateway Application" "Vendor agnostic solution implemented in Ngnix and Lua that filters and routes API and web traffic." "gateway" {
        //         kongManagement = container "Web Management Console" "The console used by internal resources to configure API gateway functionality" "webConsole" {
        //             kongPluginComponent = component "Plugin Architecture Components"
        //         }
        //     }

        // }

            customer -> cdn "uses mobile application with their IOS or Android device" "https vis cdn" "cdnCache"
            customer -> cdn "uses web application with Chrome, Firefox, or Safari web browser" "https via cdn" "cdnCache"

            mobileApp -> kongApiGateway "routes through" "https" "externalWeb"
            webSite -> kongApiGateway "routes through" "https" "externalWeb"
            cdn -> mobileApp  "dynamic request pass through cdn" "https" "externalWeb"
            cdn -> webSite "dynamic requests pass through cdn" "https" "externalWeb"

            // developmentEnv = deploymentEnvironment "Local Development" {
            //     deploymentNode "Developer Laptop" {
            //         containerInstance kongApiGateway.kongManagement
            //         deploymentNode "Kafka Cluster" {
            //             containerInstance kafkaCluster.zookeeper
            //             containerInstance kafkaCluster.kafka
            //         }
            //     }
            // }            

    }
    views {
        // deployment * developmentEnv {
        //     include *
        //     exclude cdn
        //     autoLayout lr
        // }
        systemlandscape "GatewayLandscape" {
            title "Shared Services and the API Gateway"
            include *
            //One must have a separate exclude or include statement for each grouping.
            exclude element.tag==kafka rabbitmq
            exclude element.tag==DB
            autoLayout
        }
        //gateway
        systemContext kongApiGateway "APIGatewayApplicationView" {
            title "API Gateway and User Facing Applications"
            include *
            autoLayout
        }
        container kongApiGateway "KongManagementConsole" {
             include *
             autoLayout
        }
        component kongApiGateway.kongManagement "KongPlugins" "The custom built and 3rd party plugins deployed in the Kong API gateway." {
             include *
             autoLayout
        }
        !include styles

    }

}