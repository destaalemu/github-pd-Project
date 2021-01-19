=====================================================================================================
Scenario: Running Docker on AWS EC2 Instances
=====================================================================================================
=====================================================================================================
1.	What we require for running Dockers on AWS ? [Pre-requisites]
=====================================================================================================
1.1 	A GitHub account
1.2 	GitHub repo to host src and relevant docker files
1.3 	Create an with hub.docker.com
1.4 	Unique dockerID from dockerhub and docker repo
1.5 	Under the dockerhub, need to create a docker repository
1.6 	This repository is required to store all images build by docker

=====================================================================================================
2.	How to Install and run Dockers on AWS Ubuntu EC2 instances
=====================================================================================================
2.1. 	Create an EC2 instances, which play role as Host Instance for running Docker on it
2.2.	Run the following commands
					sudo su
					cd
					apt-get update -y
					apt-get install docker -y
					docker info

2.3  Create a github repo that and clone it to local-setup
					git clone https://github.com/<githubaccountname>/<githubrepo-for-docker>
					cd <githubrepo-for-docker>
					docker build -t <name-of-docker-image>:<tags/version> .														// To build docker images
					docker images    																																	// listing the docker
					docker run -p <host-port>:<docker-port>:<name-of-docker-image>:<tags/version>			// To run docker containers

2.4  Create a dockerhub repo under hub.docker.com and push images to dockerhub
					docker login
					docker push <dockerID>/<dockerhub-repo>  						// To push recenlty build image to dockerhub
					docker pull <dockerID>/<dockerhub-repo>							// To pull a copy of recenlty build image from dockerhub
					docker run -p 80:80 <dockerID>/<dockerhub-repo>   	// To run docker containers copied from dockerhub
					docker images																				// To list all images
					docker ps -aq																				// listing the containers
					docker stop $(docker ps -aq)												// Stop all container
					docker rm $(docker ps -aq)             					  	//stop all containers:
					docker rmi $(docker images -q)										  //Remove -Images

2.5.	Open browser and type <<Public Ip of EC2:80
================================================================
Setup Kubernetes (K8s) Cluster on AWS
================================================================
================================================================
What is kops?
================================================================
We like to think of it as kubectl for clusters
Easiest way to get a production grade Kubernetes cluster up and running
kops helps you create, destroy, upgrade and maintain production-grade, highly available,Kubernetes clusters from the command line
AWS (Amazon Web Services) is currently officially supported

================================================================
What we need to get started ?
================================================================
 - An S3 bucket required to store kops sessions state
 - To run kops, an EC2 Instance is required
 - kops does create/manage EC2 Instances(Kube Master and Nodes),IAM Roles (for Kube Master and Nodes), Route53
 - IAM Role with FUllAccess to EC2 || S3 || IAM || Route53 || VPC
 - Private/Public DNS Zone created from AWS Route53
 - 'kubectl', CLI tool for Kubernetes
 -  DNS hostname to be enabled for VPC

================================================================
Steps to be followed
================================================================

1.    To store all the sessions for Kubernetes State,we need to Create an S3 bucket
      Create an S3 bucket, ex: <<kub-ion-bucket-us-east-2>>

2.    Create an IAM role with IAM,EC2,S3 and Route53 Full access(k8-role)

3.    Create an EC2 instance with {k8-role},which has ability to create/delete/manage
      EC2 Instances|| S3 Buckets || Domain Resolution (Route53) || Roles for EC2 machices

4.    For Kubernetes to work with CLI, will need to install kubectl on ubuntu instance
      # https://kubernetes.io/docs/setup/production-environment/tools/kops/

5.    To Install kops on Ubuntu instance
      # https://kubernetes.io/docs/setup/production-environment/tools/kops/

6.    Move to AWS account,Create a Route53 Private hosted zone,
      Private Domain Name: thessadcloud.net
            ex: thessadcloud.net

7.    Expose environment variable:
            $ export KOPS_STATE_STORE=s3://kub-ion-bucket-us-east-2

8.   Master node will need to interact with Kube Node, hence we need a secret key to be created on Master node
      Create sshkeys before creating cluster
            $ ssh-keygen

9.   Create kubernetes cluster,for Private Hosted zone
            $ kops create cluster --cloud=aws --zones=us-east-2a,us-east-2b --name=kub.ion-app.thessadcloud.net --dns-zone=thessadcloud.net --dns private --yes

11.   To Validate your cluster
            $ kops validate cluster

12.   To list all namespaces
            $ kubectl get namespaces

13.   To permanently set the namespace for all subsequent kubectl commands in that context
            $ kubectl config set-context --current --namespace=kube-system

14.   Building Docker images
            $ docker login
            $ docker build -t <docker-id>/<name-of-the-repo>:<version>
            $ docker push <docker-id>/<name-of-the-repo>:<version>

15.   Create a Deployments for application
            $ vi ion-deployment.yaml
            $ kubectl apply -f ion-deployment.yaml

16.   Create service for the deployment
            $ vi ion-service.yaml
            $ kubectl apply -f ion-service.yaml

17.   To list deployments
            $ kubectl get deployments

18.   To list pods
            $ kubectl get pods

19.   To list services
            $ kubectl get services -o wide

22.   Open the browser and copy the IP address of master node  ,i.e  <master-node-ip>:<port-num>
      Note: Enable required <port-num> in Security groups for Master Node

23.   To delete cluster
            $ kops delete cluster kub.ion-app.thessadcloud.net --yes
