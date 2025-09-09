# -------- build stage (needs CGO for SQLite) --------
    FROM golang:1.22 AS builder
    WORKDIR /app
    
    # нужен компилятор для сборки SQLite-драйвера
    RUN apt-get update && apt-get install -y gcc
    
    # модули
    COPY go.mod go.sum ./
    RUN go mod download
    
    # код
    COPY . .
    
    # включаем CGO и собираем весь модуль
    ENV CGO_ENABLED=1
    RUN go build -o server .
    
    # -------- run stage --------
    FROM alpine:3.20
    WORKDIR /app
    COPY --from=builder /app/server .
    COPY tracker.db ./tracker.db
    CMD ["./server"]    