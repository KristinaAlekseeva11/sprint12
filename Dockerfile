# build stage
FROM golang:1.22 AS builder
WORKDIR /app

# сначала зависимости
COPY go.mod go.sum ./
RUN go mod download

# теперь исходники
COPY . .

# собираем main.go
RUN go build -o server main.go

# run stage
FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/server .
COPY tracker.db ./tracker.db
CMD ["./server"]
