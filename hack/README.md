# etcd hack

Source: https://github.com/coreos/etcd/tree/master/hack/kubernetes-deploy

## Requirements

You have Kubernetes set up, i.e. `kubectl` works.

## Steps

```
$ kubectl create -f etcd.yml 
service "etcd-client" created
pod "etcd0" created
service "etcd0" created
pod "etcd1" created
service "etcd1" created
pod "etcd2" created
```

The cluster is now up, and it's running latest (3.3) etcd:

```
$ kubectl logs etcd2
2018-06-28 09:07:44.775959 N | etcdserver/membership: updated the cluster version from 3.0 to 3.3
2018-06-28 09:07:44.781923 I | etcdserver/api: enabled capabilities for version 3.3
...
```

## Access

We don't currently have access to the cluster over the public Internet:

```
$ kubectl get svc
NAME          TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)             AGE
etcd-client   ClusterIP   10.7.246.45    <none>        2379/TCP            10m
etcd0         ClusterIP   10.7.254.135   <none>        2379/TCP,2380/TCP   10m
etcd1         ClusterIP   10.7.249.33    <none>        2379/TCP,2380/TCP   10m
etcd2         ClusterIP   10.7.244.94    <none>        2379/TCP,2380/TCP   10m
kubernetes    ClusterIP   10.7.240.1     <none>        443/TCP             26m
``` 

<font color=red>TBD.</font>

