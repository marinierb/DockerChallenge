ARG  nginx_image
FROM $nginx_image
COPY index.html /var/www/default/index.html
COPY default.conf.template /etc/nginx/conf.d/default.conf.template
CMD envsubst '${APP_HOST} ${APP_PORT} ${WEB_PORT}' \
        < /etc/nginx/conf.d/default.conf.template \
        > /etc/nginx/conf.d/default.conf \
    && cat /etc/nginx/conf.d/default.conf \
    && nginx -g 'daemon off;'