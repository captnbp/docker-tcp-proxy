# Stupid TCP Proxy

## What?

Yes, this is a simply and stupid TCP proxy that listens in one address and talks to another one

## Why?

Because when you develop, you don't want your project to talk to real API,
IMAP, POP3, SMTP, SSH, ACME or *[insert your acronym here]* servers.

So, instead of configuring your app to talk to that server, you configure it to
talk to the stupid proxy, and then the stupid proxy redirects connections to
the correct server and port depending on the docker-compose environment you
turn on.

Also you can use it to whitelist services in an internal network ([see the
related issue](https://github.com/moby/moby/issues/36174)).

## How?

We use the official [Alpine][]-based [HAProxy][] image with a small
configuration file.

## Usage

### Available environment variables

Currently there are only these:

#### `$LISTEN`

This variable defines the port where the underlying [HAProxy][] will listen,
and it must be written in the format used by the [`bind`][] directive.

By default (`:100`), it listens in every connection at port 100 (port 100?
that's stupid!... Yes, read the title :point_up::expressionless:).

#### `$TALK`

The target TCP server and port that the proxy will be talking to, in the format
required by [HAProxy][]'s [`server`][] directive.

By default (`192.168.1.1:100`), it talks to a host IP in port 100 too.

#### `$TIMEOUT_CLIENT`

Default: `5s`

This variable sets the maximum inactivity time on the client side.

#### `$TIMEOUT_CLIENT_FIN`

Default: `5s`

This variable sets the inactivity timeout on the client side for half-closed connections.

#### `$TIMEOUT_CONNECT`

Default: `5s`

This variable sets the maximum time to wait for a connection attempt to a server to succeed.

#### `$TIMEOUT_SERVER`

Default: `5s`

This variable sets the maximum inactivity time on the server side.

#### `$TIMEOUT_SERVER_FIN`

Default: `5s`

This variable sets the inactivity timeout on the server side for half-closed connection.

#### `$TIMEOUT_TUNNEL`

Default: `5s`

This variable sets the maximum inactivity time on the client and server side for tunnels.

#### The production environment (`production.yaml` file)

```yaml
version: "2.1"
services:
    # Random app that needs an IMAP server at tcp://imap:143
    app:
        build: .
        links:
            - imap
    # Production address to your real IMAP server
    imap:
        image: tecnativa/tcp-proxy
        environment:
            LISTEN: ":143"
            TALK: "192.168.1.1:993"
```

#### The development environment (`development.yaml` file)

```yaml
version: "2.1"
services:
    # Same configuration as in production for your app
    app:
        build: .
        links:
            - imap
    # Connect to a fake IMAP server
    imap:
        image: tecnativa/tcp-proxy
        environment:
            LISTEN: ":143"
            TALK: "192.168.1.1:143"
```
