# LEMP Stack

In this chapter, we discuss the most widely used application of Linux servers. 94% of all web servers in the world use Linux[^stats]. We look at the possibilities for hosting dynamic and static sites, also we look at how to test them. Before we begin, we must and look at the capabilities of our setup.

In Windows land the choice is easy Microsoft has ASP.NET and IIS server. In our Linux landscape we see more options (many of these also work on Windows). Of course, much depends on the applications we want to host. In our course we will look at the most popular stack LAMP, but adapted to current trends and future-proofing we will make it the LEMP stack. Lots of new terms but let's start from the beginning.

## Type of websites.

Before hosting a Web site we need to think about what we want. Roughly speaking, there are two types of website: "static" and "dynamic".
Historically, the first Web sites were "static." The Web was designed with the phenomenon of pages of information that could link to other pages of information, from the same author or another author. Conceived in 1989 by Tim Berners-Lee, the Internet as we know it today took shape in the Hypertext Transfer Protocol (HTTP). The keyword is "Hypertext" the hyper here means that text is not linear, the user can wander around the net through "hyperlinks" (until you realize it is 3 a.m. and you are still on wikipedia reading random articles).

![first website](./cern.png)

HTTP had huge* popularity right from its inception for disseminating information.  
(* huge within academia, just those on the Internet, compared to competing protocols like Gopher)

Websites were as the author wrote them in HTML (HyperText Markup Language). Adding something yourself to the Web was not done by posting an Instagram photo but by hosting your own server, with your own content linking to other websites[^webring].

Back in the mid-1990s, the need for more came. Modifying websites manually requires a lot of work, soon "Server-side scripting" emerged (along with the introduction of client-side by Netscape's JavaScript). Languages such as ASP, ColdFusion, Perl, PHP, Python,... were designed to give Web servers a customized page for each user. Customized to current time, information from a database, even many sites offered their server statistics publicly.

![Stats SIN 1998](./sin98.png)

Around the year 2000, server-side scripting made a big impact on the world, sites like Amazon made it easy to winklel on the Internet. "Web 2.0" became a larger revolt where people could contribute to the Internet without having their own domain or server. From blogs with comments on "Blogger" or videos on YouTube. Later Netlog, MySpace, Facebook, Twitter,...

The dynamic web made it possible to modify content, host it, or even host entire applications on the Internet without modifications to your site.

## Stacks

In computing, we often talk about "software stacks." These stacks are a combination of different software components that you can use to build and host a program. Our software is going to pre-build on this stack and leverage all the components.

Often a software stack holds the following:

- An operating system
- A database
- A web server
- A programming language
- Sometimes a programming framework as well

These stacks are built from a combination of these components.
Two well-known examples in contemporary stacks are: LAMP and MEAN. LAMP is a stack with Linux, Apache, MySQL and PHP. MEAN is a stack with MongoDB, Express, AngularJS and NodeJS. Often stacks are ordered to form a nice English word.
Developers often choose a stack that suits their application well, also a popular stack is often chosen for good documentation, stability and finding knowledge.

For this course, we are looking at PHP as the programming language. PHP is an open source programming language widely used for the web. PHP also has its origins as a language for dynamic websites. We find PHP on most "smaller" websites but also at technology giants such as Facebook[^hack].

![PHP marketshare](./pl-php.png)

### LAMP

LAMP stands for:

- Linux
- Apache
- MySQL/MariaDB
- PHP

![LAMP stack](./lamp.jpg)

LAMP is a textbook example of a stack, and undoubtedly one of the most popular stacks.
Apache here is the web server that processes HTTP requests. MySQL is databases that stores your data and enables SQL queries. After MySQL was acquired by Oracle, the fork of MySQL MariaDB experienced more and more popularity (we'll look at this in the databases section. PHP is our language that will create our dynamic web pages.

### Apache

The Apache HTTP Server is an open-source cross-platform web server also known as "httpd" and simply "Apache.
The Apache Software Foundation is responsible for Apache's designations and services. The software is developed and maintained by the open-source community with numerous developers. Mostly used on the Linux platform, Apache powers nearly 30% of the world's websites[^stats]. In December 2020 it was 36% and in December 2019 it was 41%.

### LEMP

![lemp](./lemp.png)[^lempimagesource].

LEMP is a stack similar to LAMP. However, Apache has been replaced by NGINX (pronounced en-jin-ex).

NGINX is an open source web server started in 2002 by Igor Sysoev, designed to handle 10 000 simultaneous connections in an efficient way. At that time, limited resources and operating systems made it difficult for web servers to handle this problem. However, the design of NGINX today makes it far more perfomant than Apache. Along with built-in features such as [a Reverse Proxy](https://devops.maartje.dev/tools/loadbalancing/), it is also ideal for building out to larger and future-oriented applications.

![nginx marketshare](./nginx-stats.png)[^stats].

As a result, NGINX has had a larger market share than Apache for several years. Companies like Cloudflare that handle huge numbers of web traffic also use a modified version of the NGINX code !

Because of this we are going to use NGINX instead of Apache in this course.

:::warning
In Linux Webservices the Apache 2 server is still used. This chapter on Nginx is only for reference.
:::

## Standalone vs CGI

One small difference to still cite is about the programming language in a stack. There are two types of ways to execute code on a Web server. The first is CGI (Common Gateway Interface) and is a spec that has been established since the early 1990s to allow code to be executed by Web servers. When a user visits a CGI website, the file name is included in the URL as with static websites. The web server recognizes the file, starts a Linux process to execute the code and sends the content to the user. Each request starts a process on the server. No requests also gives no CPU to these code files.

![diagram](./cgi.png)

Many (often modern) applications are slow because the web server has to read, compile and execute the file every time. Or the application works with real-time data (take for example a chat application) and needs to run background processes. These then often work with a "standalone" server. The code itself contains an HTTP server that processes the requests. This process then runs like NGINX and MariaDB on our server as a "service". Often NGINX runs in front of this server for HTTPS handling or to avoid having to give the application root privileges (sometimes also for caching etc.).
Example is the MEAN stack running a web server with the code in it with ExpressJS.

[^stats]: [Figures from w3tech.com](https://w3techs.com/technologies/overview/web_server)
[^webring]: Before search engines were a thing, we had [Webrings](https://en.wikipedia.org/wiki/Webring) that allowed sites to reference each other over a particular underwork
[^hack]: Facebook was built on the LAMP stack but had a [transition to Hack, a language designed by FB to run PHP faster and widely](https://www.cuelogic.com/blog/how-facebook-is-not-using-php-by-still-using-php)
[^lempimagesource]: Image by Parth Shukla, Ahex Technologies
