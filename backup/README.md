# Backup

Our aims:

- automated, scheduled backups
- manual restores, with clear instructions
- target: Google Cloud Storage

No automated restores because every restore involves likely loss of data.


## How v3 does it

The etcd v3 manual's section on [Distaster recovery](https://coreos.com/etcd/docs/latest/op-guide/recovery.html) is rather clear.

1. We create a snapshot of a cluster by `ETCDCTL_API=3 etcdctl snapshot save <filename.db>`
2. Create a new cluster (..I think)
3. Run `ETCDCTL_API=3 etcdctl snapshot restore <filename.db>`

Let's try it! :)

## Requirements

You have an etcd v3 cluster running, and some data has been written there, e.g.:

```
$ ETCDCTL_API=3 etcdctl get mykey
mykey
this is awesome
```

## Dive

Make a snapshot.

```
$ ETCDCTL_API=3 etcdctl snapshot save yay.db
```

Close the cluster.

```
$ sh/gke-cluster-delete.sh 
The following clusters will be deleted.
 - [cluster-123] in [europe-north1-b]

Do you want to continue (Y/n)?  

Deleting cluster cluster-123...\
```

```
Deleting cluster cluster-123...done.                                                                                                                                                   
Deleted [https://container.googleapis.com/v1/projects/guestbook-tutorial-207613/zones/europe-north1-b/clusters/cluster-123].
```

---

Note: Likely `kubectl delete -f sgotti/etcd.yaml` would do the same, but faster?

---

Re-open the cluster:

```
$ sh/gke-cluster-create.sh
...
Creating cluster cluster-234...done.                                                                                                                                                   
Created [https://container.googleapis.com/v1/projects/guestbook-tutorial-207613/zones/europe-north1-b/clusters/cluster-234].
...
NAME         LOCATION         MASTER_VERSION  MASTER_IP      MACHINE_TYPE  NODE_VERSION  NUM_NODES  STATUS
cluster-234  europe-north1-b  1.8.10-gke.0    35.228.90.104  f1-micro      1.8.10-gke.0  3          RUNNING

$ kubectl apply -f sgotti/etcd.yaml
```

Let's see that the etcd cluster is empty:

```
$ ETCDCTL_API=3 etcdctl get mykey
```

Then, let's do the restore:

```
$ ETCDCTL_API=3 etcdctl snapshot restore yay.db 
Error: data-dir "default.etcd" exists
```

<font color=red>tbd. Yeah, it's not like that. Something else. Finish later. :)
</font>




## Alternative: etcd-backup-operator

The `etcd-operator` has `etcd-backup-operator` and `etcd-restore-operator` in its "examples" folder.

Reasons to ignore them:

- we didn't start using `etcd-operator` and those <strike>seem</strike> are bundled together
- we don't want any automated restore (which is what it looks like...)
- it only "currently" supports S3 (we prefer Google, for now) 

  >Note that currently the `etcd-restore-operator` only supports restoring from backups saved on S3.

