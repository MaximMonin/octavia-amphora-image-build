# Octavia amphora image build

Auto build Octavia amphora image for Openstack Loadbalance service

## Notes 
Auto build turns off name service (resolv), so any outbound connections from amphora VM to the world do not work (apt update/install, etc...). It is done to speed up solution.   
To change it - login to VM and execute mv /etc/nsswitch.conf /etc/nsswitch.conf.bak   

Octavia injects through cloud-init /etc/octavia/amphora-agent.conf - config, /etc/octavia/certs/* - certificates, /etc/rsyslog.d/10-rsyslog.conf - log policy. W/o config and certs amphora agent and haproxy do not work.   
Rsyslog config used to inject "\*.\* stop" to disable local syslog (octavia option: [amphora_agent] disable_local_log_storage = True)   

Namespace amphora-haproxy (ip netns exec amphora-haproxy ip a) used for network management (VIP + loadbalancer extrenal ip)   
Amphora agent updates haproxy config when loadbalancer octavia api called. Check /var/lib/octavia/ dir   

Octavia config ([haproxy_amphora] connection_logging = False) option can be used to turn off haproxy connection logging, so VM disk size can be greatly reduced.   
