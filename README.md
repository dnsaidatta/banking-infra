# **Terraform Infrastructure for React Web App and Backend Services** 
## Overview
This solution provisions a scalable cloud infrastructure on Azure to host:

**React Web App** - Hosted on Azure App Service.
**Backend Service 1** - A private API with a private Cosmos DB and strict outbound rules.
**Backend Service 2** - A public API with rate-limiting via Azure API Management and a public Cosmos DB.
**Azure Application Gateway** - A centralized gateway for routing traffic to the web app and backend services.

## Architecture Highlights
### Azure Virtual Network (VNet):
Subnets for the frontend (Application Gateway), private backend, and public backend services.
### Application Gateway:
Routes traffic to the React Web App and backend services.
### Backend Services:
Backend Service 1: Private with restricted outbound access to a banking provider and its database.
Backend Service 2: Publicly accessible with rate limiting and its database.
### Cosmos DB:
Backend Service 1 and 2 use separate Cosmos DB instances, one private and one public.

## Modules
The solution is modularized for reusability:

*vnet*: Configures the Azure Virtual Network and subnets.
*app_gateway:* Provisions the Azure Application Gateway.
*backend_service_1:* Deploys the private backend service.
*backend_service_2:* Deploys the public backend service.
*cosmos_db:* Configures Azure Cosmos DB instances.
*react_web_app:* Provisions the React Web App on Azure App Service.

## Pre-Requisites
*Terraform CLI:* Install the latest version of Terraform from here.
*Azure CLI:* Ensure Azure CLI is installed and authenticated:
`az login`
*Backend Configuration:* Set up a remote state backend for Terraform or use the local backend.

**Setup Instructions**
1. Clone the Repository
``git clone <repository-url>``
``cd <repository-directory>``
2. Initialize Terraform
``terraform init``
3. Validate Configuration
Check for syntax and configuration errors:
``terraform validate``
4. Plan the Deployment
Generate a plan to preview changes:

``terraform plan -var-file=terraform.tfvars``
5. Apply the Configuration
Deploy the infrastructure:

``terraform apply -var-file=terraform.tfvars``
Variables
Customize the deployment using variables. 

**Approach**
How the Solution Was Designed
*Modularity:* Each component (e.g., VNet, Application Gateway, Backend Services) was modularized for clarity and reusability.
*Security:*
Backend Service 1 is isolated in a private subnet and communicates with its database via a private endpoint.
NSGs restrict inbound/outbound traffic.
*Scalability:*
Application Gateway routes traffic to backend services efficiently.
The infrastructure supports adding more backend services with minimal changes.
*Best Practices:*
Use of Terraform variables and outputs for configurability.
Rate-limiting for public APIs to prevent abuse.

**Improvements**
*Enhanced Testing:*
Implement additional integration tests to validate end-to-end connectivity between components.
*Monitoring and Logging:*
Add Application Insights for monitoring backend services and log analytics for Application Gateway.
*CI/CD Integration:*
Automate deployment with CI/CD pipelines using Azure DevOps or GitHub Actions.
*Better Scalability:*
Use Azure Kubernetes Service (AKS) for containerized backend services.
*Dynamic Scaling:*
Enable autoscaling for backend services based on demand.

To **destroy** the infrastructure and avoid charges:
``terraform destroy -var-file=terraform.tfvars``
