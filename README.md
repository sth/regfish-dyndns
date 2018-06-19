= regfish-dyndns

A shell script and (optionally) systemd service to use Regfish DynDNS
to register the current IP as a domain name.

The systemd service can be used to register the current IP when the
system boots. This is useful for example for cloud servers that get
assigned a new IP address on each start.

== Security

**Don't use the script on a system with untrusted users.**

The Regfish token used to register DNS names is visible to other users
on the system with `ps` or similar tools. Anybody with access to this
token can modify your DNS records.

If you save the token in a config file, restrict its read permissions
as far as possible.

== Installation

Install the `regfish-dyndns.sh` script:

    sudo cp regfish-dyndns.sh /usr/local/bin/

You can use the command line parameters `--fqdn` (the domain for which
you want to set the IP) and `--token` (the Regfish DynDNS token as
obtained from the Regfish web interface) to register the current hosts
IP for the specified domain name.

You can also configure these values in a config file:

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

== Configuation

=== Command line parmeters `--config` or `-C`

Use the specified config file. The default (if available)
is `/etc/regfish-dyndns.conf`.

=== Command line parameter `--fqdn` or `-d`; Config file variable `FQDN`

The fully qualified domain name you want to change to a new IP.

=== Command line parameter `--token` or `-t`; Config file variable `TOKEN`

The Regfish DynDNS token. You get this when enabling DynDNS in Regfish's web
interface for your domain.

**Warning:** This token can be used to modify your DNS, so take care
untrusted users don't get access to it.

=== Command line parameter `--quiet` or `-q`

Don't print output unless an error occurs.