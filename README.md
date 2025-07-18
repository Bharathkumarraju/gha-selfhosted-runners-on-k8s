# gha-selfhosted-runners-on-k8s
github self hosted runners on kubernetes(AWS EKS Cluster)

## terraform remote state
create s3 as tf remote state [tf-remote-state-pipeline](https://github.com/Bharathkumarraju/gha-selfhosted-runners-on-k8s/actions/runs/16358410949)

## create vpc 
deploy aws vpc through terraform [aws-vpc-pipeline](https://github.com/Bharathkumarraju/gha-selfhosted-runners-on-k8s/actions/runs/16360740048)

## EKS cluster 
deploy an aws eks cluster [aws-eks-pipeline](https://github.com/Bharathkumarraju/gha-selfhosted-runners-on-k8s/actions/runs/16362142754/job/46232034246#step:8:353)


## GHA Runner 
Deploy GHA Runner helm charts 


## create github APP 
Create a github app and authenticate to guthub runner controller for github API access

