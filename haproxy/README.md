# Run the container
```
docker run -d --sysctl net.ipv4.ip_unprivileged_port_start=0 haproxy:latest
```

You will need a kernel at version 4.11 or newer to use --sysctl net.ipv4.ip_unprivileged_port_start=0 , you may need to
publish the ports your HAProxy is listening on to the host by specifying the -p option, for example -p 8080:80 to
publish port 8080 from the container host to port 80 in the container. Make sure the port you're using is free.

Note: the 2.4+ versions of the container will run as USER haproxy by default (hence the --sysctl
net.ipv4.ip_unprivileged_port_start=0 above), but older versions still default to root for compatibility reasons; use
--user haproxy (or any other UID) if you want to run as non-root in older versions.