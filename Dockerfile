FROM nginx:latest
COPY ./index.html /usr/share/nginx/html/index.html
COPY sam.jpg /usr/share/nginx/html/sam.jpg