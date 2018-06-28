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

