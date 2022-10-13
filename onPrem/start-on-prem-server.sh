export STRUCTURIZR_DATA_DIRECTORY=/Users/jabbot18/Documents/source/c4models/dataDirectory
docker run -d --rm --label onprem --label structurizr --name c4Viewer -p 8081:8080 -v $(PWD):/usr/local/structurizr  structurizr/onpremises 
