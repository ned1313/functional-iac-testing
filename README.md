# Function IaC Testing using Kitchen-Terraform

The example code in this repo will deploy infrastructure using Terraform and test its functionality using kitchen-terraform. The testing process can be run locally or through a CI/CD pipeline driven by GitHub Actions. The backend used will be supplied by the env0 platform.

## Pre-requisites

You will need the following things installed:

* Terraform 1.3+
* Ruby for kitchen-terraform

You will also need the following resources:

* Microsoft Azure subscription
* Service principal or OIDC auth for Azure
* Forked version of this repository

We'll handle the rest as we go along.

## Running a local test

I'm going to assume you're running Linux for these commands. If you happen to be on Windows, then I'd recommend running WSLv2 to follow along. It's free and it's great!