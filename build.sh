#! /bin/bash

# Delete the current installation of the helm chart
helm del --purge hephaestus-app

# Build a new version of the app
docker build -t bretwilcox/hephaestus_app:0.0.1 .

# Publish the docker container on hub.docker.com
docker push bretwilcox/hephaestus_app:0.0.1

# Install the helm chart and set the MariaDB password
helm install --set mariadb.mariadbRootPassword=CKa@K.Nfrh4MdZ9mhRDBzmdLHTUGBA --name hephaestus-app ./hephaestus-app/

# Open the about aboutthisapp page once the deployment is complete
open $(minikube service --url hephaestus-app-hephaestus-app)/aboutthisapp