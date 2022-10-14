FROM nginx/unit:1.28.0-go1.19 as builder

# Build ample go app
COPY go.mod go.sum main.go /src/
WORKDIR /src
RUN go build main.go
RUN chmod a+x /src/main


# Nginx unit go sample app
FROM nginx/unit:1.28.0-go1.19
COPY --from=builder /src/main /www/app/test-nginx-unit/
COPY config/config.json /docker-entrypoint.d/config.json

EXPOSE 8080