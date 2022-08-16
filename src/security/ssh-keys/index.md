# SSH Keys

SSH Keys zijn een vervanging voor wachtwoorden in SSH. SSH zijn gebaseerd op RSA cryptografie. Hierbij krijg je 2 keys, een public en een private key. Een public key mag je delen met heel de wereld. Een private key blijft geheim.

Je kan het vergelijken met een doorsje met slot en de sleutel van dat slot. Het doosje kan je aan iedereen geven waarmee je wil comminuceren. Deze persoon stopt dan een bericht in het doosje en sluit het slot. Hierna kan de verzender en iedereen zonder de sleutel het bericht niet meer lezen.
Enkel jij met de sleutel kan het wel lezen. Dat is een simpele uitleg voor public-private of asymetrische cryptografie.

:::warning leestip
HTTPS gebruikt ook RSA keys in meeste gevalen! De website [how https works](https://howhttps.works/) geeft dit mechanisme weer in een leuk stripverhaal.
:::

Deze keys zijn minimaal 2048 bits lang, en duurt miljoenen jaren on te brute forcen. Zelfs in het slechtste geval dat iemand een goede quantum computer kan bouwen duurt het nog 24 uur (waarschijnlijk...).

## SSH Key auth instellen

We gaan nu een SSH key genereren en deze als vertrouwde key gebruiken op onze server.

### Keys bekijken

Als eerste stap gaan we kijken of we al een SSH key hebben. Op onze **client** bekijken we of we een SSH key hebben

```bash
ls ~/.ssh/
```

Hier staan al onze SSH keys, deze starten meestal met de prefix `id_`.

### Key aanmaken

We gaan hier een key aanmaken, dit doen we met `ssh-keygen`. We gaan ook met `-b` de keygroote aanpassen van de defaukt 2048 naar 4096 bits om zo net iets veiliger te zijn. Met `-C` geven we een eigen stukje commentaar mee om de key te herkennen, met onze email bijvoorbeeld.

```bash
ssh-keygen -t rsa -b 4096 -C your_email@domain.com
```

We volgen de instructies, alle vragen kunnen we leeg laten.

```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/maartje/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/maartje/.ssh/id_rsa
Your public key has been saved in /home/maartje/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:hTRTicdLJzAUOczBxNKA9Zqx8u4HDMttCSOqeFnJw5I your_email@domain.com
The key's randomart image is:
+---[RSA 4096]----+
|     ooX@O..     |
|    . .oX=* .    |
|      ..o+.+     |
|  . +  = ..      |
| . *.O+.S        |
|. E Oo*          |
|o  + o..         |
|o o  .  .        |
| .   .o.         |
+----[SHA256]-----+
```

De output geeft ons nu het pad van onze public en private key. We krijgen ook een fingerprint van de key en deze fingerprint ook weergegeven in "art" formaat. Zo kan je visueel keys gaan vergelijken.

:::warning note
We vullen in dit voorbeeld geen passphrase in, een passphrase gaat je SSH key ook nog een wachtwoord geven. Dit wachtwoord gaat dan nodig zijn on je private key te kunnen gebruiken. Meeste security protocollen gaan ook vragen dit in te stellen voor het geval dat iemand je laptop kan stelen of bestanden exfiltreren. In deze cursus slaan we dit over voor gebruiksgemak.
:::

Doen we nogmaals een `ls` gaan we nu de keys zien!

```bash
ls ~/.ssh/
```

output:

```
id_rsa id_rsa.pub
```

We bekijken nu de id_rsa.pub met notepad, je krijgt een tekst startende met `ssh-rsa`. We kopieren deze tekst want we gaan ze nog nodig hebben in een moment!

### Keys op server instellen

We SSH-en nu naar onze server en gaan de keys instellen op onze user.

```bash
ssh ubuntu@[ip]
```

We maken nu de `.ssh` map aan en openen de file `authorized_keys` in deze map.

```bash
mkdir ~/.ssh
nano ~/.ssh/authorized_keys
```

Plak hier je public key. Deze file kan verschillende SSH-keys bevatten, 1 per lijn. Al deze hebben dan toegang tot je user op de server.

Sla het bestand op en sluit het.
We passen nu de permissies nog correct aan voor extra beveiliging.

```bash
chmod 700 ~/.ssh
chmod 644 ~/.ssh/authorized_keys
```

### Keys testen

Om de keys te kunnen testen verlaten we eerste de SSH sessie.

```bash
exit
```

En we SSH-en opnieuw.

```bash
ssh ubuntu@[ip]
```

Als je nu geen password prompt krijgt is alles gelukt!

## Passwords uitschakelen

:::warning note
Doe deze stappen enkel als je weet dat je SSH-keys werken, sluit jezelf niet buiten!
:::

We hebben al gezien dat passwords niet zo veilig zijn dus we zetten ze beter ook altijd uit!

We doen dit in de `/etc/ssh/sshd_config` file.

```bash
sudo nano /etc/ssh/sshd_config
```

:::warning note
Verwar deze file niet met `/etc/ssh/ssh_config`! Dit is 1 letter verschil, de `sshd` is voor onze server, de `ssh` is voor de client.
:::

We willen nu de `PasswordAuthentication` optie uit zetten. Nu we toch bezig zijn zetten we meteen ook de login met de user `root` uit.

Zoek en vervang de volgende lijnen, vind je ze niet voeg ze dan onderaan toe:

```
PasswordAuthentication no
PermitRootLogin no
```

Sla de file op en sluit het.

Nu herstarten we de SSH server om de nieuwe configuratie te laden:

```bash
sudo systemctl restart sshd
```

### Testen

We kunnen dit snel ook testen of het veilig is ingesteld door de SSH-en van de server naar de server zelf. De server kent namelijk je private key niet dus zou niet op zichzeld kunnen inloggen.

```bash
ssh ubuntu@localhost
```
