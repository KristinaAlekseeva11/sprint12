# Строим бинарь
FROM golang:1.22 AS builder
WORKDIR /app
COPY . .
RUN go build -o server ./...

# Запуск
FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/server .
COPY tracker.db ./tracker.db
CMD ["./server"]