
        group "API Gateway" {
            kongApiGateway = softwareSystem "API Gateway Application" "Vendor agnostic solution implemented in Ngnix and Lua that filters and routes API and web traffic." "gateway" {
            kongManagement = container "Web Management Console" "The console used by internal resources to configure API gateway functionality" "webConsole" {
            kongPluginComponent = component "Plugin Architecture Components"
        }
