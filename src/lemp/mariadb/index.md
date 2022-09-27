#MariaDB

When we host an application we are guaranteed to work with data. Managing data is an important task that is usually done by a database.
Our database server is going to store, manage, search and access data for us to users and systems.

A software package that will host databases is known there a Database Management System (DBMS)

## Databases

Databases come in all shapes and sizes. The right choice depends mainly on the type of data you want to store. But also perfomance and the amount of data play a major role in the choice. We will take a look at different types of databases:

- Relational database

  - Uses Structured Query Language (SQL)
  - Most known and used databases

- NoSQL database (Not only SQL / non SQL)
  - Key/value database
    - Redis
    - Memcached
  - Document Store
    - MongoDB
    - CouchDB
  - Column Store
    - Cassandra
  - Graph database
    - Neo4j

### Key / value database

Data is stored only as a key that points to certain data (value).
However, there are some conditions such as that the key is unique and that the value is not empty.

We see these tremendously common for caching data. For example, we can store complex calculation results per user (for example, a bank account balance). These results can then be quickly called with a unique key (such as an account number). Many key/value stores also offer the possibility of storing data in RAM memory.

![key-value-database](./kv.png)

Examples of key/value databases:

- [Redis](https://redis.io/)
- Memcached](https://memcached.org/)
- Etcd](https://etcd.io/)

### Document Store

A document store database stores each record as a (semi)structured document.
All Relevant info about an object is stored in the document. Often no relationships, unlike a relational database, are established between objects. But in modern document stores, relationships can be established.

A big advantage of our document store is that they are enormously easy to scale horizontally. By this we mean that we can easily spread the database across different servers with the minimal effort of our database server to know which objects are where in the database.

Ability to write queries can usually be done in a matching language for what our documents are written in. For example, XQuery can query XML, and we can write JavaScript queries for JSON (JavaScript Object Notation) documents.

Documents are often written in JSON (JavaScript Object Notation):
This is an example of a BSON (Binary method on JSON to succeed) document in MongoDB:

```json
{
  "_id": "5a0d7e9d0e7d6b1d2a8b4567",
  "name": "John Doe",
  "age": 30,
  "address": {
    "street": "Main St",
    "city": "New York",
    "state": "NY",
    "zip": "10001"
  },
  "children": [
    {
      "name": "Jane Doe",
      "age": 10
    },
    {
      "name": "Jack Doe",
      "age": 8
    }
  ]
}
```

Known servers are:

- [MongoDB](https://www.mongodb.com/)
- Apache CouchDB](https://couchdb.apache.org/)
- Amazon DocumentDB (AWS)](https://aws.amazon.com/documentdb/)

### (Wide) Column Store.

Data in a column store is stored in columns. A column family contains one or more rows.
Each row can itself have a different number of columns, with a different number of data types.

Thanks to a hierarchical structure, we can quickly and easily find and store data. Over a document or key/value database, we can apply more structure that our relational database.

![wicde column store](./wcol.png)

Well-known servers are:

- [Google Cloud Bigtable](https://cloud.google.com/bigtable/)
- Apache Cassandra](https://cassandra.apache.org/)
- Apache HBase](https://hbase.apache.org/)

### Graph database

A graph database uses a graphical model of nodes and relationships between nodes to store data.
The data has no schema, the important thing is that the nodes and relationships have a unique identifier.
Graph databases have not been around for a huge amount of time but have a population due to large users like Facebook.

Graph databases have their own query language like GraphQL to retrieve data.

![graph database](./graph.png)

Well-known software:

- [Neo4j](https://neo4j.com/)
- OrientDB](https://www.orientdb.org/)
- Dgraph](https://dgraph.io/)

### Relational database

Relational databases you normally know from the SQL class. Here we store data in tables with rows and columns. There are different relationships between these tables.

![relationaldatabase](./relational.png)

Known software:

- [MySQL](https://www.mysql.com/)
- MariaDB](https://mariadb.org/)
- Oracle Database](https://www.oracle.com/database/technologies/)
- Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server/)
- PostreSQL](https://www.postgresql.org/)

## MariaDB

In our course we use MySQL. MySQL is part of the LAMP stack and is hugely popular for use with PHP applications due to good integration. The MySQL server is also easy to use.

MySQL was first developed independently with an open source license, with a proprietary version maintained by MySQL AB. This company was acquired by SUN Microsystems, which itself was acquired by Oracle.
Oracle's reputation is already not too good in the open source world, also that Oracle already has its own database was not a good prediction.
Therefore, the founder of MySQL [Michael "Monty" Widenius](https://en.wikipedia.org/wiki/Michael_Widenius) decided to "fork" MySQL to MariaDB.

:::info Name
Where did the name MariaDB come from? Monty had 3 children: My (Finnish maiden name), Maria and Max.
My and Maria were immortalized in the MySQL world. Max also got his own database in the SAP world: MaxDB.
:::

MariaDB has been around since 2009. Beyond the vision of open source, the two have moved slightly in a different direction. But the priority remains to be a "drop in" replacement for MySQL. We are also going to notice this in the installation that they work 99% the same and all commands are compatible with MySQL.

Still, there are minor differences:

- MariaDB adds new SQL queries that are not in MySQL.
- MariaDB adds caching for performance.
- MariaDB adds support for Oracle's SQL dialect.
- MySQL has paid features for better scaling
- MySQL allows to limit super users

### Installation

Before installation, update the package index:

```bash
sudo apt update
```

Next, we are going to install MariaDB server:

```bash
sudo apt install mariadb-server
```

As always, we check that the server has started:

```bash
sudo systemctl status mariadb
```

MariaDB is now running! MariaDB runs on TCP port `3306` by default.
We are not going to set firewall rules for MariaDB. We should keep our database on the server itself so that the public Internet cannot get directly to the database server. In the following lessons we will connect our PHP code to the database.

### Configuration

Now that we have a MariaDB server, we are going to configure it! We are going to work exceptionally little with the configuration files themselves. All configuration for daily use is in the database itself!

Nevertheless, we are going to find some parameters in configuration files, in `/etc/mysql/` (this directory will remain so for compatibility with MySQL).
Here we find:

- `my.cnf` this is the mysql compatible configuration
- `mariadb.cnf` dirt is the MariaDB specific configuration

We can also find logs in `/var/log/mysql/`.
In turn, all our data is in `/var/lib/mysql/`.

MariaDB provides a handy script to facilitate configuration!
First, we are going to configure MariaDB to be secure:

```bash
sudo mysql_secure_installation
```

(by default there is no root passowrd, so we're going to set that up)

With this we set a root password **for MariaDB** so this is a different password than can our Linux server.

```
NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user. If you've just installed MariaDB, and
haven't set the root password yet, you should just press enter here.

Enter current password for root (enter for none):
OK, successfully used password, moving on...

Setting the root password or using the unix_socket ensures that nobody
can log into the MariaDB root user without the proper authorization.

You already have your root account protected, so you can safely answer 'n'.

Switch to unix_socket authentication [Y/n] y
Enabled successfully!
Reloading privilege tables...
 ... Success!


You already have your root account protected, so you can safely answer 'n'.

Change the root password? [Y/n] y
New password:
Re-enter new password:
Password updated successfully!
Reloading privilege tables...
 ... Success!


By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] y
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] y
 ... Success!

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```

### Queries

Now that our database is secure we are going to run a query.

First we test if we can connect to MariaDB by asking for the version number:

```bash
sudo mysqladmin version
```

```
mysqladmin Ver 9.1 Distrib 10.5.13-MariaDB, for debian-linux-gnu on x86_64
Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Server version 10.5.13-MariaDB-0ubuntu0.21.10.1
Protocol version 10
Connection localhost via UNIX socket
UNIX socket /run/mysqld/mysqld.sock
Uptime: 1 min 32 sec

Threads: 1 Questions: 486 Slow queries: 0 Opens: 171 Open tables: 28 Queries per second avg: 5,282
```

If this works we can log into the MariaDB shell:

```bash
sudo mysql -u root -p
```

`-u` gives our user, with `-p` we say we want to use a password.

Now we get a MariDB shell:

```
Welcome to the MariaDB monitor.  Commands end with ; or .
Your MariaDB connection id is 56
Server version: 10.5.13-MariaDB-0ubuntu0.21.10.1 Ubuntu 21.10

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]>
```

In this shell, we can now start running SQL queries! Make sure you never forget the `;`, this ends the query.

```sql
SELECT * FROM mysql.user;
```

The answer is quite large and cluttered, as the shell is not the ideal place for data queries. If you want to dive into SQL, we recommend a GUI tool such as [MySQL Workbench](https://www.mysql.com/products/workbench/).

We're going to look at some queries specifically around database management:

```sql
SHOW STATUS;
```

This gives us the status of the MariaDB server.

```sql
SHOW DATABASES;
```

This shows us all the databases.

`````sql
SHOW TABLES FROM mysql;
```

This shows us all the tables in the ``mysql` database.

```sql
SHOW PROCESS LIST;
```

Shows all database processes, so we can see, for example, if there are queries running and for how long.

To exit the shell we do `quit`.

### Manage users

We want to add different users or applications to the application. We can do this in SQL.

We open our SQL shell again:

```bash
sudo mysql -u root -p
```

Adding users we do with `CREATE USER`:

````sql
CREATE USER 'test'@'%' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
```

`'test'@'%'` means that the user `test` will be able to log in to all hosts (`%`). With `IDENTIFIED BY` we give the user a password.

We leave the shell and try to log in with the new user:

```bash
sudo mysql -u test -p
```

The user has not been given permissions to anything yet, so we just leave the shell.

Do we want to delete the user? Then we use `DROP USER`:

```sql
DROP USER test;
```

### Databases

We need several databases, usually we work with 1 database per application.

We create a database with `CREATE DATABASE`:
We open our SQL shell again:

```bash
sudo mysql -u root -p
```

Followed by:

````sql
CREATE DATABASE mydb;
```

Deleting a database is done with `DROP DATABASE`:

```sql
DROP DATABASE mydb;
```

### Permissions

We have a database and a user now. Now we want to set permissions that our user can access our database.
Usually we work with 1 user per database so we can limit who can see what.

Giving permissions to a user we do with `GRANT`:

```sql
GRANT ALL PRIVILEGES ON mydb.* TO test;
```

This gives full rights to all tables of mydb (`mydb.*`) to the user `test`.

After each change to the database, we must reload the privileges with `FLUSH PRIVILEGES`:

```sql
FLUSH PRIVILEGES;
```

MariaDB is going to cache permissions in memory to answer quickly we must therefore say that they have been modified.

We can also view all permissions for user `test`:

```sql
SHOW GRANTS FOR test;
```

Do we want to take away the permissions? Then we use `REVOKE`:

```sql
REVOKE ALL PRIVILEGES ON mydb.* FROM test;
```

### Backup

Backing up a website is simple, you take a copy of the files and put them in a backup folder. A database, however, is more difficult. Our files in `/var/lib/mysql` are constantly changing, and they also vary by MariaDB version.

So we need to be able to "export" the database to a backup. To do this, we need the command `mysqldump`.

```bash
sudo mysqldump mydb > mydb.sql
```

`mysqldump` is going to read all the data from the database and convert it into SQL queries that are going to generate all the data back!

This allows us to easily restore our database.
We open our SQL shell again and create a new database:

```bash
sudo mysql -u root -p
```

````sql
CREATE DATABASE myNEWdb;
quit
```

Now we can import the backup with ``mysql``:

```bash
sudo mysql -u root -p myNEWdb < mydb.sql
```

`````
