# etcd in cloud

## Blah blah

[etcd v3](https://coreos.com/etcd/) is a wonderful distributed key-value store. Its main use is as the underpinnings of Kubernetes (to store central state about the system), but there are also uses for such store at the application level.

However, Kubernetes does not expose the system's etcd cluster to applications so such needs to be run separately.

This domain seems more scattered and unready than etcd itself. There are multiple approaches, both technically (raw hacks, helm charts, Kubernetes operators) and by the use case (do you need v2 support, how is persistence done, how important is scaling up/down of the cluster size).

In this repo, we look at a couple of alternatives to get a persistent, replicated etcd v3 cluster up and running in the cloud, usable for applications to store their data.

## Shopping list

We value:

- **Using the latest version** of etcd (now 3.3.8) [^1]

  This is mostly a vanity goal, but it just feels right to be able to apply the latest main version.

- **Access control and multitenancy**
  
  We wish to have some mechanism (tokens, certificates) to manage read/write access, preferably allowing multitenancy (tokens being restricted to certain key spaces).
    
- **Persistence over availability**
  
  This is an important watershed as to how etcd is operated, and set up. Some use cases prefer availability, but we're leaning towards the "no data loss, ever" side.
  
  It also means that in case any restoring from backups is needed, that should always be manual, not automated (since it implies a potential loss of data). Ideally, we could have either or, as a configuration that the customer can flip.
  
- **Backups**

  We want backups, at scheduled intervals, e.g. to a cloud basket.

- **Accessible over the Internet**

  The application(s) will be at least initially running in the same Kubernetes cluster (and namespace) as etcd, but if we have proper authentication in place, doing business over the public Internet should be okay.

[^1]: At the time of writing (Jun 2018), etcd-operator only supports 3.2, not 3.3. Latest version is 3.3.8.


## Requirements

You should have access to a Kubernetes cluster. See documents under [docs](docs/) folder for how to set that up, e.g. using Google Kubernetes Engine.

```
$ kubectl version    
...
```

For working with the cluster, `etcdctl` command line tool. Easiest (on Mac) is to install the whole `etcd` package:

```
$ brew install etcd
$ ETCDCTL_API=3 etcdctl version
etcdctl version: 3.3.8
API version: 3.3
```

Note: We're only interested in "v3" of etcd. You would do well by exporting the `ETCDCTL_API=3`, to guarantee you always deal with version 3 (gRPC, not REST API). However, in this repo the env.var. is always explicitly mentioned.


## Alternatives

Each of these deserves a directory in the repo. We want to try them out, evolve them, compare them.

### "Hack" installation

Etcd itself has this:

- https://github.com/coreos/etcd/tree/master/hack/kubernetes-deploy

|||
|---|---|
|&check;|can use etcd 3.3.x|
|?|access control|
|?|persistence over availability|
|no|backups|

### etcd-operator (by CoreOS)

TBD.

### sgotti/k8s-persistent-etcd

Sgotti's [repo](https://github.com/sgotti/k8s-persistent-etcd) (GitHub) is connected to the post he's done in Jul 2017 (see references).

Somewhere, he writes that the `old` solution would be the better, so trying with it.

### heneise/k8s-etcd-cluster

https://github.com/heneise/k8s-etcd-cluster

TBD.


## Other key/value alternatives

There are other fish in the InterNet than etcd v3. If we fail to get the right feeling from running etcd, should consider these:

### Consul

### Cloud key/value stores

Service offerings from Google, AWS etc. Essentially any document data store would work, but we'd sacrifice some of the control and maybe the cost will be higher than when operating etcd within Kubernetes (needs to be compared).


## References

- [Deploying a real persistent/durable etcd cluster inside kubernetes](https://sgotti.me/post/kubernetes-persistent-etcd/) (blog, Jul 2017)

- Project Calico > Reference > [Setting up etcd Certificates for RBAC](https://docs.projectcalico.org/v3.1/reference/advanced/etcd-rbac/)




