# regfish-dyndns

A shell script and (optionally) systemd service to use Regfish DynDNS
to register the current IP as a domain name.

The systemd service can be used to register the current IP when the
system boots. This is useful for example for cloud servers that get
assigned a new IP address on each start.

## Security

The script uses a Regfish DynDNS token to modify your DNS. **Anybody
with access to this token can modify your DNS records.**

If you use the `--token` command line parameter to pass the Regfish
token, all users can see it, for example with the `ps` command.
*Don't do this on a system with untrusted users.*

The safer option is to let the script read the token form a config
file with the `--config` option, but *make sure this config file is only readable by trusted users.*

## Installation

Install the `regfish-dyndns.sh` script:

    sudo cp regfish-dyndns.sh /usr/local/bin/

You can use the command line parameters `--fqdn` (the domain for which
you want to set the IP) and `--token` (the Regfish DynDNS token as
obtained from the Regfish web interface) to register the current hosts
IP for the specified domain name.

You can also set these values in a config file:

    sudo cp regfish-dyndns.conf /etc/
    sudo vi /etc/regfish-dyndns.conf  # set TOKEN=... and FQDN=...
    # probably you should also restrict its read permissions:
    sudo chmod o-r /etc/regfish-dyndns.conf

This config file is sourced by `regish-dyndns.sh`.

With such a config file you can use the provided systemd service file
to automatically register the current IP when the system boots:

    sudo cp regfish-dyndns.service /etc/systemd/system/
    sudo systemctl enable regfish-dyndns   # execute at system boot
    sudo systemctl start regfish-dyndns    # execute now

## Configuation

### Command line parmeters `--config` or `-C`

Use the specified config file. The default is `/etc/regfish-dyndns.conf`
(if that exists).

### Command line parameter `--fqdn` or `-d`; Config file variable `FQDN`

The fully qualified domain name you want to change to a new IP.

### Command line parameter `--token` or `-t`; Config file variable `TOKEN`

The Regfish DynDNS token. You get this when enabling DynDNS in Regfish's web
interface for your domain.

**Warning:** This token can be used to modify your DNS, so take care that
untrusted users don't get access to it.

### Command line parameter `--ip` or `-i`; Config file variable `IP` (optional)

Set domain name to this IPv4 address. If not specified, use the IP address
the current host uses to connect to the regfish server (`thisipv4=1` in the
Regfish API).

### Command line parameter `--quiet` or `-q`

Don't print output unless an error occurs.
