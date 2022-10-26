    kafkaCluster = softwareSystem "Kafka Messaging" "Durable messsage queuing solution" "eventMessage,kafka" {
        zookeeper = container "Apache Zookeeper" "A centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services" "zk"
        kafka = container "Kafka Node" "A event streaming platform" "kafkaNode"
    }
