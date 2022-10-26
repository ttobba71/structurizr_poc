!constant ORGANISATION_NAME "Avant"
!constant GROUP_NAME "Engineering"

workspace "Avant System Architecture" "The high level architecture of customer entry and shared managed services." {

!identifiers hierarchical

    model {

        !include customer
        !include cdn
        !include kafka
        !include kong
        !include rabbit
        !include userApplications
        !include database


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