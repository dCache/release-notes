
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
- Postgres SQL Server 9.5 or later
- ZooKeeper version 3.5 (in case of a standalone ZooKeeper installation)

Installing dCache
All dCache packages are available directly from our website’s dCache releases page, under the Downloads
section.

>     
>    rpm -ivh https://www.dcache.org/old/downloads/1.9/repo/7.2/dcache-7.2.19-1.noarch.rpm 

Installing PostgreSQL

In general, the database may be deployed on the same node as dCache or on some dedicated machine with
db-specific hardware. The decision involves trade-offs beyond the scope of this document; to keep
this chapter simple, we are assuming the database will run on the same machine as the dCache services that
use it.

The next step is to  initialise the database the service. Note that we do not start
the database at this point, as we will make some tweaks to the configuration.

> /usr/pgsql-10/bin/postgresql-10-setup initdb


The simplest configuration is to allow password-less access to the database. Hier we assumes this to be the case.

To allow local users to access PostgreSQL without requiring a password, make sure the following three lines
are the only uncommented lines in the file **/var/lib/pgsql/10/data/pg_hba.conf**

      ...
    # TYPE  DATABASE    USER        IP-ADDRESS        IP-MASK           METHOD
    local   all         all                                             trust
    host    all         all         127.0.0.1/32                        trust
    host    all         all         ::1/128                             trust
    host    all         all         HostIP/32          trust

