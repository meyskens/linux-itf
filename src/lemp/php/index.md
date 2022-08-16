# PHP

![PHP logo](./php.png)

PHP is een programeertaal specifiek ontworpen voor webontwikkeling.PHP is ontworpen door de Rasmus Lerdorf in 1994.
PHP staat eigenlijk voor voor "Personal Home Page. Nu is dat voor een groeiende taal geen goede reclame, daardoor is het later aangepast naar "PHP: Hypertext Preprocessor".

PHP-code wordt meestal op een server gebruikt in CGI mode. Hierbij wordt bij elke request naar de server PHP code gecompiled en uitgevoerd, de output van dit script wordt dan naar de webbrowser gestuurd. Meestal is dit dan in de vorm van een webpage.

Volgens W3Techs werd in januari 2022 PHP wordt gebruikt door 78,1% van alle websites waarvan we de server-side programmeertaal kennen.
PHP versie 7.4 is de meest gebruikte versie. Ondersteuning voor versie 7.3 werd op 6 december 2021 beëindigd. Momenteel is versie 8.1 de meest recente, versie 8.0 kent een aantal grote wijzigingen gefocussed op performance zoals het toevoegen van een JIT (Just in Time) compiler.

## PHP-FPM

We werken in NGINX setups meestal met de PHP FastCGI Process Manager. FastCGI is een kleine verbetering op het klassieke CGI dat overhead weghaalt en meerdere processen toelaat. PHP-FPM neemt onze FastCGI een stapje verder en gaat processen managen, het gaat al een aantal processen met de PHP taal draaien die verschillende requests gaan afhandelen van NGINX.
Door deze manier van werken kunnen we ook makkelijk verschillende PHP versies op een server gaan draaien.

Dit systeem gaat het mogelijk maken om te beheren hoeveel PHP processen we gaan draaien en maakt het mogelijk requests snel af te handelen. Voor elke PHP site die toch wel wat verkeer over zich heen krijgt is PHP-FPM een niet te missen component!

## Installatie

We installeren PHP-FPM via `apt`:

```bash
sudo apt update
sudo apt install php7.4-fpm php7.4-mysql
```

We installeren PHP versie 7.4, de hoogste versie in Ubuntu 20.04. We kunnen zo ook andere versies installeren.

We bekijken nu de status van de PHP-FPM server:

```bash
sudo systemctl status php7.4-fpm
```

## Configuratie

Configuratie voor PHP-FPM kunnen we vinden in `/etc/php/7.4/fpm/`.
We hebben hier een aantal bestanden die we kunnen bekijken:

- `php.ini`: dit is het PHP configuratiebestand. Hier staat alles in over the PHP taal, af en toe moeten we hier iets aanpassen voor specifieke applicaties. We hebben hier een paar interessante instellingen:
  - `memory_limit`: hier staat de maximale geheugenlimiet voor PHP.
  - `post_max_size`: hier staat de maximale grootte van een POST request.
  - `upload_max_filesize`: hier staat de maximale grootte van een upload.
  - `extension=`: laat je PHP extenties inladen
- `php-fpm.conf`: dit is het algemane configuratiebestand voor de PHP-FPM server.
- `/pool.d/www.conf` bevat informatie over de "worker pool".

  - `user` en `group` bepaald onder welke gebruiker PHP draait.
  - `pm` bepaald wat de manier is om PHP processen te managen. Hier kunnen we ook een aantal opties kiezen zoals:

    - `static` start een vast aantal (`pm.max_children`) workers op, schaalt niet mee met verkeer
    - `ondemand` geen processen worden standaard gestart, maar worden gestart als er een request binnenkomt.
    - `dynamic` is een combinatie van `ondemand` en `static`. Het start een aantal processen op en schaalt mee op bij groter verkeer.

  - `pm.max_children`: hier staat het aantal processen dat de PHP-FPM server mag draaien.
  - `pm.start_servers`: hier staat het aantal processen dat de PHP-FPM server zal starten (enkel bij `dynamic`).
  - `pm.min_spare_servers`: het minimaal aantal processen dat "idle" moet staan om pieken op te vangen (enkel bij `dynamic`).
  - `pm.max_spare_servers`: het maximaal aantal processen dat "idle" moet staan om pieken op te vangen (enkel bij `dynamic`).

Voor ons zijn de standaard waarden meer dan voldoende. We kunnen dit gaan bijstellen bij meer verkeer naar onze webserver.

### Virtualhost met PHP

In het hoofdstuk van [NGINX](../nginx/) hebben we een eigen website opgezet met een virtualhost. We gaan een virtualhost bijmaken die PHP gaat ondersteunen. We gaan de virtualhost `/etc/nginx/sites-available/php-site` aanmaken.

```
server {
	listen 80; # server op poort 80
	listen [::]:80; # server op IPv6-poort 80

	root /var/www/php-site; # map van de website

	index index.php index.html; # welke files je index zijn

	server_name php.rnummer.stuvm.be; # hostname van de site, PAS DEZE AAN

	location / {
		try_files $uri $uri/ =404; # geef een 404 error als de pagina niet bestaat
	}

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.4-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

Wat is hier anders dan onze vorige configuratie?

- `index` staat nu `index.php` vooraan.
- `location ~ \.php$ ` is een regex die alleen de pagina's die een `.php` extensie hebben worden doorgegeven aan de PHP-FPM server.
  - `include snippets/fastcgi-php.conf` gaat standaard FastCGI parameters instellen
  - `fastcgi_pass unix:/run/php/php7.4-fpm.sock` geeft aan waar onze PHP-FPM server staat die PHP voor ons gaat afhandelen.
- `location ~ /\.ht` met de `deny all` regel geeft aan dat bestanden met .ht niet geopend mogen worden
  - Vele PHP applicaties gebruiken `.htaccess` en `.htpasswd` bestanden voor Apache in te stellen. Nginx kent deze bestanden niet en wil deze bestanden gewoon doorsturen naar de browser, dit kan wel eens gevoelige data lekken.

:::warning note
Wat is nu die `unix:/run/php/php7.4-fpm.sock`? Dit is een Unix socket. Een Unix socket is een equivalent van een TCP poort, het verschil is dat we geen IP en poort hebben maar een pad op ons bestandsysteem.
:::

We maken nu een map aan waar we onze PHP applicaties kunnen opslaan:

```bash
sudo mkdir /var/www/php-site
```

We zetten onze virtualhost op actief:

```bash
sudo ln -s /etc/nginx/sites-available/php-site /etc/nginx/sites-enabled/
```

Testen ook wwwr eerst de configuratie:

```bash
sudo nginx -t
```

En ten slotte reloaden we onze NGINX server:

```bash
sudo systemctl reload nginx
```

Als we nu onze PHP site openen op onze ingestelde hostname zien we een 404 error.
We moeten nog een index pagina maken:

```bash
sudo nano /var/www/php-site/index.php
```

Hier is een klein stukje PHP code dat we gaan gebruiken:

```php
<?php

echo "hello and welcome to the world of PHP";
```

Als we nu onze website opnieuw openen zien we ons nieuw bericht.

We gaan nog een extra pagina maken met PHP:

```bash
sudo nano /var/www/php-site/info.php
```

```php
<?php
phpinfo();
```

Dit geeft ons alle info van onze PHP installatie!

Volgend hoofdstuk gaan we Wordpress gebruiken als onze PHP applicatie.
