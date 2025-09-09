# ---- build stage (modernc.org/sqlite => CGO off) ----
    FROM golang:1.22 AS builder
    WORKDIR /app
    
    # стабильные сетевые настройки для модулей
    ENV CGO_ENABLED=0 \
        GOPROXY=https://proxy.golang.org,direct \
        GOSUMDB=sum.golang.org
    
    # копируем весь проект сразу (go.mod/go.sum тоже попадут)
    COPY . .
    
    # сборка; go сам вытянет зависимости
    RUN go build -v -o server .
    
    # ---- run stage ----
    FROM alpine:3.20
    WORKDIR /app
    COPY --from=builder /app/server .
    COPY tracker.db ./tracker.db
    CMD ["./server"]
     