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
COPY nginx-config/default.conf /etc/nginx/sites-available/default.conf

RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/

RUN chown -R www-data:www-data /var/www/html

# Start PHP-FPM and Nginx
CMD service php7.4-fpm start && service nginx start && tail -f /dev/null

# Expose ports
EXPOSE 80
VOLUME /var/www/html
