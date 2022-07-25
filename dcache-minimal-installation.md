
+  [Installing a dCache instance](#installing-a-dcache-instance)  

   
     
     **Minimum System Requirements**
     -----------------------------

   ### Hardware:
- Contemporary CPU
- At least 1 GiB of RAM
- At least 500 MiB free disk space
   
 ### Software:
- OpenJDK 11
 > yum install java-11-openjdk
- Postgres SQL Server 9.5 or later

- ZooKeeper version 3.5 (in case of a standalone ZooKeeper installation)

## Installing PostgreSQL

To keep this simple, we are assuming the database will run on the same machine as the dCache services that
use it.

The simplest configuration is to allow password-less access to the database. Hier we assumes this to be the case.

To allow local users to access PostgreSQL without requiring a password, make sure the following three lines
are the only uncommented lines in the file **/var/lib/pgsql/10/data/pg_hba.conf**

      ...
    # TYPE  DATABASE    USER        IP-ADDRESS        IP-MASK           METHOD
    local   all         all                                             trust
    host    all         all         127.0.0.1/32                        trust
    host    all         all         ::1/128                             trust    
   
   
   ## Creating PostgreSQL users and databases    


> createuser -U postgres --no-superuser --no-createrole --createdb --no-password dcache
> createdb -U dcache chimera

And run the command `dcache database update`.



## Installing dCache
All dCache packages are available directly from our website’s dCache releases page, under the Downloads
section.

>     
>    rpm -ivh https://www.dcache.org/old/downloads/1.9/repo/7.2/dcache-7.2.19-1.noarch.rpm 



Four main components in dCache
-------------

All components are CELLs: they are independent and can interact with each other (send messages).


#### DOOR 
 - user entry points (WebDav, NFS, FTP, DCAP, XROOT) 
#### PoolManager
- request distribution uni
#### Namespace
- metadata DB, POSIX layer
#### POOL
 - data storage nodes, talk all protocols

### Configuration files

In the setup of dCache, there are three main places for configuration files:

-   **/usr/share/dcache/defaults**
-   **/etc/dcache/dcache.conf**
-   **/etc/dcache/layouts**

The folder **/usr/share/dcache/defaults** contains the default settings of the dCache. If one of the default configuration values needs to be changed, copy the default setting of this value from one of the files in **/usr/share/dcache/defaults** to the file **/etc/dcache/dcache.conf**, which initially is empty and update the value.


## Minimal Setup in this example - Grouping CELLs
# Single process:
- Shared JVM
- Shared CPU
- Shared Log files
- All components run the same version
- A process called DOMAIN


```ini
dcache.layout = mylayout
```

Now, create the file `/etc/dcache/layouts/mylayout.conf` with the
following contents:

```ini
dcache.enable.space-reservation = false

[dCacheDomain]
 dcache.broker.scheme = none
[dCacheDomain/zookeeper]
[dCacheDomain/admin]
[dCacheDomain/pnfsmanager]
 pnfsmanager.default-retention-policy = REPLICA
 pnfsmanager.default-access-latency = ONLINE

[dCacheDomain/cleaner]
[dCacheDomain/poolmanager]
[dCacheDomain/billing]
[dCacheDomain/gplazma]
[dCacheDomain/webdav]
 webdav.authn.basic = true
 

```

> **NOTE**
>
>In this first installation of dCache your dCache will not be connected to a tape sytem. Therefore please change the values for pnfsmanager.default-retention-policy and pnfsmanager.default-access-latency in the file **/etc/dcache/dcache.conf**.


>
>     pnfsmanager.default-retention-policy=REPLICA
>     pnfsmanager.default-access-latency=ONLINE


now we can add a new cell; Pool

 > dcache pool create /srv/dcache/pool-A poolA dCacheDomain

The `dcache` script provides an easy way to create the pool directory
structure and add the pool service to a domain.  In the following
example, we will create a pool using storage located at
`/srv/dcache/pool-1` and add this pool to the `dCacheDomain` domain.

```console-root
mkdir -p /srv/dcache
dcache pool create /srv/dcache/pool-1 pool1 dCacheDomain
|Created a pool in /srv/dcache/pool-1. The pool was added to dCacheDomain
|in file:/etc/dcache/layouts/mylayout.conf.
```

The `/etc/dcache/layouts/mylayout.conf` file should be updated to have
an additional `pool` service:


    