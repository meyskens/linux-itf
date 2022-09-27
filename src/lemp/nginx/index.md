# NGINX Web Server

:::warning
In Linux Webservices the Apache 2 server is still used. This chapter on Nginx is only for reference.
:::

![nginx logo](./nginx.png)

## Web Servers

What is a web server? As the name implies, a web server is a program that can host a web page or web application.
A web server will serve user websites, usually using the Hypertext Transfer Protocol (HTTP) for with files for static sites alss HTML, CSS, images, video,... as well as dynamic
content with PHP, CGI scripts, etc.

HTTP runs on TCP and uses port `80`. It is the default protocol in our web browser. Later we will also look at HTTPS, HTTP over a TLS connection on TCP port `443`, and provides support for HTTP/2 which can "multiplex" connections for more efficient data transfer.

### HTTP Request

Before we go into setting up an HTTP server, let's see what a typical HTTP request looks like.
We use the Linux program `curl` to create an HTTP request. cURL allows us to make HTTP requests from the command like, we will also use option `-v` to see the verbose logging to learn more about HTTP.

```bash
curl -v http://simple-http.stuvm.be
```

We get the following response from our server:

```
* Trying 193.191.186.132:80...
* Connected to simple-http.stuvm.be (193.191.186.132) port 80 (#0)
> GET / HTTP/1.1
> Host: simple-http.stuvm.be
> User-Agent: curl/7.74.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: text/html
< Date: Sun, 13 Feb 2022 13:41:29 GMT
< Etag: W/"62090a7b-76"
< Last-Modified: Sun, 13 Feb 2022 13:41:15 GMT
< Server: nginx/1.18.0 (Ubuntu)
< Transfer-Encoding: chunked
<
<html>
<head>
  <title>Hello</title>
</head>
<body>
  <h1>Hello World!</h1>
</body>
</html>
* Connection #0 to host simple-http.stuvm.be left intact
```

In the first part we see that cURL is going to make a TCP connection, after this we see our HTTP **request**. This request is what our client is going to ask the server `GET / HTTP/1.1` indicates that we want to make a GET request to retrieve data on the path `/`. Below we find headers that give more information about our request such as what hostname as well as our user agent.

:::warning note
HTTP often works with "verbs". These verbs indicate which action the server must perform.

