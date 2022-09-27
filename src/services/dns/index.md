# DNS - Domain Name System

![haiku](./haiku.jpg)

> Everything is a freaking DNS problem

This is a common expression from the SysAdmin world, because many problems arise from poor management of DNS. All systems depend on it, so a DNS problem often involves everything.

## DNS

Heyt Domain Name System (DNS) is a the to name devices on a network.
It translates a readable name into an IP address (which no one can remember anyway).
DNS is perhaps the most important part of the Internet!

The hierarchical system that keeps people from having to remember "difficult" websites:
For example, instead of typing in 172.217.20.67, it's better to use google.be.
"google.be" is called a a domain name.

![DNS hyerachie](./dns.png)

### Top-Level Domain (TLD).

The most general part of the domain name, it is the part that is most to the right.
Examples:

- be
- nl
- fr

These TLDs are linked to countries. They are also sometimes called ccTLD - Country Code Top-Level Domain.

You also have generic TLDs, Generic TLDs or gTLD.
Examples:

- com
- org
- net

These are the classic gTLDs. The recent growth of the Internet has also brought with it a demand for a lot of new TLDs like:

- jobs
- biz
- info
- name
- pro
- ninja
- club
- pizza

Or cities with their own TLDs:

- ghent
- brussels
- vegas
- paris

