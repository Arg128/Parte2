FROM debian:stable

RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-perl2 \
    perl \
    libdbi-perl \
    libdbd-mysql-perl \
    libtext-markdown-perl \
    libcgi-pm-perl \
    && rm -rf /var/lib/apt/lists/*

# Habilitar el módulo CGI
RUN a2enmod cgi

# Crear directorio cgi-bin
RUN mkdir /var/www/cgi-bin && chmod -R 755 /var/www/cgi-bin

# Configurar el VirtualHost para CGI
RUN echo "ScriptAlias /cgi-bin/ /var/www/cgi-bin/" > /etc/apache2/conf-available/cgi-bin.conf \
 && echo "<Directory \"/var/www/cgi-bin\">" >> /etc/apache2/conf-available/cgi-bin.conf \
 && echo "    AllowOverride None" >> /etc/apache2/conf-available/cgi-bin.conf \
 && echo "    Options +ExecCGI -MultiViews +FollowSymLinks" >> /etc/apache2/conf-available/cgi-bin.conf \
 && echo "    Require all granted" >> /etc/apache2/conf-available/cgi-bin.conf \
 && echo "    AddHandler cgi-script .pl" >> /etc/apache2/conf-available/cgi-bin.conf \
 && echo "</Directory>" >> /etc/apache2/conf-available/cgi-bin.conf

RUN a2enconf cgi-bin

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]