- `GET` is for data retrieval
- POST` is for sending data
- PUT` is for changing data
- Delete` is for deleting data
- `HEAD` is for fetching headers but not displaying content

:::

This is followed by a response from the server, starting with an HTTP version and a status code. This code indicates whether the request was successful or not. Then there are headers back giving more information about the response just like our request. At the end we see the content of the web page!

:::warning note
HTTP Status codes are 3 digits, the 1st digit indicates the type of response.
Some commonly used codes are:

- `200` is a successful response
- `400` is an erroneous request
- `401` is that authentication is required
- `404` is a response indicating that the page was not found
- `500` is a response indicating that a server error occurred
- `418` indicates that we are dealing with a [teapot](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/418)

A dry list to block unfortunately.... [Hope these cats can still make your day fun](https://http.cat/)
:::

## NGINX Installation

You can easily install NGINX via Ubuntu's standard, built-in software repository!

Before doing this, make sure (preferably) that we have the latest
content in that same software repository:

```bash
sudo apt update.
```

You may also immediately upgrade all installed software with

```bash
sudo apt upgrade
```

We proceed to install NGINX with

```bash
sudo apt install nginx
```

Ubuntu will immediately start the software in the background, but we
are going to check this briefly.

```
sudo systemctl status nginx
```

This command should return a status via 'systemd'-init system
about this service should return.
Does this more or less match the following? Then you have successfully installed and started your NGINX!
`systemctl status` gives us a lot of information about services, more on that to the SystemD chapter.

### View Server

Now that we know our server is running we can take a look at it. We used cURL to an HTTP server above. We now test dut on `localhost` the address that defaults to your loopback interface.

On the server itself we run the following:

```bash
curl -v http://localhost
```

We notice that we get a response with a "Welcome to NGINX" Web page.

```
$ curl -v http://localhost
* Trying 127.0.0.1:80...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 80 (#0)
> GET / HTTP/1.1
> Host: localhost
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Server: nginx/1.18.0 (Ubuntu)
< Date: Sun, 13 Feb 2022 13:39:27 GMT
< Content type: text/html
< Content-Length: 612
< Last-Modified: Sun, 13 Feb 2022 13:36:44 GMT
< Connection: keep-alive
< ETag: "6209096c-264"
< Accept-Ranges: bytes
<
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: tahoma, verdana, arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
* Connection #0 to host localhost left intact
```

#### Customize content

By default, the content of our site can be found in `/var/www/html/`.
We'll take a quick look at what's in here:

```bash
ls /var/www/html/
```

```
index.nginx-debian.html
```

Ubuntu (from Debian) has already included a small web page. We'll quickly modify this one:

```bash
cd /var/www/html/
sudo rm index.nginx-debian.html
sudo nano index.html
```

By default, `index.html` is the home page of your website. We'll quickly add a mini website with nano:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Hello World!</title>
  </head>
  <body>
    <h1>Hello World!</h1>
    <p>Welcome to my own web server!</p>
  </body>
</html>
```

After saving this and closing nano, we also give the correct permissions. By default our web server runs under the user `www-data` and the group `www-data`. We set these permissions on these files:

```bash
sudo chown www-data:www-data index.html
```

Now if you go to your site again you will see your own web page.

### Process management

We also give a quick general overview to manage the NGINX process in the future.
Try this out.

- stop web server: sudo systemctl stop nginx
- start web server: sudo systemctl start nginx
- restart web server: sudo systemctl restart nginx
- reload web server: sudo systemctl reload nginx
- Disable automatic start: sudo systemctl disable nginx
- Enable automatic start: sudo systemctl enable nginx

## Configuring NGINX

We are going to configure NGINX in the following steps, before we start with this we will look at what configuration files we have.

Directories:

- `/etc/nginx/` contains the configuration files
- `/var/www/html` the actual web content, which by default consists only of the default page you saw earlier. This directory can be changed by modifying NGINC configuration files.

Files:

- `/etc/nginx/nginx.conf` the main configuration file. This can be modified to make changes to the overall NGINX configuration. This file is responsible for loading many of the other files in the configuration directory.
- `/etc/nginx/sites-available/` the directory where virtual hosts for each site can be stored. NGINX will not use the configuration files in this directory unless they are attached to the `sites-enabled` directory.
- `/etc/nginx/sites-enabled/` the directory where enabled virtual hosts are stored on a per-site basis. Usually these are created by linking to configuration files located in the sites-available directory. NGINX reads the configuration files and links in this directory when it starts or reloads to compile a complete configuration.
- `/etc/nginx/modules-available/` and `/etc/apache2/modules-enabled/` these directories contain the available and enabled server extension modules, respectively.

## Logging

Logs are essential in servers, we'll look at this in more detail later in the course. But we already take a look at what NGINX offers us:

- `/var/log/nginx/access.log` by default every request on the web server is logged in this log file, NGINX Apache is
  configured to do something else.

  ```
  10.1.0.11 - - [13/Feb/2022:13:42:26 +0000] "GET / HTTP/1.1" 200 122 "-" "Mozilla/5.0 (compatible; Discordbot/2.0; +https://discordapp.com)"
  10.1.0.11 - - [13/Feb/2022:13:42:29 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:97.0) Gecko/20100101 Firefox/97.0"
  10.1.0.11 - - [13/Feb/2022:13:42:39 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:97.0) Gecko/20100101 Firefox/97.0"
  10.1.0.11 - - [13/Feb/2022:13:52:24 +0000] "GET / HTTP/1.1" 200 122 "-" "Mozilla/5.0 (Linux; Android 10; CLT-L29) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.87 Mobile Safari/537.36"
  ```

- `/var/log/nginx/error.log` by default all errors are recorded in this file.

## Virtual Hosts with NGINX

Virtualhosts solve a major problem. They make it possible to host multiple sites on 1 server. Better yet on 1 IP address! With the shortage of IPv4 addresses, we can already use this!

How do they work? Above we saw an HTTP request.

```
GET / HTTP/1.1
Host: simple-http.stuvm.be
```

Our browser is going to send the hostname along with all requests, based on this our server can decide which website to display!
This phenomenon is called "virtual hosting".

We find all our virtual hosts in `/etc/nginx/sites-available/` and `/etc/nginx/sites-enabled/`.

We view `/etc/nginx/sites-available/`

```bash
ls /etc/nginx/sites-available/
```

We see the following output:

```
$ ls /etc/nginx/sites-available/
default
```

Currently, we only see the default virtual host. We are going to add one of our own.

```bash
sudo nano /etc/nginx/sites-available/site-two
```

We will add the following conguration:

```
server {
	listen 80; # server on port 80
	listen [::]:80; # server on IPv6 port 80

	root /var/www/site-two; # directory of the website

	index index.html index.htm; # what files are your index

	server_name site-twee.rnummer.stuvm.be; # hostname of the site, CHANGE THIS

	location / {
		try_files $uri $uri/ =404; # give a 404 error if the page does not exist
	}
}
```

The NGINX configuration works with blocks indicated between `{}`. These blocks contain lines that are always terminated with a `;`.
In this we set up our `site-two.r<number>.stuvm.be` site to pull content from the `/var/www/site-two` folder.

Before we load the configuration, we need to create the site folder!

```bash
sudo mkdir /var/www/site-two
```

We also immediately add an index.html to this folder.

```bash
sudo nano /var/www/site-two/index.html
```

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Site Two</title>
  </head>
  <body>
    <h1>Site Two</h1>
    <p>This is my second website</p>
  </body>
</html>
```

Let's set the permissions on this folder a little bit more.

```bash
sudo chown -R www-data:www-data /var/www/site-two
```

Our second site is now ready but not yet active. We need to activate this site now.
We do this by creating a **symbolic link** to the configuration.

```bash
sudo ln -s /etc/nginx/sites-available/site-two /etc/nginx/sites-enabled/site-two
```

Now that everything is ready we'll test our configuration first.

```bash
sudo nginx -t
```

If you see the following, everything worked out!

```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

We can now ask NGINX to load this configuration:

```bash
sudo systemctl reload nginx
```

Now surf to `site-two.r<number>.stuvm.be` and you will normally see the contents of your second website.

## Next generation: Caddy

[Caddy](https://caddyserver.com/) is a recent open source Web server that is starting to gain quite a bit of market share anyway. Caddy is not written in C like Apache and NGINX but in Go. Go is a fast yet memory-safe programming language. This already makes Caddy safer while having good perfomance.

Caddy is gaining popularity due to the fact that essential features are already built in. For example, Caddy can independently request HTTPS Certificates. Caddy is also one of the first to support HTTP/2 and HTTP/3, and Caddy has a simple configuration syntax.

Caddy currently has a 0.1% market share.

## Next generation: HTTP/3

HTTP/3 stems from Google's QUIC protocol, just as HTTP/2 was based on Google's SPDY.
The main difference in HTTP/3 is that it does not use TCP but UDP with QUIC as a modern alternative to all the functions normally performed by TCP, making connections faster.

Currently 73% of browsers support HTTP/3[^http3browser] and 25% of all servers support HTTP/3[^http3server]. NGINX has supported a beta implementation for HTTP/3 since 2020.

![HTTP/3 schema](./http3.png)

[^http3browser]: figures from [caniuse.com](https://caniuse.com/http3)
[^http3server]: figures from [w3techs.com](https://w3techs.com/technologies/details/ce-http3)
