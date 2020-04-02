FROM nginx:alpine
COPY index.html /var/www/default/index.html
COPY nginx.conf.template /etc/nginx/conf.d/default.conf.template
CMD  envsubst '${APP_PORT} ${WEB_PORT}' \
              < /etc/nginx/conf.d/default.conf.template \
              > /etc/nginx/conf.d/default.conf \
     && nginx -g 'daemon off;'