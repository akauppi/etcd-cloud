# Setting up Kubernetes on Google Cloud

## 1. The basics

Follow [Quickstart for macOS](https://cloud.google.com/sdk/docs/quickstart-macos) (or similar for your OS).

Note that the `google-cloud-sdk` folder needs to be placed somewhere permanent (e.g. under ´~/bin`), before running the `install.sh` script.

You should now have the `gcloud` tool available.

### Kubectl

Install the `kubectl` component:

```
$ gcloud components install kubectl
```

You can list the components by:

```
$ gcloud components list
```

<font size="-1">Based on: https://cloud.google.com/sdk/docs/components </font>

## 2. Enable Kubernetes Engine

See https://cloud.google.com/kubernetes-engine/docs/quickstart

In creating the cluster, pick:

- Zonal
- zone close to you (does not really matter)
- Machine type: micro (we are just testing)

||
|---|
|Note: After you are done with testing, close the cluster to keep billing down.|

Since we created the cluster in the browser, you need to do this to tie its credentials to `kubectl`:

```
$ gcloud container clusters get-credentials cluster-1
Fetching cluster endpoint and auth data.
kubeconfig entry generated for cluster-1.
```

If you create on command line (see below), this is done automatically.

## 3. Try it!

```
$ kubectl get pods
No resources found.
```

We are not teaching Kubernetes, as such. It's fairly easy, once you get the concepts right (deployment, service, pods etc.).

Deployments can be done either from the command line (like how Google's quickstart shows), or - normally - from `.yaml` files.


## Command line

There may be scripts for doing this under the `sh/` folder.

### Creating a cluster

```
$ gcloud container clusters create cluster-123 --machine-type f1-micro --num-nodes 3 --disk-size 20
...
Creating cluster cluster-123...\                                                                                                                                 
```

After a while, the cluster should be up.

```
...
NAME         LOCATION         MASTER_VERSION  MASTER_IP      MACHINE_TYPE  NODE_VERSION  NUM_NODES  STATUS
cluster-123  europe-north1-b  1.8.10-gke.0    35.228.161.25  f1-micro      1.8.10-gke.0  3          RUNNING
```

### Listing the current clusters

```
$ gcloud container clusters list
```

### Removing a cluster

```
$ gcloud container clusters delete cluster-123
```

||
|---|
|NOTE: Remember to delete a cluster once you don't need it for testing/development purposes. Otherwise, it keeps billing.|

## Cost estimate

The setup is fairly low cost, around 1 eur/day or less (GKE Jun 2018).

- three `f1-micro` instances
- three 1GB persistent disks

<font color=red>tbd. Should make a more detailed table here, and rough comparison with some cloud key/value store costs, e.g. Google Cloud Storage</font>


## References 

- https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-cluster
- https://cloud.google.com/sdk/gcloud/reference/container/clusters/create 

- [Kubernetes: Moving to the Google Cloud](https://www.youtube.com/watch?v=4WP_uh1Ro4E) (Youtube, 18:28) by CoderJourney

  Better than Google's own.
