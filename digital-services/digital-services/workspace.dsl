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

            group "Avant Basic" {
                abDomain = softwareSystem "Avant Basic" "Avant Basic ruby monolith" "monolith" {
                    abApplication = container "Avant Basic Web Application" "Ruby monolith with multiple business domains" "monolith" {
                        component abloan "Avant loan domain"
                        component abcrm "Avant crm domain"                         
                        component abcreditCard "Avant credit card domain"                         
                        component abdda "Avant ACH trainsaction support"                         
                    }
                }
            }
            group "Account Opening" {
                aoDomain = softwareSystem "Account Opening Domain API" "Abstraction layer that's familiar with all account opening data sources.  Only exposes an Avant contract." "domainService" {
                    aoService = container "Account Opeining API" "Service exposing account opening model attributes." "serviceApi" {
                       group "FastAPI Web Container" {
                       }
                    }
                }
            }
            group "Digital services communicate with each other via the gateway" {
                coreCustomerDomain = softwareSystem "Customer Domain API" "Abstraction layer that's familiar with all customer data sources.  Only exposes an Avant contract." "domainService" {
                    coreCustomerService = container "Core Customer API" "Service exposing core model attributes." "serviceApi" {
                       group "Django Web Container" {
                         component OnBoardingStep "A particular type of an onboarding step for a product. If enabled is True, then a CustomerOnboardingStep will be created for the	Customer when they are approved for a product."
                         component ProductOnBoardingStep "A particular type of an onboarding step for a product. If enabled is True, then a CustomerOnboardingStep will be created for the Customer when they are approved for a product."
                         component CustomerOnBoardingStep "Onboards customers into the core customer model."
                         component CustomerProductOnboardingStep "Links customers to products during the onboarding step."
                       }
                    }
                }
                coreProductDomain = softwareSystem "Product Domain API" "Abstraction layer that's familiar with all product data sources.  Only exposes an Avant contract." "domainService" {
                    coreProductService = container "Product API" "Service exposing product model attributes." "serviceApi" {
                        component Product "Product Service or API"
                        component ProductFeature "Product Feature Service or API"
                    }
                }

                corePaymentsDomain = softwareSystem "Core Payments" "Core Payment System" "domainService" {
                    corePaymentService = container "Core Payments API" "The Core Payments Services" "serviceApi" {
                        component ExternalAccount "External Account Service or API"
                        component ExternalBankAccount "External Bank Account Service or API"
                        component ExternalCardAccount "External Card Account Service or API"
                    }
                } 
                coreCardDomain = softwareSystem "Core Card" "Core Card System" "domainService" {
                    coreCardService = container "Core Card API" "The Core Card Services" "serviceApi" {
                        component Card "Card Service or API"
                        component DebitCard "Debit Card Service or API"
                        component CreditCard "Credit Card Service or API"
                    }
                } 

                coreLedgerDomain = softwareSystem "Core Ledger" "Core Ledger System" "domainService" {
                    coreLedgerService = container "Core Ledger APIs" "The Core Ledger Services" "serviceApi" {
                        component Transaction "Transaction Service or API"
                        component LedgerEntry "Ledger Entry Service or API"
                        component CardTransaction "Card Transacton Service or API"
                        component BankTransfer "Bank Transfer Service or API"
                        component GeneralAdjustment "General Adjustment Service or API"
                    }

                } 
                coreAccountsDomain = softwareSystem "Core Accounts" "Core Accounts System" "domainService" {
                    coreAccountsService = container "Core Accounts APIs" "The Core Accounts Services" "serviceApi" {
                        component CustomerAccountUser "Customer Account Service or API"
                        component FinancialAccount "Financial Account Service or API"
                        component Balance "Balance Service or API"
                        component DDAAccount "DDA(ACH) Service or API"
                        component CreditAccount "Credit Service or API"
                        component LoanAccount "Loan Service or API"
                        component CashAdvanceProgram "Cash Advance Program Service or API"
                    }

                } 

            }
            customer -> mobileApp "uses mobile application with their IOS or Android device" "https" "userWeb"
            customer -> webSite "uses web application with Chrome, Firefox, or Safari web browser" "https" "userWeb"

            mobileApp -> kongApiGateway "routes through" "https" "externalWeb"
            webSite -> kongApiGateway "routes through" "https" "externalWeb"
            cdn -> mobileApp  "static content cache" "https" "cdnCache"
            cdn -> webSite "static content cache" "https" "cdnCache"

            kongApiGateway -> abDomain "route to Avant Basic application via gateway" "https" "internalWeb"
            kongApiGateway -> aoDomain "route to account opening domain service" "https" "internalWeb"
            kongApiGateway -> coreCustomerDomain "route to customer domain service" "https" "internalWeb"
            kongApiGateway -> coreProductDomain "route to product domain service" "https" "internalWeb"
            kongApiGateway -> coreCardDomain "route to Avant Basic application via gateway" "https" "internalWeb"
            kongApiGateway -> coreLedgerDomain "route to Avant Basic application via gateway" "https" "internalWeb"
            kongApiGateway -> corePaymentsDomain "route to Avant Basic application via gateway" "https" "internalWeb"
            kongApiGateway -> coreAccountsDomain "route to Avant Basic application via gateway" "https" "internalWeb"

            coreCustomerDomain -> kongApiGateway "route to payment domain service via gateway" "grpc" "rpc"
            coreProductDomain -> kongApiGateway "route to payment domain service via gateway" "grpc" "rpc"            
            coreCardDomain -> kongApiGateway "route to payment domain service via gateway" "grpc" "rpc"
            coreLedgerDomain -> kongApiGateway "route to payment domain service via gateway" "grpc" "rpc"
            corePaymentsDomain -> kongApiGateway "route to payment domain service via gateway" "grpc" "rpc"
            coreAccountsDomain -> kongApiGateway "route to payment domain service via gateway" "grpc" "rpc"                                                

            aoDomain ->  postgresDb "persists data" "ORM" "pdb"
            abDomain ->  postgresDb "persists data" "Ruby ORM" "pdb"

            coreCustomerDomain -> postgresDb "persists data" "django ORM" "pdb"
            coreProductDomain ->  postgresDb "persists data" "django ORM" "pdb"
            corePaymentsDomain -> postgresDb "persists data" "django ORM" "pdb"
            coreCardDomain -> postgresDb "persists data" "django ORM" "pdb"
            coreLedgerDomain -> postgresDb "persists data" "django ORM" "pdb"
            coreAccountsDomain -> postgresDb "persists data" "django ORM" "pdb"
            corePaymentsDomain -> postgresDb "persists data" "django ORM" "pdb"

            aoService -> kafkaCluster "produces messages" "avro" "qmsg"
            kafkaCluster -> aoService "consumes messages" "avro" "qmsg"
        }
    }

    views {
        systemlandscape "DigitalServices" {
            include *
            exclude relationship.tag==rpc
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
        systemContext coreCustomerDomain "CoreCustomerDomain" {
             include *
             autoLayout
        }
        container coreCustomerDomain "CoreCustomerApi" {
             include *
             autoLayout
        }
        component coreCustomerService "CoreCustomerModels" "The models supported in this service" {
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
        systemContext coreProductDomain "ProductDomain" {
             include *
             autoLayout
        }
        container coreProductDomain "ProductApi" {
             include *
             autoLayout
        }
        component coreProductService "ProductModels" "The models supported in this service" {
             include *
             autoLayout
        }

        //Payments
        systemContext corePaymentsDomain "PaymentDomain" {
             include *
             autoLayout
        }
        container corePaymentsDomain "PaymentApi" {
             include *
             autoLayout
        }
        component corePaymentService "PaymentAPIOrServices" "The APIs or Services supported in this service" {
             include *
             autoLayout
        }
        //Card
        systemContext coreCardDomain "CardDomain" {
             include *
             autoLayout
        }
        container coreCardDomain "CardApi" {
             include *
             autoLayout
        }
        component coreCardService "CardAPIOrServices" "The APIs or Services supported in this service" {
             include *
             autoLayout
        }


        styles {
            element "domainService"{
                shape RoundedBox                
                fontSize 16                
            }
            element "serviceApi"{
                shape RoundedBox                
                fontSize 16                
            }
            element "gateway" {
                shape RoundedBox                
                fontSize 16
            }
            element "monolith" {
                shape RoundedBox                
                fontSize 16                
                background #ff8c00
            }
            element "msg"{
                shape RoundedBox                
                fontSize 16                
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
                routing Orthogonal
            }
            relationship "rpc"{
                style dotted
                routing Orthogonal
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
    theme https://static.structurizr.com/themes/kubernetes-v0.3/theme.json
    }
}