# образ
FROM golang:1.24-bookworm

WORKDIR /app

# сборка
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# модули
COPY go.mod go.sum ./
RUN go mod download

# исходники
COPY . .

# сборка
RUN go build -o parcel-tracker .

# запуск
CMD ["./parcel-tracker"]