{ ... }:

{
  networking = let
    server = {
      address = "mesquite.meep.sh";
      port = 51820;
      portStr = builtins.toString server.port;
      publicKey = "aGYKutq/jSiCOnjgJ0nZaM25qfMnEh3lHoyxwLGCVxo=";
    };
    client = {
      addresses = [
        "192.168.2.3/24"
      ];
      allowedIPs = [
        "192.168.0.120/32"
        "192.168.1.0/24"
        "192.168.2.0/24"
      ];
      privateKeyFile = "/etc/wireguard/keys/mesquite";
    };
  in {
    firewall = {
      # if packets are still dropped, they will show up in dmesg
      logReversePathDrops = true;
      # wireguard trips rpfilter up
      extraCommands = ''
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport ${server.portStr} -j RETURN
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport ${server.portStr} -j RETURN
      '';
      extraStopCommands = ''
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport ${server.portStr} -j RETURN || true
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport ${server.portStr} -j RETURN || true
      '';
      allowedUDPPorts = [ server.port ]; # Clients and peers can use the same port, see listenport
    };

    # Enable WireGuard
    wireguard.interfaces = {
      wg0 = {
        # Determines the IP address and subnet of the client's end of the tunnel interface.
        ips = client.addresses;
        listenPort = server.port; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

        privateKeyFile = client.privateKeyFile;

        peers = [
          # For a client configuration, one peer entry for the server will suffice.
          {
            # Public key of the server (not a file path).
            publicKey = server.publicKey;

            # Forward all the traffic via VPN.
            allowedIPs = client.allowedIPs;

            # Set this to the server IP and port.
            endpoint = "${server.address}:${server.portStr}"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

            # Send keepalives every 25 seconds. Important to keep NAT tables alive.
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
