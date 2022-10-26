//
//demo: on-premise publish command:  structurizr-cli push -merge false -url https://structurizr-eks-kong-gzo6ajtw.dev.global.avant.com/api -id 3 -key fb69921f-2a1c-42b0-bfaf-c76dc4150849 -secret 9c3680a7-719e-4e20-b7ed-82677f4cf679 -w workspace.dsl
//
//!include shared/shared.dsl

//workspace extends https://raw.githubusercontent.com/ttobba71/structurizr_poc/main/digital-services/gateway/workspace.dsl {
workspace "Digital Services" {
    !adrs docs
    !docs cli-docs
    
    // true will give the user less control over the relationships displayed
    !impliedRelationships false  
    
    model {
        enterprise "Avant" {
//https://raw.githubusercontent.com/ttobba71/structurizr_poc/main/digital-services/gateway/

        !include https://raw.githubusercontent.com/ttobba71/structurizr_poc/main/digital-services/gateway/cdn/app.dsl
        !include https://raw.githubusercontent.com/ttobba71/structurizr_poc/main/digital-services/gateway/kafka/app.dsl
        !include https://raw.githubusercontent.com/ttobba71/structurizr_poc/main/digital-services/gateway/kong/app.dsl
        !include https://raw.githubusercontent.com/ttobba71/structurizr_poc/main/digital-services/gateway/rabbit/app.dsl
        !include https://raw.githubusercontent.com/ttobba71/structurizr_poc/main/digital-services/gateway/userApplications/app.dsl
        !include https://raw.githubusercontent.com/ttobba71/structurizr_poc/main/digital-services/gateway/database/app.dsl


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
                coreProductDomain = softwareSystem "Product Domain API" "Abstraction layer that's familiar with all product data sources.  Only exposes an Avant contract." "future" {
                    coreProductService = container "Product API" "Service exposing product model attributes." "future" {
                        component Product "Product Service or API"
                        component ProductFeature "Product Feature Service or API"
                    }
                }

                corePaymentsDomain = softwareSystem "Core Payments" "Core Payment System" "future" {
                    corePaymentService = container "Core Payments API" "The Core Payments Services" "future" {
                        component ExternalAccount "External Account Service or API"
                        component ExternalBankAccount "External Bank Account Service or API"
                        component ExternalCardAccount "External Card Account Service or API"
                    }
                } 
                coreCardDomain = softwareSystem "Core Card" "Core Card System" "future" {
                    coreCardService = container "Core Card API" "The Core Card Services" "future" {
                        component Card "Card Service or API"
                        component DebitCard "Debit Card Service or API"
                        component CreditCard "Credit Card Service or API"
                    }
                } 

                coreLedgerDomain = softwareSystem "Core Ledger" "Core Ledger System" "future" {
                    coreLedgerService = container "Core Ledger APIs" "The Core Ledger Services" "future" {
                        component Transaction "Transaction Service or API"
                        component LedgerEntry "Ledger Entry Service or API"
                        component CardTransaction "Card Transacton Service or API"
                        component BankTransfer "Bank Transfer Service or API"
                        component GeneralAdjustment "General Adjustment Service or API"
                    }

                } 
                coreAccountsDomain = softwareSystem "Core Accounts" "Core Accounts System" "domainService" {
                    coreAccountsService = container "Core Accounts APIs" "The Core Accounts Services" "serviceApi,future" {
                        component CustomerAccountUser "Customer Account Service or API"
                        component FinancialAccount "Financial Account Service or API"
                        component Balance "Balance Service or API"
                        component DDAAccount "DDA(ACH) Service or API"
                        component CreditAccount "Credit Service or API"
                        component LoanAccount "Loan Service or API"
                        component CashAdvanceProgram "Cash Advance Program Service or API"
                    }

                } 
                fiServeDomain = softwareSystem "Fiserve Abstraction Applications" "FiServe API and Services" "partnerService" {
                    fiserveService = container "Fiserve Application APIs" "The FiServe Service Abstraction Layer" "partnerServiceApi" {
                        component FiserveBridge "Fiserve Bridge Service or API"
                        component FiserveAccount "Fiserve Account Service or API"
                    }
                } 

            }

            kongApiGateway -> abDomain "route to Avant Basic application via gateway" "https" "internalWeb"
            kongApiGateway -> aoDomain "route to account opening domain service" "https" "internalWeb"
            kongApiGateway -> coreCustomerDomain "route to customer domain service" "https" "internalWeb"
            kongApiGateway -> coreProductDomain "route to product domain service" "https" "internalWeb"
            kongApiGateway -> coreCardDomain "route to card domain service via gateway" "https" "internalWeb"
            kongApiGateway -> coreLedgerDomain "route to ledger domain service via gateway" "https" "internalWeb"
            kongApiGateway -> corePaymentsDomain "route to payment domain service via gateway" "https" "internalWeb"
            kongApiGateway -> coreAccountsDomain "route to accounts domain service via gateway" "https" "internalWeb"

            coreCustomerDomain -> kongApiGateway "route to customer domain service via gateway" "grpc" "rpc"
            coreProductDomain -> kongApiGateway "route to product domain service via gateway" "grpc" "rpc"            
            coreCardDomain -> kongApiGateway "route to card domain service via gateway" "grpc" "rpc"
            coreLedgerDomain -> kongApiGateway "route to ledger domain service via gateway" "grpc" "rpc"
            corePaymentsDomain -> kongApiGateway "route to payment domain service via gateway" "grpc" "rpc"
            coreAccountsDomain -> kongApiGateway "route to account domain service via gateway" "grpc" "rpc"                                                

            coreAccountsDomain -> fiServeDomain  "route to fiserve service(s) via gateway" "grpc" "rpc"                                                
            fiServeDomain -> coreAccountsDomain "route from fiserve service(s) via gateway" "grpc" "rpc"                                                

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
            fiServeDomain -> kafkaCluster "produces messages" "avro" "qmsg"
            coreAccountsDomain -> kafkaCluster "produces messages" "avro" "qmsg"

            kafkaCluster -> aoService "consumes messages" "avro" "qmsg"
            

            coreCardService -> kafkaCluster "produces messages" "avro" "qmsg"
            kafkaCluster -> coreCardService "consumes messages" "avro" "qmsg"

            //included models
            customer -> cdn "uses mobile application with their IOS or Android device" "https vis cdn" "cdnCache"
            customer -> cdn "uses web application with Chrome, Firefox, or Safari web browser" "https via cdn" "cdnCache"
            mobileApp -> kongApiGateway "routes through" "https" "externalWeb"
            webSite -> kongApiGateway "routes through" "https" "externalWeb"
            cdn -> mobileApp  "dynamic request pass through cdn" "https" "externalWeb"
            cdn -> webSite "dynamic requests pass through cdn" "https" "externalWeb"


            //demo add kafka to core payments service and publish

        }
    }

    views {
        systemlandscape "DigitalServices" {
            include *
            exclude relationship.tag==rpc fiServeDomain
            exclude element.tag==eventMessage,rabbitmq
            exclude element.tag==eventMessage,kafka
            autoLayout lr

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
        //Card
        systemContext coreAccountsDomain "AccountDomain" {
             include *
             autoLayout
        }
        container coreAccountsDomain "AccountApi" {
             include *
             autoLayout
        }
        component coreAccountsService "AccountAPIOrServices" "The APIs or Services supported in this service" {
             include *
             autoLayout
        }

        //fiserve
        systemContext fiServeDomain "FiserveDomain" {
             include *
             autoLayout
        }
        container fiServeDomain "FiserveApi" {
             include *
             autoLayout
        }
        component fiserveService "FiserveAPIOrServices" "The APIs or Services supported in this service" {
             include *
             autoLayout
        }

    !include https://raw.githubusercontent.com/ttobba71/structurizr_poc/main/digital-services/gateway/styles/app.dsl

    theme https://static.structurizr.com/themes/kubernetes-v0.3/theme.json

    terminology {
        enterprise Cloud
    }
    }
}