# PHP

:::warning
In Linux Webservices the Apache 2 server is still used. This chapter is written for Nginx, the exact installation would be different.
:::

![PHP logo](./php.png)

PHP is a programming language specifically designed for web development.PHP was designed by the Rasmus Lerdorf in 1994.
PHP actually stands for "Personal Home Page. Now that is not a good advertisement for a growing language, which is why it was later changed to "PHP: Hypertext Preprocessor."

PHP code is usually used on a server in CGI mode. This involves compiling and executing PHP code with each request to the server, the output of this script is then sent to the web browser. Usually this is then in the form of a web page.

According to W3Techs, by January 2022, PHP will be used by 78.1% of all websites for which we know the server-side programming language.
PHP version 7.4 is the most widely used version. Support for version 7.3 ended on Dec. 6, 2021. Currently version 8.1 is the most recent, version 8.0 has some major changes focused on performance such as adding a JIT (Just in Time) compiler.

## PHP-FPM

We usually work with the PHP FastCGI Process Manager in NGINX setups. FastCGI is a small improvement on classic CGI that removes overhead and allows multiple processes. PHP-FPM takes our FastCGI a step further and is going to manage processes, it is already going to run a number of processes with the PHP language that are going to handle various requests from NGINX.
This way we can also easily start running different PHP versions on a server.

This system is going to make it possible to manage how many PHP processes we are going to run and make it possible to handle requests quickly. For any PHP site that gets some traffic anyway, PHP-FPM is a component not to be missed!

## Installation

We install PHP-FPM via `apt`:

```bash
sudo apt update
sudo apt install php7.4-fpm php7.4-mysql
```

We install PHP version 7.4, the highest version in Ubuntu 20.04. We can install other versions this way as well.

We now check the status of the PHP-FPM server:

```bash
sudo systemctl status php7.4-fpm
```

## Configuration

Configuration for PHP-FPM can be found in `/etc/php/7.4/fpm/`.
We have some files here that we can look at:

- `php.ini`: this is the PHP configuration file. It contains everything about the PHP language, occasionally we need to modify something here for specific applications. We have some interesting settings here:
  - `memory_limit`: this contains the maximum memory limit for PHP.
  - `post_max_size`: here is the maximum size of a POST request.
  - `upload_max_filesize`: here is the maximum size of an upload.
  - `extension=`: lets you load PHP extensions.
- `php-fpm.conf`: this is the general configuration file for the PHP-FPM server.
- `/pool.d/www.conf` contains information about the "worker pool".

  - `user` and `group` determines under which user PHP is running.
  - `pm` determines the way to manage PHP processes. Here we can also choose some options such as:

    - `static` starts up a fixed number (`pm.max_children`) of workers, does not scale with traffic
    - `ondemand` no processes are started by default, but are started when a request comes in.
    - `dynamic` is a combination of `ondemand` and `static`. It starts up a number of processes and scales with larger traffic.

  - `pm.max_children`: this specifies the number of processes the PHP-FPM server is allowed to run.
  - `pm.start_servers`: this lists the number of processes the PHP-FPM server will start (only with `dynamic`).
  - `pm.min_spare_servers`: the minimum number of processes that must be "idle" to accommodate spikes (only with `dynamic`).
  - `pm.max_spare_servers`: the maximum number of processes that must be "idle" to accommodate peaks (only with `dynamic`).

For us, the default values are more than sufficient. We can start adjusting this with more traffic to our web server.

### Virtualhost with PHP

In the chapter of [NGINX](../nginx/) we set up our own website with a virtualhost. We are going to axe a virtualhost that will support PHP. We are going to create the virtualhost `/etc/nginx/sites-available/php-site`.

```
server {
	listen 80; # server on port 80
	listen [::]:80; # server on IPv6 port 80

	root /var/www/php-site; # directory of the website

	index index.php index.html; # what files are your index

	server_name php.rnummer.stuvm.be; # hostname of the site, CHANGE THIS

	location / {
		try_files $uri $uri/ =404; # give a 404 error if the page does not exist
	}

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.4-fpm.sock;
    }

    location ~ /php.ht {
        deny all;
    }
}
```

What is different here from our previous configuration?

- `index` is now `index.php` in front.
- `location ~ `.php$ `is a regex that only the pages that have a`.php` extension are passed to the PHP-FPM server.
  - `include snippets/fastcgi-php.conf` is going to set default FastCGI parameters
  - `fastcgi_pass unix:/run/php/php7.4-fpm.sock` indicates where our PHP-FPM server is located that will handle PHP for us.
- `location ~ /\.ht` with the `deny all` line indicates that files with .ht should not be opened
  - Many PHP applications use `.htaccess` and `.htpasswd` files for Apache to set up. Nginx does not know these files and just wants to forward these files to the browser, this may well leak sensitive data.

:::warning note
Now what is this `unix:/run/php/php7.4-fpm.sock`? This is a Unix socket. A Unix socket is an equivalent of a TCP port, the difference is that we do not have an IP and port but a path on our file system.
:::

We now create a directory where we can store our PHP applications:

```bash
sudo mkdir /var/www/php-site
```

We set our virtualhost to active:

```bash
sudo ln -s /etc/nginx/sites-available/php-site /etc/nginx/sites-enabled/
```

Also test wwwr configuration first:

```bash
sudo nginx -t
```

And finally, we reload our NGINX server:

```bash
sudo systemctl reload nginx
```

Now when we open our PHP site on our set hostname we see a 404 error.
We need to create another index page:

```bash
sudo nano /var/www/php-site/index.php
```

Here is a small piece of PHP code we are going to use:

```php
<?php

echo "hello and welcome to the world of PHP."
```

Now when we reopen our website we see our new message.

We are going to create one more page with PHP:

```bash
sudo nano /var/www/php-site/info.php
```

```php
<?php
phpinfo();
```

This gives us all the info of our PHP installation!

Next chapter we are going to use Wordpress as our PHP application.
