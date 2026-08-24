FROM nginx:latest

COPY app/ /usr/share/nginx/html/index.html

EXPOSE 80
