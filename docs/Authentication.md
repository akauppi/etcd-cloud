# Authentication

Access to etcd v3 can be restricted by users and roles. It's described in [Role-based access control](https://coreos.com/etcd/docs/latest/op-guide/authentication.html) (etcd manual).

By default, authentication is switched off. Creating users, roles, and switching on authentication is done using the `etcdctl` command line tool (not declaratively, or when launching `etcd`).

## 1. Create roles

>Roles are granted access to a single key or a range of keys.

This is why we create roles before users (opposite order than in the etcd manual). Roles are what can be done. Users are who can do those things.

For example:

```
$ ETCDCTL_API=3 etcdctl role add a-read
```

No confirmations are asked. Once you enable authentication, only certain users (those with `root` role) will be able to edit roles.

```
$ ETCDCTL_API=3 etcdctl role grant-permission a-read --prefix=true read /a/
Role a-read updated
```

There, we gave read access for role `a-read` to all keys starting `/a/`.

Note: Using folder notation is just a habit. Etcd v3 uses flat key names, so our prefix could be `a/`, `a.`, or `a`-anything. It's not a folder.

||
|---|
|Note: Changing roles from the command line likely means there is no logging of these actions. This matters for auditing: one cannot ask etcd, who granted or removed certain access.|


## 2. Create the `root` user

```
$ ETCDCTL_API=3 etcdctl user add root
Password of root: 
Type password of root again for confirmation: 
User root created
```

>The root user, which has full access to etcd, must be created before activating authentication.


## 3. Enable authentication

```
$ ETCDCTL_API=3 etcdctl auth enable
Authentication Enabled
```

Now, you cannot create new users any more: 

```
$ ETCDCTL_API=3 etcdctl user add b
...
Error: etcdserver: user name not found
```

You'll need to use the `root` account (or any other user granted the `root` role).

```
$ ETCDCTL_API=3 etcdctl --user=root user add b
Password of b: 
Type password of b again for confirmation: 
Password:         <-- for the root user
User b created
```

Hint: You can embed the pw into the command by `--user=root:<pw>` (but realize it gets stored in command history).


Now we're in production and the above commands can be used to create, modify, assign or delete users and roles.




## References

- etcd (v3) > Operating etcd clusters > [Role-based access control](https://coreos.com/etcd/docs/latest/op-guide/authentication.html)

