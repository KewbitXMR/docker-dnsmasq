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

### Step 3: Access the Web Interface

Once the container is running, visit `http://<docker-host>:5380` in your browser. Use the `foo/bar` credentials (or those you set via the environment variables) to log in. You will see an interface like this:

![Web Interface](https://user-images.githubusercontent.com/633843/31580966-baacba62-b1a9-11e7-8439-ca1ddfe828dd.png)

### Step 4: Test DNS Resolution

To verify that your `dnsmasq` server is working, run a query from another machine, replacing `<docker-host>` with the IP address or hostname of your Docker host:

```conf
$ host myhost.company <docker-host>
Using domain server:
Name: <docker-host>
Address: <docker-host>#53
Aliases:

myhost.company has address 10.0.0.2
```

## Advanced Configuration (Webproc)

You can use `webproc` to configure the behavior of `dnsmasq` directly from the browser. Here’s an example of the `program.toml` configuration for `webproc`:

```conf
# Program to execute (with optional Arguments). Note: the process
# must remain in the foreground (i.e. do NOT fork/run as daemon).
ProgramArgs = ["/usr/sbin/dnsmasq", "--no-daemon"]

# Web Interface Host and Port
Host = "0.0.0.0"
Port = 8080

# Optional authentication for Web UI
User = "foo"
Pass = "bar"

# Log settings
Log = "both"

# Action on Process Exit
OnExit = "ignore"

# Action on Save (when saving config from the UI)
OnSave = "restart"

# Configuration files to manage from the UI
ConfigurationFiles = ["/etc/dnsmasq.conf"]
```

You can customize the `program.toml` file to fine-tune `dnsmasq` and `webproc` behavior.

## License

This project is licensed under the MIT License.

---

**Contributors**:
Author: `https://github.com/jpillora/webproc` (J Pillora)
Maintainer: `https://kewbit.org` (Kewbit)

[On Behalf of HavenoDEX]: https://hub.docker.com/u/havenodex/dnsmasq/
