# DevOps Workflow

We all love the idea of complex CI/CD systems that do everything for you with little to no interaction however that is not exactly how we roll here at Rooster ship.

## CI - Yes

We want to have Github build our packages for us which is cool

## CD - No

The simple fact is we are too small to invest in some fancy CD system.  Currently once a build has been "approved" it will then be manually deployed to the cluster.  This is for 3 reasons:

- CD systems fail sometimes so from my past experience I end just watching the github bot do it's thing anyway.  NOTE:  I totally get the security argument here that by having github do this I don't have to share credientals or bottle on one person but for now that is not a problem.
- Our security posture with SA is not GREAT so I would prefer NOT so share those keys/tokens all over the place.
- We are not ready for final production deployment and when that time comes we will need to rethink our strategy here so let's just keep it simple

## Github

Github will be used to build the packages and upload to GCP.

## GCP

Hosting of registery and running of live service (kubernetes).


## Example Deployment

This is a walkthrough of a first time deployment.  Since it can be a bit tricky with some of the step but most of these should be a one time deal.

### Step 0 Auth into Google

For pulumi and many of our steps to work you will need gcloud install and login to it.  Because this step must be done a lot we have added a command to help:

```
make login
```

Run this each day you need to access the kubernetes environment and the command should work.

### Step 1 Deploy the Base

This is the base setup that must exists regardless of the Kubeclusters, etc.

```
cd devops
make up.base
```

### Step 2 Setup Docker Access

To have docker connect and talk to these repos we need to tell it how to map the name correctly.  Assuming for a moment that the deployment is using `us-central1` you would run the command:

```
gcloud auth configure-docker us-central1-docker.pkg.dev
```

### Step 3 Deploy the Infrastructure

This is the kube cluster and any service accounts which must be setup.  For this example we are going to assume we are deploying the development cluster.

```
cd devops
make up.dev.infra
```

This step can take some time since since it allocating a GKE cluster and then replacing the node pool with machine types defined in the yaml file.

### Step 4 Register the Kubernetes Cluster

Next we need to tell our local Kubectl how to talk to the kubernetes cluster.  This done by
executing the command:

```
gcloud container clusters get-credentials <CLUSTER_NAME> --region <CLUSTER_REGION>
```

However it is a pain to remeber and share so we added a command to the root level make file.

#### Edit Make file

Look for the ouput  `cluster::name` from Step 3.

Open and edit the root level Make file and change out the values:

```
GKE_CLUSTER := <VALUE FROM STEP 3>
GKE_REGION := <WHERE THE CLUSTER WAS DEPLOYED>
```

#### Execute make command

Now run the make command `auth` like so

```
make auth
```

After this you local kubectl should be pointed to the correct cluster

### Step 5 Deploy the Environment

For a cluster there are 3rd party services that are are needed to run such as postgres, redis, rabbitmq, etc, etc.  The environment devops scripts sets all that up.  This is pretty short in comparison to step 3:

```
cd devops
make dev.up.env
```

### Step 6 Deploy the Contracts

PRIMER ON HOW TO DEPLOY THE CONTRACTS NEEDED

### Step 6 Build the Images

Now that we have the local environment setup and ready to go we need to build the images and publish them to our GCP image registry.  To do this you only need to the following:

```
make build
```

### Step 7 Deploy the images

Next we need to deploy the application code..

```
cd devops
make dev.up.app
```

### Step 8 Deploy the Ingress

Allow access to the system

```
cd devops
make dev.up.ingress
```

### Step 9 Verify build.

Goto [https://dev.wrilya.com](https://dev.wrilya.com) and check that the game is running.