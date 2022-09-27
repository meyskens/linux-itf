# WordPress

![logo](./logo.png)

WordPress is a hugely popular PHP application. Started in 2003 as an open source blogging system, WordPress now runs on 42.8% of the top 10 million websites[^wpstats] or 65% of websites using a CMS system.

WordPress is used for more than blogs by being flexibly extensible with a large plugin ecosystem. From a simple site to an entire ecommerce platform WordPress can run it. So the chances of you encountering WordPress somewhere in the work field are quite high.

All the plugins, themes and documentation can be found at [WordPress.org](https://wordpress.org/).

Installing WordPress is pretty easy and quick!

## Exercise: Installation

We've covered in the previous sections all the components you're going to need to install WordPress!
Below is a checklist of what you need to do. As well as some (not all) useful commands you can start using!

Database:

- Create a MySQL database with the name `wordpress`.
- Create a MySQL user with the name `wordpress` and any password.
- Add the MySQL user to the database with the name `wordpress`.

NGINX/Apache:

- Create Virtual Host with the domain name `wordpress.r<number>.stuvm.be`
- Provide the folder `/var/www/wordpress` (TIP: Permissions!).
- Put all necessary WordPress files in this folder.

PHP:

- Provide an upload limit of 1GB

WordPress:

- Install WordPress
- Log in to `http://wordpress.r<number>.stuvm.be/wp-admin`
- Provide content, theme (not default!) and name to your liking
- Install `Wordfence Security`

### Tips

We do not yet have FTP to upload files from our PC (can be done via SSH, but let's ignore that fact for now).
So you can download WordPress directly (also faster) from the WordPress.org website:

```bash
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
rm latest.tar.gz
ls wordpress
```

WordPress allows "pretty URLs." This is a way to remove the ugly `.php` from your URL.
You can do this by adjusting the `try_files` directive in the `location` of the Virtual Host.

Nginx:

```
location / {
    try_files $uri $uri/ /index.php?$args;
}
```

Apache can make use of the `.htaccess` file to do the same thing.

[^wpstats]: https://w3techs.com/technologies/overview/content_management

PHP has 2 limits for uploading files: `upload_max_filesize` and `post_max_size`. Technically, the latter is for the entire "form", it must be greater than or equal to the former.
NGINX also has an upload limit, `client_max_body_size 100m;`. This can be in the `http`, `server` or `location` block.
