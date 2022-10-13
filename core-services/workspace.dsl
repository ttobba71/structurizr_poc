workspace {

    model {
        customer = person "Customers" "Anyone who uses Avant's loan, credit card, or banking systems." "End Users"
        plaid = softwareSystem "Plaid API Abstraction" "API abstraction proving integration with various financial institutions" "api"{
        }
        i2c = softwareSystem "I2C Services" "External System Integration" "Websocket and API"{
            i2cWebsocketConnection = container "I2C Web Socket" "Open web socket link" "websocket"{

            }
            i2cApi = container "I2C API Integration" "Rest API" "rest"{
                
            }
        }

        digitalServices = softwareSystem "digitalServices" "The service currently supporting banking and debit card customers." "service"{
            group "Account Micro Service" {
                accountService = container "Account Service" "Django Rest API application" "nginx WSGI"{
                }
                accountServiceDB = container "Account DB" "PostgreSQL database" "PostgreSQL on Linux" "DB" {
                }
            }

            group "Identity Service" {
                identityService = container "Identity Service" "Django Rest API application" "nginx WSGI"{

                }
                identityServiceDB = container "IdentityDB" "PostgreSQL database" "PostgreSQL on Linux" "DB" {

                }
            }
            group "Ledger Service" {
                ledgerService = container "Ledger Service" "Django Rest API application" "nginx WSGI"{

                }
                ledgerServiceDB = container "Ledger DB" "PostgreSQL database" "PostgreSQL on Linux" "DB" {

                }
            }
            group "I2C Service" {
                i2cService = container "i2c Service" "Django Rest API application" "nginx WSGI"{

                }
                i2cServiceDB = container "i2c DB" "PostgreSQL database" "PostgreSQL on Linux" "DB" {

                }
            }
            group "Authorizer Service" {
                authorizerService = container "Authorizer Service" "Java application that communicates to I2C" "Tomcat?Jetty?JBoss?"{

                }
                authorizerServiceDB = container "Authorizer DB" "PostgreSQL database" "PostgreSQL on Linux" "DB" {

                }
            }
            group "DDA Service" {
                ddaService = container "DDA Service" "Django Rest API application" "nginx WSGI"{

                }
                ddaServiceDB = container "DDA DB" "PostgreSQL database" "PostgreSQL on Linux" "DB" {

                }
            }
            group "Messenger Service" {
                messengerService = container "Messenger Service" "Django Rest API application" "nginx WSGI"{

                }
                messengerServiceDB = container "Messenger DB" "PostgreSQL database" "PostgreSQL on Linux" "DB" {

                }
            }
            group "Processor Service" {
                processorService = container "Processor Service" "Django Rest API application" "nginx WSGI"{

                }
                processorServiceDB = container "Processor DB" "PostgreSQL database" "PostgreSQL on Linux" "DB" {

                }
            }
            group "FiServe Bridge Service" {
                fiserveService = container "FiServe Bridge Service" "Django Rest API application" "rest"{

                }
                fiserveServiceDB = container "FiServe Bridge DB" "PostgreSQL database" "PostgreSQL on Linux" "DB" {
                    
                }
            }
            redisCache = container "Customer Cache Lookup" "Redis Caching" "Redis Cache" "redis"{

            }
        accountService -> redisCache "Read customer data from cache" "Name/Value" "cache"
        redisCache -> accountService "Write customer data to cache" "Name/Value" "cache"
        accountService -> accountServiceDB "Local Container Network Communication" "DJango ORM" "orm"
        identityService -> identityServiceDB "Local Container Network Communication" "DJango ORM" "orm"
        processorService -> processorServiceDB "Local Container Network Communication" "DJango ORM" "orm"
        messengerService -> messengerServiceDB "Local Container Network Communication" "DJango ORM" "orm"
        ddaService -> ddaServiceDB "Local Container Network Communication" "DJango ORM" "orm"
        i2cService -> i2cServiceDB "Local Container Network Communication" "DJango ORM" "orm"
        ledgerService -> ledgerServiceDB "Local Container Network Communication" "DJango ORM" "orm"
        identityService -> identityServiceDB "Local Container Network Communication" "DJango ORM" "orm"
        fiserveService -> fiserveServiceDB "Local Container Network Communication" "DJango ORM" "orm"
        authorizerService -> authorizerServiceDB "Local Container Network Communication" "JDBC" "java"   
        }
        customer -> digitalServices "uses via Browser/Mobile App"

    }

    views {
        systemlandscape "BankingServices"{
            include *
        }
        systemContext i2c "SystemContextFiserve" {
            include *
            autoLayout
            animation {
                i2c
            }
        }

        systemContext digitalServices "SystemContextCustomer" {
            title "Customer Interaction with Services"
            include *
            autoLayout
            animation {
                digitalServices
            }
        }
        container digitalServices "CustomerContainers" {
            title "Development Cluster"
            include *
            autoLayout
        }
    styles {
        element "Person" {
                color #ffffff
                background #4EC5F1
                fontSize 22
                shape Person
        }
        relationship "cache"{
            style dotted
            routing Curved

        }
        relationship "orm"{
            style dotted
            routing Curved
            color #6495ed
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
    }

    }

}