# ------- build stage -------
    FROM golang:1.22 AS builder
    WORKDIR /app
    
    # скопируем всё сразу (исходники + go.mod/go.sum)
    COPY . .
    
    # соберём main.go напрямую
    RUN go build -o server main.go
    
    # ------- run stage -------
    FROM alpine:3.20
    WORKDIR /app
    COPY --from=builder /app/server .
    COPY tracker.db ./tracker.db
    CMD ["./server"]
    