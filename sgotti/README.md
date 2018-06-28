# sgotti

Solution from https://github.com/sgotti/k8s-persistent-etcd/tree/master/old .

- The "old" way is the preferred one, the author themselves mention this somewhere (it's due to a misunderstanding).

The original repo uses `go` and templating, to create the actual YAML file. We have copied just the end result, so please check the original location if you end up using this.

It's simply used for avoiding duplicates, so one can just as well edit the end result - only each edit must be repeated three times. 


||||
|---|---|---|
|?|Can use latest|Likely, sample uses `3.2.3`|
|?|Access control||
|&check;|Persistence over availability|
|?|Backups|

## Try it out

```
$ kc apply -f etcd.yaml 
service "etcd-0" created
statefulset "etcd-0" created
service "etcd-1" created
statefulset "etcd-1" created
service "etcd-2" created
statefulset "etcd-2" created
```

Now, what happened?  Let's see if we can reach that etcd cluster.

```
$ kc get svc
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)             AGE
etcd-0       ClusterIP   10.7.250.166   <none>        2379/TCP,2380/TCP   7m
etcd-1       ClusterIP   10.7.251.28    <none>        2379/TCP,2380/TCP   7m
etcd-2       ClusterIP   10.7.252.119   <none>        2379/TCP,2380/TCP   7m
...
```

There is no external IP there.

We can come around that by Kubernetes port-forwarding, but eventually, need to set up Internet exposure and access restrictions, to be useful.


### Access with port-forwarding

```
$ kubectl port-forward etcd-0-0 2379:2379
Forwarding from 127.0.0.1:2379 -> 2379
```

This command relays our local port 2379 to one of the Kubernetes pods.

In another terminal:

```
$ ETCDCTL_API=3 etcdctl put mykey "this is awesome"
OK
$ ETCDCTL_API=3 etcdctl get mykey
mykey
this is awesome
```

Seems to be running. 😀

Now, you cannot use port forwarding in production and it only reaches one pod, not the cluster as such. So we want to set up proper access to the cluster.

## Access

