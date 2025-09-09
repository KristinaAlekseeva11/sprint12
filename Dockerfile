# ---- build stage (modernc.org/sqlite => CGO off) ----
    FROM golang:1.22 AS builder
    WORKDIR /app
    
    # сначала зависимости
    COPY go.mod go.sum ./
    RUN go mod download
    
    # теперь исходники
    COPY . .
    
    # modernc.org/sqlite не требует CGO
    ENV CGO_ENABLED=0
    RUN go build -v -o server .
    
    # ---- run stage ----
    FROM alpine:3.20
    WORKDIR /app
    COPY --from=builder /app/server .
    COPY tracker.db ./tracker.db
    CMD ["./server"]    