# etcd in cloud

## Blah blah

[etcd v3](https://coreos.com/etcd/) is a wonderful distributed key-value store. Its main use is as the underpinnings of Kubernetes (to store central state about the system), but there are also uses for such store at the application level.

However, Kubernetes does not expose the system's etcd cluster to applications so such needs to be run separately.

This domain seems more split and unready than etcd itself. There are multiple approaches, both technically (raw hacks, helm charts, Kubernetes operators) and by the use case (do you need v2 support, how is persistence done, how important is scaling up/down of the cluster size).

All in all, in 2018, it's still messy and immature.

## Shopping list

What we want is an etcd v3 cluster for applications to store and watch some data.

We value:

- Using the latest version of etcd (now 3.3.8). [^1]
  - This is mostly a vanity goal, but it just feels right to be able to apply the latest main version.
- Access control
  - We wish to have some mechanism (tokens, certificates) to manage read/write access, preferably by the keys
- Persistence over availability
  - This is important and not to be taken for granted. It comes up in the discussions of etcd operator, and there seems to be cases, where things would get (automatically?) restored from backups, instead of waiting for nodes to come back up.
  - Actually...
- Backups
  - We want backups to be automatically done, at scheduled intervals (e.g. to a cloud basket).
  - Restores must always be manual.

Our application should be able to access the etcd cluster, with:

- URL
- access token or similar
- key range

i.e. there's no piping or port forwarding involved, but the service is clearly "on the cloud", reachable over public Internet.

  
[^1]: At the time of writing (Jun 2018), etcd-operator only supports 3.2, not 3.3. Latest version is 3.3.8.


## Requirements

You should have access to a Kubernetes cluster. See `docs` folder for how to set that up.

```
$ kubectl get pods    
...something meaningful...
```


## Alternatives

Each of these may deserve a directory in the repo. We want to try them out, evolve them, compare them.

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




## References

- [Deploying a real persistent/durable etcd cluster inside kubernetes](https://sgotti.me/post/kubernetes-persistent-etcd/) (blog, Jul 2017)






