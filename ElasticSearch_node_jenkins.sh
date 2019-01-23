#!/bin/bash
network_name=$1
container_port_elastic_search=9200
container_port_jenkins=8080
hast_network_exists=$(docker network ls --filter "NAME=$network_name" --format {{.Name}})

#check if newtork exists
if [ -z "$hast_network_exists" ] ; then
        echo "Network not exists. Creating $1..."
        docker network create $network_name
else
    echo "Network ready exists. Aborting network configuration"
fi

elastic_search_container_name=$(docker container ps --filter "NAME=$network_name-elastic-search" --format '{{.Names}}')
if [ -z "$elastic_search_container_name"] ; then
    echo "Your container elasticsearch:5.5.3 don't exists. Creating..."
    docker run  -d -p $container_port_elastic_search:9200 -e "discovery.type=single-node" --network $network_name --name=$network_name-elastic-search docker.elastic.co/elasticsearch/elasticsearch:5.5.3
    echo "Container $elastic_search_container_name create"
else
    #docker container rm $network_name-elastic-search --force
    echo "Container $elastic_search_container_name ready exists. Skyping this step"
fi

jenkins_container_name=$(docker container ps --filter "NAME=$network_name-jenkins" --format '{{.Names}}')
if [ -z "$jenkins_container_name"] ; then
    echo "Your container jenkins dont's exists. Creating..."
    #create container jenkins
    docker run -d --name=$network_name-jenkins -p $container_port_jenkins:8080 -p 50000:50000  --network $network_name  jenkins:2.60.3
    echo "Container $network_name-jenkins create"
else
    echo "Container $network_name-jenkins ready exists. Skyping this step"
fi

elastic_search_container_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $network_name-elastic-search )
jenkins_container_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $network_name-jenkins )

echo "Infra created..."
echo "For access the eslasticsearch access htt://$elastic_search_container_ip:$container_port_elastic_search"
echo "For access the jenkins access htt://$jenkins_container_ip:$container_port_jenkins"