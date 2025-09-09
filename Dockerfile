# ------- build stage -------
    FROM golang:1.22 AS builder
    WORKDIR /app
    
    # кладём манифесты и vendor внутрь образа
    COPY go.mod go.sum ./
    COPY vendor ./vendor
    # копируем исходники
    COPY . .
    
    # собираем, используя vendor (без сети)
    RUN go build -mod=vendor -o server main.go
    
    # ------- run stage -------
    FROM alpine:3.20
    WORKDIR /app
    COPY --from=builder /app/server .
    COPY tracker.db ./tracker.db
    CMD ["./server"]
    