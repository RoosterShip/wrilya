# Application Deployement

Guild for deploying an application to a cluster using the Pulumi Tools

## Assumptions

* There is a cluster deployed to be used.
    * If not please review the [Infrastructure Allocation](1-INFRASTRUCTURE_ALLOCATION.md) guide.

## Deploy Environment

The environment is the standard 3rd party services needed to make the system run and NOT built in house.  Examples of these are

- Postgres DB
- Redis
- RabbitMQ
- Prometheus
- Grafana

Currently all these services are being run as containers within the kubernetes cluster.

To deploy the environment run the following command:

`make dev.up.env`

Expected Time: ~1 minute

### Environment Configuration

Before executing an infrastructure allocation, you will need to configure it first.

1. Create a new Pulumi configuration file.  These are name like so `Pulumi.<config_name>.yaml`
1. Modify the Make file to add a `<config_name>.up.env` and `<config_name>.down.env`
    1. You can use `dev.up.env` and `dev.down.env` as a reference
    1. When creating the command make sure you change the line `@pulumi up --yes --config dev --cwd ./wrilya-env` to `@pulumi up --yes --config <config_name> --cwd ./wrilya-infra`
1. Copy/Paste the context from one of the other pulumi configuration files

### Config file

|Name                       | Type          | Purpose
|---                        |---            |---
|gcp:project                |string         | GCP Project to allocate resources in
|gcp:region                 |string         | GCP Region to allocate resource on
|wrilya-env:namespace       |string         | The kubernets namespace to deploy this environment in

## Deploy the Application

In a very similar fashion to deploying the Environment you will now need to deploy the appliation pods.  This is mostly focused on services written by the team such as:

- Game Server (Wrilya)
- Relayer
- Indexer

### Application Configuration

Same process as the Environment Configuration, however replace `env` with `app`

### Config file 

|Name                       | Type          | Purpose
|---                        |---            |---
|gcp:project                |string         | GCP Project to allocate resources in
|gcp:region                 |string         | GCP Region to allocate resource on
|wrilya-app:namespace       |string         | The kubernets namespace to deploy this environment in
|wrilya-app:image-tag       |string         | The docker image tag to use from GAR
|wrilya-app:chain-id        |string-number  | The blockchain id to for the server to use
|wrilya-app:chain-rpc       |string-number  | The blockchain URL to connect to
|wrilya-app:discord-token   |secure-string  | The discord access token.  Encrypted
|wrilya-app:secret-key-base |secure-string  | Token used by the website/rest API to secure session
|wrilya-app:world-address   |string         | MUD contract address
|wrilya-app:world-block     |string         | Block number the contract was deployed on

## Updating App or Environment

Assuming the changes are not TOOO massive you can update the __main__.py file for either the app or the environment and run the `up` make commands and it should deploy the changes.

## Deploy the Ingress

Ingress is how systems outside of the cluster (such as the game client) can connect to the servers.  This is done by deploying both a load balancer and using GCP certification management.  However it is all setup as a `Kubernetes Ingress Controller`

To enable the ingress run the command:

`make dev.up.ingress`


Expected Time: ~1 minute

However it can take up a hour or more for the certificate to fully be generated on GCP.  You will need to verify that info by going to the GCP console, goto the kubernets cluster, select "ingress" option and view the status of the ingress controller.


### Config file 

|Name                       | Type          | Purpose
|---                        |---            |---
|gcp:project                |string         | GCP Project to allocate resources in
|gcp:region                 |string         | GCP Region to allocate resource on
|wrilya-ingress:namespace   |string         | The kubernets namespace to deploy this in
|wrilya-ingress:subdomain   |string         | URL subdomain to use.  Example: "dev" -> "dev.wrilya.com"

## Releasing Ingress, App or Environment

You can release the app

- `make dev.down.ingress` to release the ingress and block people from seeing it.  This will also release the static IP assigned to the system so try and use the DNS name as much as possible.

- `make dev.down.app` to release the app.  This is helpful if you just want to cycle the apps but not take down the the whole enviornment (or infrastructure) 

- `make dev.down.env` to release the enironment.  If you are going to release the environment make sure you take the app down first.  Some pods could end up in an error case if not.
