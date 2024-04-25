# Octavia amphora image build

Auto build and patch Octavia amphora image for Openstack Loadbalance Service.

### Octavia Image Notes
Auto build turns off name service (resolv), so any outbound connections from amphora to the world do not work (apt update/install, etc...). It is done to speed up solution.   

Octavia injects through cloud-init:
* /etc/octavia/amphora-agent.conf - config
* /etc/octavia/certs/* - certificates
* /etc/rsyslog.d/10-rsyslog.conf - log policy   

Without config and certificates amphora agent and haproxy doesn't work.   
Rsyslog config used to inject "\*.\* stop" to disable local syslog (octavia option: [amphora_agent] disable_local_log_storage = True).   
Octavia option ([haproxy_amphora] connection_logging = False) can be used to turn off haproxy connection logging, so amphora disk size can be greatly reduced.   

Namespace amphora-haproxy used for network management (VIP + loadbalancer extrenal ip):   
```
ip netns exec amphora-haproxy ip a
```

### Patch Octavia
Few local elements added to patch Octavia Image:
* block-device-efi - included to make sure image works under Legacy and Uefi Bios
* haproxy-logrotate - added haproxy logs rotation
* disable-haproxy-logging - added "always disable haproxy logging". Disabling logging can add 10-20% to loadbalancer performance in stress tests.
* mc - install mc inside amphora   

Remove elements from local elements list if you dont need this patch.
