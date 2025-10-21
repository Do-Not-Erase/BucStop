FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Add a tiny verification page so teammates can see the container is running
COPY index.html /usr/share/nginx/html/index.html

# Run nginx in the foreground (default CMD in this image)
