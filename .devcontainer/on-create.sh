#!/bin/bash

echo "on-create start" >> ~/status

# create a network
docker network create kind

# create local registry
#docker run -d --net kind --restart=always -p "127.0.0.1:5000:5000" --name registry registry:2
k3d registry create registry.localhost --port 5000
docker network connect kind k3d-registry.localhost

# push apps to local registry
docker pull dapriosamples/hello-k8s-node:latest
docker tag dapriosamples/hello-k8s-node:latest k3d-registry.localhost:5000/dapr-node:local
docker push k3d-registry.localhost:5000/dapr-node:local
docker rmi dapriosamples/hello-k8s-node:latest

docker pull dapriosamples/hello-k8s-python:latest
docker tag dapriosamples/hello-k8s-python:latest k3d-registry.localhost:5000/dapr-python:local
docker push k3d-registry.localhost:5000/dapr-python:local
docker rmi dapriosamples/hello-k8s-python:latest

# create k3d cluster
k3d cluster create --registry-use k3d-registry.localhost:5000 --config k3d/k3d.yaml
kubectl wait node --for condition=ready --all --timeout=60s

# install dapr
dapr init -k --enable-mtls=false --wait

# install redis
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install redis bitnami/redis

# redis config
kubectl apply -f deploy/redis.yaml

# wait for redis master to start
kubectl wait pod redis-master-0  --for condition=ready --timeout=60s

# deploy apps
kubectl apply -f deploy/node.yaml
kubectl apply -f deploy/python.yaml

echo "on-create complete" >> ~/status
