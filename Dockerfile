FROM golang:1.21-alpine AS builder
LABEL maintainer="me@kewbit.org"

# Install dependencies for building webproc and dnsmasq
RUN apk update \
    && apk --no-cache add git curl dnsmasq

# Set the working directory for Go
WORKDIR /app

# Clone your fork of the webproc repository
RUN git clone https://github.com/KewbitXMR/dnsmasq-web-ui.git .

# Build the webproc binary from your fork
RUN go mod tidy \
    && go generate ./... \
    && go build -o /usr/local/bin/webproc .

# Final image
FROM alpine:edge
LABEL maintainer="me@kewbit.org"

# Copy the webproc binary from the build stage
COPY --from=builder /usr/local/bin/webproc /usr/local/bin/webproc

# Fetch dnsmasq and configure it
RUN apk update \
    && apk --no-cache add dnsmasq \
    && mkdir -p /etc/default/ \
    && echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq

# Copy dnsmasq configuration file
COPY dnsmasq.conf /etc/dnsmasq.conf

# Set permissions for the webproc binary
RUN chmod +x /usr/local/bin/webproc

# Expose the port for the web UI
EXPOSE 8080

# Run webproc with dnsmasq configuration
ENTRYPOINT ["webproc", "--config", "/etc/dnsmasq.conf", "--", "dnsmasq", "--no-daemon"]
