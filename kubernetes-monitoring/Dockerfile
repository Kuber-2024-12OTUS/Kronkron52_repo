FROM nginx:alpine

# Устанавливаем curl для healthcheck
RUN apk add --no-cache curl

# Копируем конфиг nginx с включенным статусом
COPY nginx.conf /etc/nginx/nginx.conf

# Копируем healthcheck скрипт
COPY healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh

HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD /healthcheck.sh

EXPOSE 80