# OpenVPN config loader

## Configs directory

Copy all your *.ovpn* files (e.g. downloaded from your VPN provider's page) to this directory.

## Extensions directory

In the **extensions** directory put all *.ovpn* files with common configurations.

Example:
* fixing DNS leak `fix-dns.ovpn`

```
# Fix DNS leak on linux machines
script-security 2
up /etc/openvpn/update-resolv-conf
down /etc/openvpn/update-resolv-conf
```
* providing auth credentials `auth.conf`

```
# Set credentials
auth-user-pass <path to your credentials file>

# Prevent password caching
auth-nocache
```

## Running the script

```bash
./openvpn-config-loader.sh
```

The script will list all your *.ovpn* configs in the **configs** directory
e.g. if you choose `ch-02.protonvpn.com.udp1194.ovpn` as the main config and you added additional extentions configs (`fix-dns.ovpn` and `auth.conf`),
the script will run following command:

```bash
sudo openvpn  --config ./configs/ch-02.protonvpn.com.udp1194.ovpn --config ./extensions/auth.ovpn --config ./extensions/fix-dns.ovpn
```