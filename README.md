# docker-dnsmasq

A lightweight `dnsmasq` Docker container, configurable via a [simple web UI](https://github.com/KewbitXMR/dnsmasq-web-ui).

[![Docker Pulls](https://img.shields.io/docker/pulls/jpillora/dnsmasq.svg)][dockerhub]
[![Image Size](https://images.microbadger.com/badges/image/jpillora/dnsmasq.svg)][dockerhub]

## Overview

`dnsmasq` is a lightweight DNS forwarder, cache, and DHCP server. In this container, it is combined with `webproc`, a web-based process manager, allowing easy configuration and control of `dnsmasq` via a browser interface.

This container allows you to:

- Serve DNS requests on any network.
- Customize DNS configurations through a user-friendly web interface.
- Manage and edit DNS settings in real-time.
- Log and analyze DNS queries.

## Features

- **Web UI**: Configure and manage `dnsmasq` via a simple web-based interface.
- **Authentication**: Protect the web interface with basic authentication.
- **Real-time logging**: Monitor and manage DNS queries and DNS resolution directly from the interface.

## How to Use

### Step 1: Create the Configuration File

First, create a `dnsmasq.conf` file on your Docker host. For example, place it at `/opt/dnsmasq.conf`. A sample configuration might look like this:

```conf
# Log all DNS queries
log-queries

# Use only specified DNS servers (Cloudflare in this example)
no-resolv
server=1.1.1.1
server=1.0.0.1
strict-order

# Serve all .company queries using a specific nameserver
server=/company/10.0.0.1

# Define static IP for specific hosts
address=/myhost.company/10.0.0.2
```

For a more detailed configuration file, refer to the official `dnsmasq` documentation: [dnsmasq.conf](http://oss.segetech.com/intra/srv/dnsmasq.conf).

### Step 2: Run the Container

Run the following command to start the container:

```bash
docker run \
   --name dnsmasq \
   -d \
   -p 53:53/udp \
   -p 5380:8080 \
   -v /opt/dnsmasq.conf:/etc/dnsmasq.conf \
   --log-opt "max-size=100m" \
   -e "HTTP_USER=foo" \
   -e "HTTP_PASS=bar" \
   --restart always \
   havenodex/dnsmasq
```

- **Ports**: 
  - `53`: Standard DNS port (UDP).
  - `8080`: Web UI for managing `dnsmasq`.
  
- **Environment Variables**: 
  - `HTTP_USER` and `HTTP_PASS` define the username and password for the web UI.


### Step 3: Test DNS Resolution

To verify that your `dnsmasq` server is working, run a query from another machine, replacing `<docker-host>` with the IP address or hostname of your Docker host:

```conf
$ host myhost.company <docker-host>
Using domain server:
Name: <docker-host>
Address: <docker-host>#53
Aliases:

myhost.company has address 10.0.0.2
```

### Docker Compose Usage

You can easily set up `dnsmasq` using Docker Compose. Create a `docker-compose.yml` file with the following content:

```yml
version: '3'
services:
  dnsmasq:
    image: kewbit/dnsmasq-webproc
    container_name: dnsmasq
    ports:
      - "53:53/udp"
      - "5380:8080"
    environment:
      HTTP_USER: foo
      HTTP_PASS: bar
    volumes:
      - /opt/dnsmasq.conf:/etc/dnsmasq.conf
    restart: always
    logging:
      options:
        max-size: "100m"
```

### How to Use

1. Create the `dnsmasq.conf` file as described in the **Configuration** section and place it at `/opt/dnsmasq.conf` on your host.

2. Run the container using Docker Compose:

```bash
$ docker-compose up -d
```

3. To stop the container, run:

```bash
docker-compose down
```

## License

This project is licensed under the MIT License.

---

**Contributors**:
Author: [https://github.com/jpillora/webproc](https://github.com/jpillora/webproc) (J Pillora)
Maintainer: [https://kewbit.org](https://kewbit.org)` (Kewbit)

[On Behalf of HavenoDEX]: https://hub.docker.com/u/havenodex/dnsmasq/
