# Use the official Ubuntu image as the base image
FROM ubuntu:focal

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND noninteractive

# Update the package list and install necessary packages
RUN apt-get update && \
    apt-get install -y \
        nginx \
        php7.4 \
        php7.4-fpm \
        php7.4-cli \
        php7.4-mbstring \
        php7.4-mysql \
        php7.4-json \
        php7.4-curl \
        php7.4-gd \
        php7.4-xml \
        php7.4-zip \
        vim \
        curl

# Configure Nginx
RUN echo "server {" > /etc/nginx/sites-available/default.conf && \
    echo "    listen 80;" >> /etc/nginx/sites-available/default.conf && \
    echo "    server_name localhost;" >> /etc/nginx/sites-available/default.conf && \
    echo "    client_max_body_size 20M;" >> /etc/nginx/sites-available/default.conf && \
    echo "    root /var/www/html/wordpress;" >> /etc/nginx/sites-available/default.conf && \
    echo "    index index.php index.html index.htm;" >> /etc/nginx/sites-available/default.conf && \
    echo "    location / {" >> /etc/nginx/sites-available/default.conf && \
    echo "        try_files \$uri \$uri/ /index.php?\$args;" >> /etc/nginx/sites-available/default.conf && \
    echo "    }" >> /etc/nginx/sites-available/default.conf && \
    echo "    location ~ \\.php\$ {" >> /etc/nginx/sites-available/default.conf && \
    echo "        include snippets/fastcgi-php.conf;" >> /etc/nginx/sites-available/default.conf && \
    echo "        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;" >> /etc/nginx/sites-available/default.conf && \
    echo "        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;" >> /etc/nginx/sites-available/default.conf && \
    echo "        include fastcgi_params;" >> /etc/nginx/sites-available/default.conf && \
    echo "    }" >> /etc/nginx/sites-available/default.conf && \
    echo "    location = /favicon.ico {" >> /etc/nginx/sites-available/default.conf && \
    echo "        log_not_found off;" >> /etc/nginx/sites-available/default.conf && \
    echo "        access_log off;" >> /etc/nginx/sites-available/default.conf && \
    echo "    }" >> /etc/nginx/sites-available/default.conf && \
    echo "    location = /robots.txt {" >> /etc/nginx/sites-available/default.conf && \
    echo "        allow all;" >> /etc/nginx/sites-available/default.conf && \
    echo "        log_not_found off;" >> /etc/nginx/sites-available/default.conf && \
    echo "        access_log off;" >> /etc/nginx/sites-available/default.conf && \
    echo "    }" >> /etc/nginx/sites-available/default.conf && \
    echo "    location ~ /\\." >> /etc/nginx/sites-available/default.conf && \
    echo "    {" >> /etc/nginx/sites-available/default.conf && \
    echo "        deny all;" >> /etc/nginx/sites-available/default.conf && \
    echo "    }" >> /etc/nginx/sites-available/default.conf && \
    echo "    error_log  /var/log/nginx/error.log;" >> /etc/nginx/sites-available/default.conf && \
    echo "    access_log /var/log/nginx/access.log;" >> /etc/nginx/sites-available/default.conf && \
    echo "}" >> /etc/nginx/sites-available/default.conf

RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/

# Download and extract WordPress
RUN curl -O https://wordpress.org/wordpress-5.6.12.tar.gz && \
    tar -zxvf wordpress-5.6.12.tar.gz -C /var/www/html/ && \
    rm wordpress-5.6.12.tar.gz

RUN chown -R www-data:www-data /var/www/html/wordpress

# Start PHP-FPM and Nginx
CMD service php7.4-fpm start && service nginx start && tail -f /dev/null

# Expose ports
EXPOSE 80
VOLUME /var/www/html/wordpress
