
+  [Installing a dCache instance](#installing-a-dcache-instance)  

   
     
     **Minimum System Requirements**
     -----------------------------

PREREQUISITES
-------------



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

Four main components
-------------

#### DOOR 
 - user entry points (WebDav, NFS, FTP, DCAP, XROOT)
 
#### PoolManager
- request distribution uni
#### Namespace
- metadata DB, POSIX layer
#### POOL
 - data storage nodes, talk all protocols

## Minimal Setup
- DOOR  - webdav
- PoolManager
- Namespace - cleaner
- Pool


    
