# -------- build stage (CGO + vendor) --------
    FROM golang:1.22 AS builder
    WORKDIR /app
    
    # для sqlite нужен gcc
    RUN apt-get update && apt-get install -y --no-install-recommends gcc ca-certificates && rm -rf /var/lib/apt/lists/*
    
    # кладём манифесты и vendor
    COPY go.mod go.sum ./
    COPY vendor ./vendor
    
    # кладём исходники
    COPY . .
    
    # включаем CGO и собираем, используя vendor (без сетевых скачиваний)
    ENV CGO_ENABLED=1
    RUN go build -mod=vendor -o server .
    
    # -------- run stage --------
    FROM alpine:3.20
    WORKDIR /app
    COPY --from=builder /app/server .
    COPY tracker.db ./tracker.db
    CMD ["./server"]
       