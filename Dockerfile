# Builder stage to build the Go binary of the application.
FROM golang:1.21-alpine3.18 as builder

# Install make and then build the application using `make build`
RUN apk update && apk add --no-cache make=~4.4
WORKDIR /app
COPY go.mod go.sum main.go Makefile /app/
RUN make build

# Final stage based on distroless image in order for minimalism and security needs.
FROM alpine:3.18

# Copy the binary from the builder stage and set params to be executed.
COPY --from=builder /app/demo.bin /
# Expose server and prometheus metrics port.
EXPOSE 8000 2112
CMD ["/demo.bin"]
