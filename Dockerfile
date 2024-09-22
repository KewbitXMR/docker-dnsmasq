# Use the Go base image to build any Go dependencies you still need (if any)
FROM golang:1.21-alpine AS builder
LABEL maintainer="me@kewbit.org"

# Install dependencies for dnsmasq (no Web UI)
RUN apk update \
    && apk --no-cache add git curl dnsmasq

# If there's any Go-related setup still needed for your application, add it here
# Otherwise, you can skip this step if not required anymore

# Final image
FROM alpine:edge
LABEL maintainer="me@kewbit.org"

# Install dnsmasq directly in the final image
RUN apk update \
    && apk --no-cache add dnsmasq \
    && mkdir -p /etc/default/ \
    && echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq

# Copy dnsmasq configuration file
COPY dnsmasq.conf /etc/dnsmasq.conf

# Copy the entrypoint.sh script into the container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make sure the script is executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port 53 for DNS queries (standard for dnsmasq)
EXPOSE 53 53/udp

# Use entrypoint.sh as the entrypoint to handle the dnsmasq configuration dynamically
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
