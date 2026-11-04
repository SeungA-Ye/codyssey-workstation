FROM nginx:alpine
LABEL org.opencontainers.image.title="codyssey-web" \
      org.opencontainers.image.description="Codyssey mission 1 custom nginx"
COPY app/ /usr/share/nginx/html/
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s CMD wget -q -O /dev/null http://127.0.0.1/ || exit 1