Some call it proliferation but it does give more options, [Wikipedia has a complete list of TLDs](https://en.wikipedia.org/wiki/List_of_Internet_top-level_domains). Each TLD is managed by a particular organization that hosts the authoritative nameservers for it, sponsored by the "registration fee" you pay to buy a domain name

- com
- be
- net
  - Are at the top of the hierarchy
  - Issue other domain names, within their TLD

### Root Domain

`www.google.be` is technically not a full DNS entry! There will be a hidden dot after the TLD, i.e. `www.google.be.`
This dot is called the root domain, these are provided by the root name servers.
There are 13 of them in the world, each one has a letter: A to M.
If these disappear, there will be no more Internet as we know it! Therefore, they are scattered around the world and are all part of other organizations.
1 "server" for a root server is no longer the case today, nor are they in 1 location. They all use [anycast IPs](https://en.wikipedia.org/wiki/Anycast) to load balance requests and get redundancy.

![root servers](./root.png)

Root servers are hardcoded into our DNS setup on our PCs as well as DNS resolver servers.

### Host

A host is an individual computer within a domain. For example, your web server resides on the 'www' host.
Then you get `www.google.be` .
You can have multiple individual hosts, such as:

- db.google.be - for database access
- api.google.be - for the programming API
- ftp.google.be - for FTP access to the domain
  The host name can be anything you want, as long as it is unique to the domain!

### Subdomain

Subdomain is not to be confused with a `host`. DNS is a hierarchy: a TLD has many domains under it so `.be.` has
`thomasmore.be` and `google.be`.

A subdomain refers to any domain that is part of a larger domain.
So for example thomasmore.be and google.be are subdomains of the .be domain.

Any domain can have subdomains for example the school can have a subdomain for the IT team, of which:

- it.thomasmore.be
- login.it.thomasmore.be - specific host under the domain `it.thomasmore.be`.

The difference between a host and a subdomain is that a host designates a single computer or resource, while a subdomain is going to subdivide the domain all over again.

### Nameserver

A nameserver is a server that translates domain names to an IP address.
They do all the heavy lifting in DNS, responding to DNS queries sent from various users. Often sent by other DNS servers as well.

A name server can be "authoritative," they can give "the correct" answer to a query, a DNS server can be authoritative for a particular domain name. So DNS servers that we set up ourselves are going to be authoritative for domain names in our busy.

If they are not authoritative on a particular query, they often redirect to other server, or cache the answer. DNS servers like 1.1.1.1 and 8.8.8.8 are never authoritative mate have a large cache for answer.

### Zone file

Simple text file to configure DNS records.
The zone file contains the translation from domain name to IP address.
These are stored on a name server and define the available resources (authoritive) or point to other NS where this info can be found.

A single line within a zone file is a `record`.
A record can:

- Display the assignment of domain name to IP address
- Point a domain to another domain
- Define name servers
- Define mail servers
- etc.

## Record types

### Start of Authority (SOA)

Start of Authority (SOA) is a required in a zone file.
It stores important information about a domain or zone, such as the administrator's email address, when the domain was last updated, and how long the server should wait between refresh dates.

![soa](./soa.png)

### A and AAAA record

Assignment of a domain to an IP address. A record is for IPv4, a AAAA record is for IPv6 (a v6 is 4x as long as a v4 hence 4xA).

![a](./a.png)

An `@` in DNS means the root of the zone, so for example `@` in the configuration of Thomas More is `thomasmore.be`

### Canonical name (CNAME) record

Reference to another record, so the value is another domain name.

Usually costs an additional request to the DNS server. Often it is more performant to use an extra A (or AAAA) record.
If it is needed anyway, many advanced DNS servers will send a response for the record the CNAME points to from their own cache.

![cname](./cname.png)

CNAME records are only allowed on subdomains of your own domain!

### Mail exchange (MX) record

Indicates which mail server is used for this domain.
An MX record must point to an A or AAAA record.
MX recorfs also have a priority number that indicates preference of handling. A lower number is preferred. You can use this to set up a backup mail server.

![mx](./mx.png)

## Name server (NS).

NS stands for "name server," and the name server record indicates which DNS server is authoritative for that domain.
NS records tell the Internet where to find a domain's IP address.
A domain often has multiple NS records that can specify primary and secondary nameservers for that domain this for redundancy.

Our authotivie server for a TLD is only going to return NS records.

![ns](./ns.png)

### Pointer record (PTR).

Assignment of a domain name to an IP address, it is the inverse of an A (or AAAA) record.
It always ends in '.in-addr.arpa.' for IPv4 or '.ip6.arpa.' for IPv6.
Configuration of these is usually through your Internet service provider.

## DNS vs. DNS

We often talk about setting up the DNS server when we go to set up a network adapter. We should not confuse this DNS server with our authoritative DNS server.

A DNS Resolver is a server erver that makes the whole DNS "search" for us.
Examples are

- Can be self hosted, not super perfomant because little cache. Can be nice with extra features like the [pi-hole](https://pi-hole.net/)
- our ISP (Telenet,Proximus,Belnet,...) - often has a big cache and is "close" to our server
- 1.1.1.1 (Cloudflare) 8.8.8.8 (Google) 9.9.9.9 (IBM), OpenDNS, NextDNS.... - are Anycast and widely used

Authoritive DNS, the DNS server that will host our domain:

- Self hosted (see exercise with Bind9)
- Cloud hosted: DNSimple, Cloudflare, Amazon Route53, Google Cloud DNS,...

:::warning block tip
The website [howdns.works](https://howdns.works/) is a nice but also correct explanation of DNS!
:::

## Dig

dig joke](./dig.png)

Dig is a hugely useful tool for looking up, testing and troubleshooting DNS records!

### Installation

We install dig with APT:

```bash
sudo apt update
sudo apt install dnsutils
```

### Simple query

Simple query for the IP address of ` discord.thomasmore.be``  `+short` provides limited information.

```bash
dig discord.thomasmore.be +short
```

```
$ dig discord.thomasmore.be +short
5.134.6.217
```

`discord.thomasmore.be` only has an A record with then IP.

We now look at the course itself: `linux.marchje.dev`

```bash
dig linux.marchje.dev +short
```

```
$ dig linux.marchje.dev +short
dynaproxy.ari.marchje.dev.
51.15.107.76
```

This domain name has a CNAME to `dynaproxy.ari.marchje.dev.` with the IP `51.15.107.76`.

Without `+short` we get all this information.

```bash
dig linux.marchje.dev
```

```
$ dig linux.marchje.dev +short
; <<>> DiG 9.16.15-Ubuntu <<>> linux.marchje.dev
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 44803
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
;; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;linux.marchje.dev.		IN A

;; ANSWER SECTION:
linux.marchje.dev.	54 IN CNAME dynaproxy.ari.marchje.dev.
dynaproxy.ari.marchje.dev. 54 IN A 51.15.107.76

;; Query time: 3 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Sun Mar 13 13:06:58 CET 2022
;; MSG SIZE rcvd: 90
```

We see several parts here:

![dig layout](./dig-section.png)

In the answer section we also see several parts:

```
;; ANSWER SECTION:
linux.marchje.dev.	54 IN CNAME dynaproxy.ari.marchje.dev.
dynaproxy.ari.marchje.dev. 54 IN A 51.15.107.76
```

- `linux.marchje.dev.` is the record name
- `54` is the number of seconds we are allowed to cache this = Time To Live (TTL)
- `IN` is an internet record
- `CNAME` is the record type
- `dynaproxy.ari.marchje.dev.` is the record value

We can also request and particular record type, such as MX

```bash
dig thomasmore.be MX
```

```
$ dig thomasmore.be MX
; <<>> DiG 9.16.15-Ubuntu <<>> thomasmore.be MX
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 45049
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 3, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
;; EDNS: version: 0, flags:; udp: 65494
;;; QUESTION SECTION:
;thomasmore.be.			IN MX

;; ANSWER SECTION:
thomasmore.be.		3589 IN MX 0 thomasmore-be.mail.protection.outlook.com.
```

### @ resolver

We can also use dig to go ask each DNS resolver a query, we do this with `@``.

For example we are going to ask 8.8.8.8 for an IP

```bash
dig thomasmore.be @8.8.8.8
```

```
$ dig thomasmore.be @8.8.8.8
; <<>> DiG 9.16.15-Ubuntu <<>> thomasmore.be @8.8.8.8
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 14798
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
;; EDNS: version: 0, flags:; udp: 512
;;; QUESTION SECTION:
;thomasmore.be.			IN A

;; ANSWER SECTION:
thomasmore.be.		3600 IN A 62.213.218.216

;; Query time: 43 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Sun Mar 13 15:13:56 CET 2022
;; MSG SIZE rcvd: 58
```

We briefly compare the answers from different DNS resolvers

```bash
dig +short www.rt.com @193.190.198.2 #Belnet, only works at school
dig +short www.rt.com @1.1.1.1 #Cloudflare
```

```
$ dig +short www.rt.com @193.190.198.2
193.191.245.56
$ dig +short www.rt.com @1.1.1.1
en.wpc.rt.com.
185.178.208.121
```

:::warning note
At the time of writing, the Belgian government is blocking Russian media at the DNS level. As you can see, circumvention is tremendously easy.
:::

### +trace

With the `+trace` option you can watch a DNS resolution all the way through, dig is going to start at the root servers and perform all the steps. This way you can find out what goes wrong when setting up your DNS.

```bash
dig thomasmore.be +trace
```

```
$ dig thomasmore.be +trace

; <<>> DiG 9.16.15-Ubuntu <<>> thomasmore.be +trace
;; global options: +cmd
.			208576 IN NS a.root-servers.net.
.			208576 IN NS b.root-servers.net.
.			208576 IN NS c.root-servers.net.
.			208576 IN NS d.root-servers.net.
.			208576 IN NS e.root-servers.net.
.			208576 IN NS f.root-servers.net.
.			208576 IN NS g.root-servers.net.
.			208576 IN NS h.root-servers.net.
.			208576 IN NS i.root-servers.net.
.			208576 IN NS j.root-servers.net.
.			208576 IN NS k.root-servers.net.
.			208576 IN NS l.root-servers.net.
.			208576 IN NS m.root-servers.net.
;; Received 503 bytes from 127.0.0.53#53(127.0.0.53) in 39 ms

be.			172800 IN NS d.nsset.be.
be.			172800 IN NS c.nsset.be.
be.			172800 IN NS y.nsset.be.
be.			172800 IN NS b.nsset.be.
be.			172800 IN NS z.nsset.be.
be.			172800 IN NS a.nsset.be.
be.			86400 IN DS 12664 8 2 75141E9B1188A95A7A855BF47E278A742A5E3F2DDEED8E995D749D48 F2F0E72D
be.			86400 IN DS 52756 8 2 5485AC33DD7C7ED237EA2A4BD269731C816960FE181042024484B5CE CA6ECC9F
be.			86400 IN RRSIG DS 8 1 86400 20220326050000 20220313040000 9799 . MyvomweWG6YNFHwZKZkuzLJ6XUHohEDnW1/ouxeNCagP8oWXXuPgfEO5 ps7VZZAg6TZbQyKaPeWrh2Dd9jdui2i3yESeTYl8y1OdHzZTHTROdba2 c32zrUh+mfD107naBvMusUcMDy1BRxSc/xNQO+9v9deUtoGwnitjuW3O qPbFc7FYNzcwxCFXMtR2sSy8o3nChoX4ShQRg/H8JyzFeJ6MMH3rjZpy 24+aXVJ8islEs3T4LwcqF6KwiFeMtcYkaF89ENMEiRqY2jkN4VH7woTe CaoUtpdjGxmV6TzCUp4capXh55hWD7Xo3XJyPSE+6elx51r/O1Wx+3th W9KtBw==
;; Received 791 bytes from 192.58.128.30#53(j.root-servers.net) in 31 ms

thomasmore.be.		86400 IN NS ns2.belnet.be.
thomasmore.be.		86400 IN NS ns3.belnet.be.
thomasmore.be.		86400 IN NS ns1.belnet.be.
ba141snrnoe1rc9mddgrest23g657rir.be. 600 IN NSEC3 1 1 5 1A4E9B6C BA175A6M75ITNTD2DO5RIQLCVM45GSMR NS SOA RRSIG DNSKEY NSEC3PARAM
ba141snrnoe1rc9mddgrest23g657rir.be. 600 IN RRSIG NSEC3 8 2 600 20220331223823 20220309100036 7359 be. j9Yyyu7tUHu+BwRrnqdM0/kyQxs75g+mZHRfQsMaIqMLVUmn+EJbSjO2f BupTuWH9Pm0900c5d5ynXroEjSkWJocKkPKuHyM2xUajCAcUpgf9eGkz 0s6ioryjMuWZVVLS4FT2XIDmK0JhY2Y/9teO6i6yn14dyYNZI9yNquLD 2ek=
nn9pn59ki9m1be2ssp48ld67g7ceec0c.be. 600 IN NSEC3 1 1 5 1A4E9B6C NN9TH6B4VGI5NDLQLA5RSKMT58B7AQD2 NS DS RRSIG
nn9pn59ki9m1be2ssp48ld67g7ceec0c.be. 600 IN RRSIG NSEC3 8 2 600 20220330001255 20220307223002 7359 be. cMu3SJOcNd+ncc7VkGTKHqusdoRsiQwmYdgHxyiSE65djVdvUFUGhu59 00XGoW7VRPZWXvawP6oTAcwmNCyXENzUxC0qpz4Jc+m+cwxlop2fKBeC wTo038m7RgjVHxgOB06+uElt0NV93z6n/X9D0fb2fKDdXuwfdI2oN6ys VZk=
;; Received 726 bytes from 194.0.6.1#53(a.nsset.be) in 23 ms

thomasmore.be.		3600 IN A 62.213.218.216
thomasmore.be.		3600 IN NS ns.thomasmore.be.
thomasmore.be.		3600 IN NS ns1.belnet.be.
thomasmore.be.		3600 IN NS ns2.belnet.be.
;; Received 134 bytes from 193.190.182.40#53(ns2.belnet.be) in 31 ms

```
