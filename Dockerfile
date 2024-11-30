FROM golang:1.23.3-alpine AS builder

WORKDIR /usr/src/parcel
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o ./main

FROM scratch

WORKDIR /usr/src/parcel
COPY --from=builder /usr/src/parcel/main /usr/src/parcel/tracker.db ./
CMD ["./main"]
