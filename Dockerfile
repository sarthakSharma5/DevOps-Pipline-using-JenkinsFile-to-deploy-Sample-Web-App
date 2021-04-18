FROM centos
RUN yum install sudo httpd -y
COPY *.html /var/www/html/
CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
EXPOSE 80
