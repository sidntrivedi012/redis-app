# Builder stage to build the Go binary of the application.
FROM golang:1.21-alpine3.18 as builder

# Build arguments for application and redis server address.
ARG APP_ADDRESS
ARG REDIS_ADDRESS

# Install make and then build the application using `make build`
RUN apk update && apk add --no-cache make=~4.4
WORKDIR /app
COPY . /app
RUN make build

# Final stage based on distroless image in order for minimalism and security needs.
FROM gcr.io/distroless/static-debian12
ARG APP_ADDRESS
ARG REDIS_ADDRESS

# Initialize environment variables for application and redis server.
ENV DEMO_APP_ADDR ${APP_ADDRESS}
ENV DEMO_REDIS_ADDR ${REDIS_ADDRESS}

# Copy the binary from the builder stage and set params to be executed.
COPY --from=builder /app/demo.bin /
CMD ["DEMO_APP_ADDR=${DEMO_APP_ADDR} DEMO_REDIS_ADDR=${DEMO_REDIS_ADDR}", "/demo.bin"]
