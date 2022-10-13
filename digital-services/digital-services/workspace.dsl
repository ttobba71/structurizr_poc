workspace "digital-services" "All the systems under the responsibility of the digital services group"{

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
            group "Managed Database on GCP" {
                postgresDb = softwareSystem "N Number PostgreSQL" "Separate PostgreSQL Instance(s) for each Service" "DB" {
                    
                }
            }

            group "Messaging Solutions Confluent" {
                kafkaCluster = softwareSystem "Kafka Messaging" "Durable messsage queuing solution" "msg" {

                }

                rabbitMq = softwareSystem "RabbitMQ Messaging" "Publish/Subscribe queuing solution" "msg" {

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

            group "Orchestration Layer" {
                customerDomain = softwareSystem "Customer Domain API" "Abstraction layer that's familiar with all customer data sources.  Only exposes an Avant contract." "domainService" {
                    customerService = container "Core Customer API" "Service exposing core model attributes." "serviceApi" {
                       group "Django Web Container" {
                         component OnBoardingStep "A particular type of an onboarding step for a product. If enabled is True, then a CustomerOnboardingStep will be created for the	Customer when they are approved for a product."
                         component ProductOnBoardingStep "A particular type of an onboarding step for a product. If enabled is True, then a CustomerOnboardingStep will be created for the Customer when they are approved for a product."
                         component CustomerOnBoardingStep "Onboards customers into the core customer model."
                         component CustomerProductOnboardingStep "Links customers to products during the onboarding step."
                       }
                    }
                }
                aoDomain = softwareSystem "Account Opening Domain API" "Abstraction layer that's familiar with all account opening data sources.  Only exposes an Avant contract." "domainService" {
                    aoService = container "Account Opeining API" "Service exposing account opening model attributes." "serviceApi" {
                       group "FastAPI Web Container" {
                       }
                    }
                }
                productDomain = softwareSystem "Product Domain API" "Abstraction layer that's familiar with all product data sources.  Only exposes an Avant contract." "domainService" {
                    productService = container "Product API" "Service exposing product model attributes." "serviceApi" {
                       group "?? Web Container" {
                       }
                    }
                }
            }
            group "Digital Services" {

            }
            customer -> mobileApp "uses mobile application with their IOS or Android device" "https" "userWeb"
            customer -> webSite "uses web application with Chrome, Firefox, or Safari web browser" "https" "userWeb"

            mobileApp -> kongApiGateway "routes through" "https" "externalWeb"
            webSite -> kongApiGateway "routes through" "https" "externalWeb"
            cdn -> mobileApp  "static content cache" "https" "cdnCache"
            cdn -> webSite "static content cache" "https" "cdnCache"

            kongApiGateway -> customerDomain "route to customer domain service" "https" "internalWeb"
            kongApiGateway -> aoDomain "route to account opening domain service" "https" "internalWeb"
            kongApiGateway -> productDomain "route to product domain service" "https" "internalWeb"

            customerDomain -> postgresDb "persists data" "django ORM" "pdb"

            aoService -> kafkaCluster "produces messages" "avro" "qmsg"
            kafkaCluster -> aoService "consumes messages" "avro" "qmsg"
        }
    }

    views {
        systemlandscape "DigitalServices" {
            include *
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
        //customer
        systemContext customerDomain "CoreCustomerDomain" {
             include *
             autoLayout
        }
        container customerDomain "CoreCustomerApi" {
             include *
             autoLayout
        }
        component customerService "CoreCustomerModels" "The models supported in this service" {
             include *
             autoLayout
        }
        //Account Opening (AO)
        systemContext aoDomain "AccountOpeningDomain" {
             include *
             autoLayout
        }
        container aoDomain "AccountOpeningApi" {
             include *
             autoLayout
        }
        component aoService "AccountOpeningModels" "The models supported in this service" {
             include *
             autoLayout
        }
        //Product
        systemContext ProductDomain "ProductDomain" {
             include *
             autoLayout
        }
        container productDomain "ProductApi" {
             include *
             autoLayout
        }
        component productService "ProductModels" "The models supported in this service" {
             include *
             autoLayout
        }


        styles {
            element "domainService"{
                shape RoundedBox                
            }
            element "serviceApi"{
                shape RoundedBox                
            }
            element "gateway"{
                shape RoundedBox                
            }
            element "msg"{
                shape RoundedBox                
            }
            element "Person" {
                    color #ffffff
                    background #4EC5F1
                    fontSize 22
                    shape Person
            }
            relationship "cdnCache"{
                style dotted
                routing Curved
            }
            relationship "orm"{
                style dotted
                routing Curved
                color #6495ed
            }
            element "cdn" {
                shape Circle
                height 350
                width 350
            }
            element "mobileui" {
                shape RoundedBox
                background #3386B3
                height 250
                width 450
            }
            element "webui" {
                shape RoundedBox
                background #3386B3
                
                height 250
                width 450
            }
            element "DB" {
                shape Cylinder
                background #deb887
            }
            element "redis" {
                background #228b22
                shape Hexagon
            }
            element "Container" {
                shape RoundedBox
            }
            element "Component" {
                shape RoundedBox
            }
        }
    theme https://static.structurizr.com/themes/kubernetes-v0.3/theme.json
    }
}