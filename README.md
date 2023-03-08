# Octavia amphora image build

Auto build and patch Octavia amphora image for Openstack Loadbalance service

### Octavia Image Notes
Auto build turns off name service (resolv), so any outbound connections from amphora to the world do not work (apt update/install, etc...). It is done to speed up solution. To change it - ssh login to amphora and execute 
```
mv /etc/nsswitch.conf /etc/nsswitch.conf.bak
```

Octavia injects through cloud-init:
* /etc/octavia/amphora-agent.conf - config
* /etc/octavia/certs/* - certificates
* /etc/rsyslog.d/10-rsyslog.conf - log policy   

Without config and certificates amphora agent and haproxy doesn't work.   
Rsyslog config used to inject "\*.\* stop" to disable local syslog (octavia option: [amphora_agent] disable_local_log_storage = True)   
Octavia option ([haproxy_amphora] connection_logging = False) can be used to turn off haproxy connection logging, so amphora disk size can be greatly reduced.   

Namespace amphora-haproxy used for network management (VIP + loadbalancer extrenal ip)   
```
ip netns exec amphora-haproxy ip a
```

### Hard disable Octavia HaProхy connection logging
To patch Octavia Amprora qcow2 image to "always disable haproxy logging" run:
```
disable-haproxy-logging.sh
```
Disabling logging can add 10-15% to loadbalancer performance in stress tests   
