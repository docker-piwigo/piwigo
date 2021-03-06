FROM php:7.3-apache
# rq: les '&&' => execute 1ere commande et si c'est vrai => exécute la 2eme
# update => pour mettre à jour le cashe (en local) et upgrade => mise à jour des fonctionnalités
RUN apt-get update &&  apt-get upgrade -y
# libpng-dev = intallé car gd en a besoin
# rq: libpng et libpng-dev => différence avec -dev = on a description de ce qu'il y a dedans (indispensable pour c et c++)
RUN apt-get -y install libpng-dev curl unzip
# gd => bibliothèque mais quoi?
# exif => ??
RUN docker-php-ext-install mysqli gd exif
# il y a des soucis quand ont copie directeent le dossier piwigo avec la commande:
# COPY piwigo/ /var/www/html/
# donc à la place, on va directement le télécharger sur le site avec cette commande:
WORKDIR /var/www/


RUN curl -o piwigo.zip http://piwigo.org/download/dlcounter.php?code=latest
# puis dézipper le dossier piwigo
RUN unzip piwigo.zip
RUN rm -rf html
RUN mv piwigo html
# supprimer le fichier zip
RUN rm piwigo.zip



# ici 777 = un peu trop de droits accordés à l'utilisateur étant donné que l'on ne connait pas trop ce qu'il y a dans le code
# attention ici pas une bonne idée d'autoriser partout, plutot aller chercher (en particulier le -R = récursif peut être un pb)
# mieux de mettre 755 pour dossier et fichiers qui sont dedans => 660 ou 440
# mais pour piwigo il faut mettre certains dossiers en 777
RUN chmod 777  -R /var/www/html/
#WORKDIR /var/www/html/
# le containeur écoute sur le port 80
EXPOSE 80
# ici pour se connecter en HTTPS
#EXPOSE 443 