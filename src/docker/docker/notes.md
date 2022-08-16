Allereerst de basic commands met een random Ubuntu bv.:
https://medium.com/@tomw1808/docker-run-tutorial-for-absolute-beginners-run-a-single-docker-container-explained-step-by-step-16ff5c523b5a

Voor apper's begin ik meestal vanuit een fustratie. Veel databases installeren die uw PC stilaan overnemen, zoals SQL Server (lol Microsoft). Wat als... we gewoon eens containers gebruikten daarvoor?

Simpel beginnen met MongoDB:
https://www.thepolyglotdeveloper.com/2019/01/getting-started-mongodb-docker-container-deployment/

Tegelijk heb ik een Java app die daarmee connect om te laten zien dat het werkt met die ports. Tegelijk zien we de attach detach.

Daarna, MySQL met een env var bv:
docker run --name some-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=abc123 -d mysql

Dan de klepper, SQL Server:
https://markheath.net/post/sql-docker-localdb

Hier zien we al volumes en grappige env vars (EULA lol Microsoft). En heb ik die C# app die er spullen naar wegschrijft.

Als laatste voor de liefhebbers die niet graag lange oneliners schrijft: Compose https://towardsdatascience.com/how-to-run-mysql-using-docker-ed4cebcd90e4
[4:35 PM]
Ok dat is de werking... maar wat met er zelf maken?
Ook daar simpel beginnen. Python of Java. Geen PHP met al die toestanden.. gewoon iets waar je de app moet ingooien en dat het werkt. (Spring Boot .jar hebben een internal server)

https://docker-curriculum.com/#dockerfile voor Python, zie je de beste basic keywords.
https://spring.io/guides/topicals/spring-boot-docker/ voor Spring Boot zie je deze ook, en kan je iets zeggen over base images zoals Alpine en waarom nu net Alpine hier.

Oh en over waarom Docker interessant is voor de CEO, gebruik ik de animaties op deze site: https://learnk8s.io/blog/what-is-kubernetes

Voor het tweede jaar, die nog steeds VBox gebruiken, ga ik dit proberen:
https://training.play-with-docker.com/ en specifiek : https://training.play-with-docker.com/beginner-linux/
