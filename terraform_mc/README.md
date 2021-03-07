Terraform a Web App on AWS:

This Terraform deploys a web application to AWS. It uses EC2, Load Balancer, EBS and VPC services. It created 2 EC2 instances t2.micro on region ap-south-1. Web application can be accessable by DNS on load balancer used.

Getting started:

In main.tf file name

Provider: AWS 
Region: "ap-south-1" # Mumbai

Resources used
VPC: web_vpc
Subnet: web_subnet

Instance: web
Instance type: t2.micro

EBS volume: my_volume per instance attached

In load_balancer.tf 

ELB - web
Target - "HTTP:80/

In Networking.tf:

IG - web_igw
route table: public_rt
subnet - public_subnet
Route table association - public_subnet_rta

In security.tf:
ELB SG - elb_sg
ELB SG - web_sg, sg of elb

user_data.sh - php file

variables:
network_cidr
availability_zones
instance_count
ami_ids

Data source:
user_data: user_data.sh

