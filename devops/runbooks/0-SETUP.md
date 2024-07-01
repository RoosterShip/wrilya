# DevOp Setup

Guide for setting up a Wrilya deployment.

## Google Cloud Setup

Setting up GCP is kind of outside the scope of this document and currently left as an exercise for the reader to figure out.  But the biggest issues to resolve will be getting your project setup, service account fully and ensuring it has the correct permission.

## Google Cloud CLI Setup

Setup your local environment as defined [here](https://cloud.google.com/sdk/docs/install).

NOTE:  Install the full debian package, not a snap if you are on Ubuntu.  Here is the [instructions](https://cloud.google.com/sdk/docs/install#deb).

After setup is done run gcloud init

```
gcloud init
```

This will ask you auth into your GCP account and select the project which will be used for deploying the service.

## Google Cloud CLI Init

`gcloud auth application-default login`

working with the cluster

```
gcloud container clusters get-credentials <CLUSTER_NAME> --region <CLUSTER_REGION>
```

Example:
```
gcloud container clusters get-credentials wrilya-gke-cluster-dev-a97bdd5 --region us-central1
```
