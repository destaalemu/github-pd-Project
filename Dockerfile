FROM nginx:alpine

COPY /src/default.conf /etc/nginx/conf.d/
COPY /src/index.html /usr/share/nginx/html/
