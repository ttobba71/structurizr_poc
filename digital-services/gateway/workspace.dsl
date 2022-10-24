workspace "API Gateway" {

    model {
        customer = person "Customers" "Anyone who uses Avant's loan, credit card, or banking systems." "End Users"
        cdn = softwareSystem "Content Deliver Network" "Caches content closer to a user's location." "cdn" {
        }
        group "User Applications" {
            mobileApp = softwareSystem "Mobile Application" "IOS and Android device applications enabling customers use to access and manage Avant products and services" "mobileui" {

            }
            webSite = softwareSystem "Website Application" "HTML and Javascript website enabling customers use to access and manage Avant products and services" "webui" {

            }
        }        
        group "Messaging Solutions Confluent" {
            kafkaCluster = softwareSystem "Kafka Messaging" "Durable messsage queuing solution" "eventMessage,kafka" {

            }

            rabbitMq = softwareSystem "RabbitMQ Messaging" "Publish/Subscribe queuing solution" "eventMessage,rabbitmq" {

            }
        }
        group "Managed Database on GCP" {
            postgresDb = softwareSystem "Managed PostgreSQL Database" "Separate PostgreSQL instances for each service" "DB" {
            }
        }


        enterprise "Avant" {
            group "API Gateway" {
                kongApiGateway = softwareSystem "API Gateway Application" "Vendor agnostic solution implemented in Ngnix and Lua that filters and routes API and web traffic." "gateway" {
                    kongManagement = container "Web Management Console" "The console used by internal resources to configure API gateway functionality" "webConsole" {
                       kongPluginComponent = component "Plugin Architecture Components"
                    }
                }

            }
        }
            customer -> cdn "uses mobile application with their IOS or Android device" "https vis cdn" "cdnCache"
            customer -> cdn "uses web application with Chrome, Firefox, or Safari web browser" "https via cdn" "cdnCache"

            mobileApp -> kongApiGateway "routes through" "https" "externalWeb"
            webSite -> kongApiGateway "routes through" "https" "externalWeb"
            cdn -> mobileApp  "dynamic request pass through cdn" "https" "externalWeb"
            cdn -> webSite "dynamic requests pass through cdn" "https" "externalWeb"

    }

    views {
        systemlandscape "GatewayLandscape" {
            include *
            //One must have a separate exclude or include statement for each grouping.
            exclude element.tag==kafka rabbitmq
            exclude element.tag==DB
            autoLayout
        }
        //gateway
        systemContext kongApiGateway "APIGatewayApplicationView" {
             include *
             autoLayout
        }
        container kongApiGateway "KongManagementConsole" {
             include *
             autoLayout
        }
        component kongManagement "KongPlugins" "The custom built and 3rd party plugins deployed in the Kong API gateway." {
             include *
             autoLayout
        }

                styles {
            element "partnerService"{
                shape RoundedBox                
                fontSize 24
                background #5f9ea0
            }
            element "partnerServiceApi"{
                shape RoundedBox                
                fontSize 24                
                background  #5f9ea0             
            }

            element "domainService"{
                shape RoundedBox                
                fontSize 24
            }
            element "serviceApi"{
                shape RoundedBox                
                fontSize 24                
            }
            element "gateway" {
                shape RoundedBox                
                fontSize 24
                background  #fafad2             
            }
            element "monolith" {
                shape RoundedBox                
                fontSize 24                
                background #ff8c00
            }
            element "eventMessage"{
                shape RoundedBox                
                fontSize 24                
            }
            element "Person" {
                color #ffffff
                background #4EC5F1
                fontSize 16
                shape Person
            }
            relationship "cdnCache"{
                style dotted
                color #6495ed
                routing Curved
            }
            relationship "rpc"{
                style dotted
                routing Curved
                fontSize 16                
            }
            relationship "orm"{
                style dotted
                routing Curved
                color #6495ed
                fontSize 16                
            }
            element "cdn" {
                shape Circle
                height 350
                width 350
                fontSize 16                
            }
            element "mobileui" {
                shape RoundedBox
                background #3386B3
                height 250
                width 450
                fontSize 16                
            }
            element "webui" {
                shape RoundedBox
                background #3386B3
                height 250
                width 450
                fontSize 16                
            }
            element "DB" {
                shape Cylinder
                background #deb887
                fontSize 16                
            }
            element "redis" {
                background #228b22
                shape Hexagon
                fontSize 16                
            }
            element "Container" {
                shape RoundedBox
                fontSize 16                
            }
            element "Component" {
                shape RoundedBox
                fontSize 16                
            }
        }
    }

}