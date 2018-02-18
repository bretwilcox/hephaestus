### Overview
This is a proof of concept Ruby on Rails application written to explore
* Deploying Ruby on Rail with Helm Charts
* Accessing the Kubernetes API within a Pod
* Prometheus integration

#### Prometheus Integration
Metrics and be found at by navigating to the /metrics page within the app.  For verification of the integration a test gauge was implemented at /test_gauge that creates a gauge with a random value between 1 and 100 when it is hit.

#### Using the Helm chart

##### Chart Location
/hephaestus-app

##### Installing Helm Chart to Kubernetes

Prerequisites
* You have a Docker environment running.
* You have Minikube installed in your local computer.
* You have a Kubernetes cluster running.
* You have the kubectl command line (kubectl CLI) installed.
* You have Helm and Tiller installed.

Once you have completed teh prerequisites you can install the helm chart included in this repo by executing the following command from the root of this repo


Our project contains a requirements.yaml for MariaDB which our rails app is configured to use. If the dependencies have not been installed yet you may need to execute the following commands: 

```
helm dep list 
helm dep update .
```
With dependencies now in place we are ready to install the helm chart on the cluster.

```
helm install --set mariadb.mariadbRootPassword=DATABASE_PASSWORD --name hephaestus-app ./hephaestus-app/
```
_DATABASE_PASSWORD insert any value as DATABASE_PASSWORD.  Both the app installed by this helm chart and the required MariDB helm chart will pick this up._

Inside /hephaistus-app/templates you will find deployment.yaml and service.yaml which when installed will bring up a Service, ReplicaSet, and corresponding Pods.

##### Making updates

Certain configurable variables have been abstracted in the /hephaistus-app/values.yaml file.

#### Building a Docker Image

Execute the following command in the root of this repository.  Note that the name given to the tag (-t) flag below is the Docker ID that points to my public registry hosted on hub.docker.com.  Following the Docker ID is the name of the app and the current version we are building.
 
`docker build -t bretwilcox/hephaestus_app:0.0.1 .`

Execute the following command to publish the Docker container built in the previous step:

* Login into Docker Hub

    `docker login`

* Push the image to Docker Hub account:

    `docker push bretwilcox/hephaestus_app:0.0.1 .`
    
A convenience script has been included at /build.sh that removes the app from Kubernetes, builds and published the Dockerfile to hub.docker.com, and installs a fresh copy of the helm chart.

#### Generate documentation
Generating documentation with rails installed
```
rails rdoc:clobber_rdoc  # Remove RDoc HTML files
rails rdoc:rdoc          # Build RDoc HTML files
rails rdoc:rerdoc        # Rebuild RDoc HTML files
```

Generating documentation using Docker containers with docker-compose
```
docker-compose run web rails rdoc:clobber_rdoc  # Remove RDoc HTML files
docker-compose run web rails rdoc:rdoc          # Build RDoc HTML files
docker-compose run web rails rdoc:rerdoc        # Rebuild RDoc HTML files
```

#### Database initialization
After installing the database for the first time you will need to create the DBs used by the app.  This can be accomplished after you have installed the helm chart with the following command and expected output:

```
[Sun Feb 18 02:45 PM] $ kubectl exec -it hephaestus-app-hephaestus-app-b76b4744-2bnb8 bundle exec rake db:create
Created database 'myapp_development'
Created database 'myapp_test'
```

The current webapp does not make use of the database but everything is hooked up and ready to go for future development.
