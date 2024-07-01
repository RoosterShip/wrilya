# Infrastructure Allocation

Guide for setting up a GCP Cluster using the Pulumi Tools.

## Assumptions

* `<config_name>` is the name of this new stack.  For example we use a cluster for develop and one for production.
    * For develop `<config_name>` is `dev`
    * For production `<config_name>` is `prod`
* A cluster is a kuberentes environment and the hardware assigned to it.
    * A single cluster can host multiple deployments
    * Example:
        * Develop Cluster:  Hosts both our `dev` and `test` deployments
        * Production Cluster:  Hosts our `staging` and `production` deployments

## Cloud Authorization

To allocate a cluster you will need to authorized with GCP.  This can be done by:

1. Following the [Setup Guide](0-SETUP.md)
2. Executing `make login` from the project root folder

Note:  This will ask you to log in twice to GCP.  The first time is to log into the GCP environment and the second time is to authorized your shell environment.  GCP CLI might have a better way of doing this but for now it works.

Note:  You will have to do this once a day.  Seems like time-out for the tokens must be around 24 hours or so.

## Ensure Setup has happened

The first time you allocate to a new cluster/region the `wrilya-base` setup needs to be run.  Please make sure you have gone throught the setps in the [Setup Guide](0-SETUP.md)

## Cluster Configuration

Before executing an infrastructure allocation, you will need to configure it first.

1. Create a new Pulumi configuration file.  These are name like so `Pulumi.<config_name>.yaml`
1. Modify the Make file to add a `<config_name>.up.infra` and `<config_name>.down.infra`
    1. You can use `dev.up.infra` and `dev.down.infra` as a reference
    1. When creating the command make sure you change the line `@pulumi up --yes --config dev --cwd ./wrilya-infra` to `@pulumi up --yes --config <config_name> --cwd ./wrilya-infra`
1. Copy/Paste the context from one of the other pulumi configuration files

### Config file

|Name                       | Type          | Purpose
|---                        |---            |---
|gcp:project                |string         | GCP Project to allocate resources in
|gcp:region                 |string         | GCP Region to allocate resource on
|wrilya-infra:nodeType      |string         | The machine type for kubernetes to use.  Values can be found [here](https://cloud.google.com/compute/docs/machine-resource)
|wrilya-infra:nodesPerZone  |string-number  | The cluster will allocate machines in each zone of the cluster.  This value sets how many machines to allocate per zone.  Exampe:  Value of 2 means 2 nodes per zone, on a region with 3 zones will allocate 6 nodes.

## Allocate Cluster

Run the make file for the cluster you wish to allowcate:

Example:

Allocating the Develop Cluster

`make dev.up.infra`


## Verification

Once completed there should be NO errors in the console running the command.

### GCP Website

1. Log into [GCP Console](https://console.cloud.google.com/)
1. In the upper left hand corner of the webpage make sure the correct GCP Project is selected.  It should match what was in your pulumi config file.
1. Goto the `Kubernetes Engine` selection of GCP
1. In the terminal lookup in the section `Outputs:` the field field `cluster::name`
1. Select `Clusters` under `Resource management` dropdown list on the left menu
1. Select the Cluster which matches that of the field `cluster::name` and verify that the status is a green checkmark

## Update Makefile (If you created a new configuration)

1. Open project root makefile
1. Add a new `GKE_CLUSTER_<config_name>` variable running the command to `$(shell cat devops/remote/<config_name>.cluster)`
1. Add a new `GKE_REGION_<config_name>` variable running the command to `$(shell cat devops/remote/<config_name>.region)`
1. create a new command called `auth.<config_name>`
1. copy paste content from `auth.dev` swapping out `GKE_CLUSTER_DEV` and `GKE_REGION_DEV` with your `*_<config_name>` vars from above

## Log and verify Cluster

Verify that we can log in the cluster and execute some kubectl commands

1. From the project root folder run `make auth.dev` (or whatever cluster you want to log into).  This will set up your kubeconfig
1. Get the namespaces `kubectl get namespaces`

If everything works then you should see some output like so:

```
> kubectl get namespaces
NAME              STATUS   AGE
default           Active   32m
gmp-public        Active   31m
gmp-system        Active   31m
kube-node-lease   Active   32m
kube-public       Active   32m
kube-system       Active   32m
```

If there are any errors then the system is NOT setup and configurated correctly

## Releasing a cluster

This will release all the nodes allocated for the cluster.  Note:  There is NO COMING BACK FROM THIS

`make dev.down.infra`

Expected Time: ~15 min
