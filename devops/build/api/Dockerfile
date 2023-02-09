FROM gitlab-service.manageteam.ec2-internal:8443/devops/docker-base-images/php-web:7.2

##### init bash
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]metrix:\[\033[33;1m\]\w\[\033[m\]\$ "' >> ~/.bashrc


##### configure NGINX
ADD ./devops/build/api/config/nginx/api.conf   /etc/nginx/sites-available/api.conf
RUN ln -sf /etc/nginx/sites-available/api.conf   /etc/nginx/sites-enabled/api.conf

###### add startup scripts
RUN mkdir -p /etc/my_init.d
ADD ./devops/build/api/scripts /etc/my_init.d
RUN chmod +x -R /etc/my_init.d

##### add code to the container
ADD ./project /var/www/project

##### create volume and expose ports
VOLUME  /var/www/project
WORKDIR /var/www/project