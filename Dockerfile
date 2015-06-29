FROM sameersbn/php5-fpm:latest
MAINTAINER sameer@damagehead.com

ENV INVOICE_PLANE_VERSION=1.4.3 \
    INVOICE_PLANE_USER=${PHP_FPM_USER} \
    INVOICE_PLANE_INSTALL_DIR=/var/www/invoice-plane \
    INVOICE_PLANE_DATA_DIR=/var/lib/invoice-plane

RUN apt-get update \
 && apt-get install -y php5-mysql php5-mcrypt mysql-client \
 && php5enmod mcrypt \
 && rm -rf /var/lib/apt/lists/*

COPY install.sh /var/cache/invoice-plane/install.sh
RUN bash /var/cache/invoice-plane/install.sh

COPY conf/ /var/cache/invoice-plane/conf/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

VOLUME ["${INVOICE_PLANE_INSTALL_DIR}", "${INVOICE_PLANE_DATA_DIR}"]

WORKDIR ${INVOICE_PLANE_INSTALL_DIR}
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/php5-fpm"]
