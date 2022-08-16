# Docker Compose

Docker Compose is een heel geliedfe tool bij developers, vele projecten en intrne code komen namelijk met een `docker-compose.yml` file al in de root van een code repository. Deze file bevat alle informatie die nodig is om een project te starten. Zo kan een developer snel aan de slag zonder urenlang services als databases te moeten installeren.

Voor ons gaat Docker Compose ons helpen om het opzetten van verschillende Docker containers te automatiseren als ook te kunnen beheren en documenteren als code.

![Docker Compose logo](./logo.png)

Docker Compose is een tool van Docker die de [compose specificatie](https://compose-spec.io/) ondersteunt. Deze specificatie is een open standaard geworden gebaseerd op [Docker Compose](https://docs.docker.com/compose/).

Deze cursus maakt gebruik van Docker Compse v2.
Versie 2 is een verbeterde versie van V1, maar heeft vele verschillen.
Versie 1 is geschreven in Python en had het apparte commando `docker-compose`. Versie 2 is nu geschreven in Go (net als Docker) en is een plugin voor Docker zelf met het commando `docker compose`. Let hierbij goed op wanneer je informatie gaat opzoeken!

## Installatie

Docker compose installeren den we door de binary te downloaden en de installeren onder de plugins map van Docker:
(Windows en Mac versies zijn normaal al gebundeld met compose)

```bash
wget https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-linux-x86_64
chmod +x docker-compose-linux-x86_64
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo mv docker-compose-linux-x86_64 /usr/local/lib/docker/cli-plugins/docker-compose
```

Doe nu `docker compose` en je zou uitleg moeten krijgen.

## docker-compose.yml

Voor Docker Compse gaan we altijd 1 file tegenkomen: `docker-compose.yml`. Dit is een [YAML](../yaml) file die alle informatie vooe Docker Compose gaat bevatten met onder andere: volumes, services en networks.

### Versies

docker-compose.yml kent verschillende versies, deze specifieren we altijd een het begin van de file. Dit is een praktijk die we ook bij vele andere tools zoals Kubernetes zien terugkoment zodat alle tooling meerdere versies kan ondersteunen.
Echter bij compose is dit de versie van de compose secificatie en niet die can de tool.
Terwijn we net v2.0.1 van Docker Compose hebben zi onze `docker-compose.yml` file aan aan v3.9. Let hierbij goed op!

Wij schrijven al onze files in versie 3.x, versie 2.0 zien we nog vaak terugkomen em werkt meestal nog maar is wel verouderd.

### File

De `docker-compose.yml` file heeft 3 hoofdonderdelen:

- `version`: Versie van de compose file
- `services`: De containers die moeten draaien
- `networks`: De networks die aangemaakt moeten worden
- `volumes`: De volumes die gebruikt moeten worden

Dit is een voorbeeld van een Docker Compose file van de Wordpress setup van vorige week.

```yaml
version: "3.9"
networks:
  wordpress: {}

volumes:
  db-data: {}

services:
  wordpress:
    image: wordpress:latest
    restart: always
    ports:
      - "8091:80"
    depends_on:
      - db
    networks:
      - wordpress

  db:
    image: mariadb:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: test
      MYSQL_DATABASE: wordpress
    volumes:
      - db-data:/var/lib/mysql
    networks:
      - wordpress
```

We bekijken even elk onderdeel:

```yaml
version: "3.9"
```

We gebruiken versie 3.9 van de Compose specificatie. Wat hier inzit kan je allemaal bekijken op de [Compose file reference](https://docs.docker.com/compose/compose-file/compose-file-v3/). Dit is een heel handige referentie wanneer je compose files gaat maken.

```yaml
networks:
  wordpress: {}
```

Dit is een lijst van netwerken die we nodig hebben binnen Docker, die deden we manueel met `docker network create`. We hebben verder geen configuratie nodig dus geven we een leeg object mee namelijk `{}`. Dit kan ook weggelaten worden maar dat is minder duidelijk.

```yaml
volumes:
  db-data: {}
```

Dit lijkt heel erg op wat we met networks deden, dit doet bijna hetzelfde voor volumes.
Waar we vorige les vooral onze bestanden in een eigen map gaan plaatsen zeggen we hier dat Docker zelf een leeg volume moet aanmaken voor onze data. Dit volume wordt ook bijgehouden alleen kiest Docker hier zelf een interne locateie voor zodat het niet afhankelijk is van de bestandstructuur van een server of laptop.

```yaml
services:
  wordpress:
    image: wordpress:latest
    restart: always
    ports:
      - "80:80"
    depends_on:
      - db
    networks:
      - wordpress
```

Al onze containers zijn Services. In Docker Compose spreken we meestal over meerdere containers. Deze hebben allemaal een naam en eigenschappen. Hier defineren we de containers dat onze container image `wordpress` nodig heeft, poort 80 moet exposen en netwerk `wordpress` gebruikt. `depends_on is nieuw, dit laat Docker Compose bepalen welke containers eerst moeten starten. Zo gaat de database eerst gemaakt worden omdat WordPress daarmee gaat verbinden. Met `restart: always` stellen we in dat deze container ook moet starten na een reboot.

```yaml
services:
  db:
    image: mariadb:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: test
      MYSQL_DATABASE: wordpress
    volumes:
      - db-data:/var/lib/mysql
    networks:
      - wordpress
```

Voor onze database zien we hetzelfde verhaal. Hier is enkel wel `environment` aan toegevoegd waarmee we onze environment variablen kunnen instellen, ook linken we `volumes` aan de map waar onze database staat.

### Eigen images

Docker Compose kan ook werken met eigen images, die bij het starten gebouw worden.

Dit doen we door `build` te defenieren:

```yaml
services:
  my-container:
    build: .
```

Moet je meerdere container images builden? Dat gaan ook, alleen moet je meer specifieren waar Docker de Dockerfile en bestanden kan vinden.

```yaml
services:
  my-container:
    build:
      context: ./dir
      dockerfile: Dockerfile
```

## docker compose commando

Nu we weten hoe we onze configuratie scrhijven kunnen we aan de slag!

We plaatsen onze `docker-compose.yml` file in een nieuwe map.

```bash
mkdir wordpress
cd wordpress
# Plaats de docker compose file hier
```

De naam van de map gaat Docker Compose ook gebruiken als naam van de setup.

### `docker compose up`

Nu we onze file hebben klaarstaan kunnen we alles starten met `docker compose up`.
Dit gaat al onze resources aanmaken en starten.

```bash
docker compose up
```

Dit start onze Wordpress omgeving op en we kunnen deze gaan bekijken met de browser.

Net als Docker zelf kunnen we ook `docker compose up -d` gebruiken voor het opstarten in de achtergrond. Docker start deze containers ook terug als de server reboot als `restart: always` in de file staat!

```bash
$ docker ps
CONTAINER ID   IMAGE              COMMAND                  CREATED       STATUS         PORTS                                 NAMES
ed81d91b7005   wordpress:latest   "docker-entrypoint.s…"   2 hours ago   Up 3 seconds   0.0.0.0:8091->80/tcp, :::80->80/tcp   wordpress-wordpress-1
3b3451265a84   mariadb:latest     "docker-entrypoint.s…"   2 hours ago   Up 4 seconds   3306/tcp                              wordpress-db-1
```

In `docker ps` zien we nu dat de containers draaien. Ze hebben ook allemaal een naam gekregen met de mapnaam, naam van de container en het cijfer 1. We kunnen met Docker compose ook meerdere replicas van 1 container draaien als we dat willen.

> **Opmerking:** de naam die je gebruikt om containers met elkaar te verbinden is gewoon de korte naam die je in de `docker-compose.yml` file hebt gespecificeerd.

### `docker compose stop`

Draait een Docker compose setup in de achtergrond dak kan je deze stoppen met `docker compose stop`.

### `docker compose restart`

Draait een service en wil je nieuwe configuratie laden? Dan kan je `docker compose restart` gebruiken om alle containers te herstarten en wijzigingen in te laden.

```bash
$ docker compose restart
[+] Running 2/2
 ⠿ Container wp-db-1         Started                                                                                           0.7s
 ⠿ Container wp-wordpress-1  Started                                                                                           1.5s
```

### `docker compose down`

Het down commando is een gevaarlijke, `down` stopt alle containers en **verdijdert** alle data.
Gebruik dit enkel lokaal of als je alles wilt resetten.

### `docker compose build`

Als je eigen images gebruikt en je deze wil updaten moet je `docker compose build` gebruiken.

## Compose files

Vele projecten komen al met een basis compose file aanwezig. We gaan voor het project ook nog eigen compose files schrijven. Heb je echter inspiratie maken? Dan is [Awewome Compose](https://github.com/docker/awesome-compose) een goede referentie, hier zijn verschillende kant en klare stacks te vinden die je kan aanpassen!

## References

- Docker Compose file v3 https://docs.docker.com/compose/compose-file/compose-file-v3/#environment
- Get started with Docker Compose https://docs.docker.com/compose/gettingstarted/
