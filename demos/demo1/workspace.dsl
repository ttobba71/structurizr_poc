#workspace extends https://raw.githubusercontent.com/ttobba71/structurizr_poc/main/digital-services/gateway/workspace.dsl {
workspace "Structurizr Engineering Workflow" {
    !adrs docs/adr
    !docs documentation

    model {
        enterprise "Avant Engineering" {
            developer = person "Engineer"
            group "Engineer Laptop" {
                ide = softwareSystem "IDE of Choice" "PyCharm or VS Code or any IDE or editor that supports editing YAML files and creating markdown." "devSystem" {
                    container "adr utility" "Achitecture decision record utility used by the engineering to generate the architecture decision log." "adrTool" 
                }
                structurizrLite = softwareSystem "Structure Lite Docker Container" "A docker container that contains a simple configuration of the Structurizr software.  This software is used to validate and preview dsl files locally." "structurizrLite" {

                }
                adr = softwareSystem "Architecture Decision Record Utility" "The adr utility can be installed using brew and engineers can use it to log architectural decisions." "adr" {
                } 
            }
            structurizrOnPremise = softwareSystem "Structure OnPremise Container" "A docker container that contains the on-premise Structurizr software." "structuriz" {
                structurizrWar = container "Spring Boot Java Web Application" "The Structurizr web application" "java"
                database = container "Database" "Assumed database application used to persist data." "rdb"
                s3Object = container "S3 Object Storage" "S3 storage" "s3"
            }


        }

        gitHub = softwareSystem "GitHub Source Control" "Source control and CI/CD solution" "github" {
            githubAction = container "GitHub Action" "GitHub Action executed on merge." "s3"
        }

        developer -> ide "Creates DSL file containing model and views."
        developer -> structurizrLite "Validates dsl files locally using."
        developer -> structurizrOnPremise "Manual pushes to development environment."
        developer -> gitHub "Pushes code to remote repo and opens a pull request."
        developer -> adr "Uses untility to create architecture decision log files."     
        gitHub -> structurizrOnPremise "On merge GitHub Action pushes workspace.dsl into Structurizr."

        structurizrWar -> database "Performs CRUD Data Operations."


        development = deploymentEnvironment "Development" {
            deploymentNode "AWS EKS" "Terraformed Cluster and Deployment" "" "awseks" 1 {
                deploymentNode "Docker Container" "Structurizr On-Premise Container" "" "docker" 1 {
                    containerInstance structurizrWar
                    containerInstance database
                }
                infrastructureNode "s3 Object Storage" "" "" "s3" {
                }               
            }
        }

    }

    views {
        systemlandscape engineeringLaptop "EngineeringStructurizrLandscape" {
            include *
            autoLayout tb
        }
        deployment * development {
            include *
            autoLayout lr
        }
        systemContext ide "LocalDevelopmentUtility" {
            include *
            autoLayout lr
        }
        systemContext structurizrLite "LocalStructurizrLiteContainer" {
            include *
            autoLayout lr
        }
        styles {
            element "Person" {
                color #ffffff
                background #4EC5F1
                fontSize 16
                shape Person
            }
            element "Element" {
                shape RoundedBox                
            }

        }

    }

}