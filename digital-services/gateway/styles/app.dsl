        styles {
            // element "serviceApi,future" {
            //     background #ff8c00
            // }
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
            // element "serviceApi"{
            //     shape RoundedBox                
            //     fontSize 24       
            //     background #ff8c00                         
            // }
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
            element "future" {
                background #add8e6                              
                shape RoundedBox
                fontSize 16                
            }

        }