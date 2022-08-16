# WordPress

![logo](./logo.png)

WordPress is een enorm populaire PHP applicatie. Gestart in 2003 als open source blogging systeem draait WordPress nu op 42.8% van de top 10 miljoen websites[^wpstats] of 65% van de websites die een CMS systeem gebruiken.

WordPress word voor meer dan blogs gebruikt door flexibel uitbreidbaar te zijn met een groot plugin ecosystem. Van een simpele site tot een heel ecommerce platform WordPress kan het wel draaien. De kans dat je in het werkveld WordPress dus ergens tegenkomt is vrij groot.

Alle plugins, themas en documentatie is de vinden op [WordPress.org](https://wordpress.org/).

De installatie van WordPress is vrij eenvoudig en snel!

## Oefening: Installatie

We hebben in de vorige hoofdstukken alle componenten besproken die je nodig gaat hebben voor WordPress te installeren!
Hieronder vind je een checklist wat je moet doen. Als ook enkele (niet alle) nuttige commando's die je kan gaan gebruiken!

Database:

- Maak een MySQL database aan met de naam `wordpress`
- Maak een MySQL gebruiker aan met de naam `wordpress` en een willekeurig wachtwoord.
- Voeg de MySQL gebruiker toe aan de database met de naam `wordpress`.

NGINX:

- Maak NGINX Virtual Host aan met de domeinnaam `wordpress.r<nummer>.stuvm.be`
- Voorzie de map `/var/www/wordpress` (TIP: Permissions!)
- Zet alle nodige WordPress bestanden in deze map.

PHP:

- Voorzie een upload limiet van 1GB

WordPress:

- Installeer WordPress
- Log in op `http://wordpress.r<nummer>.stuvm.be/wp-admin`
- Voorzie inhoud, thema (geen standaard!) en naam naar eigen smaak
- Installeer `Wordfence Security`

### Tips

We hebben nog geen FTP om bestanden vanop onze PC te uploaden (kan wel via SSH, maar laten we dat feit even negeren).
Zo kan je WordPress rechtstreeks downloaden (ook sneller) vanaf de website van WordPress.org:

```bash
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
rm latest.tar.gz
ls wordpress
```

WordPress laat "pretty URLs" toe. Dit is een manier de lelijke `.php` uit je URL te halen.
Je kan dit doen door de `try_files` directive in de `location` van de Virtual Host aan te passen.

```
location / {
    try_files $uri $uri/ /index.php?$args;
}
```

[^wpstats]: https://w3techs.com/technologies/overview/content_management

PHP heeft 2 limieten voor het uploaden van bestanden: `upload_max_filesize` en `post_max_size`. Technisch gezien is de laatste voor heel het "formulier", deze moet groter of gelijk zijn aan de eerste.
NGINX heeft ook een upload limiet, `client_max_body_size 100m;`. Deze kan staan in het `http`, `server` of `location` blok.
