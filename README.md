# Octavia amphora image build

Auto build Octavia amphora image for Openstack Loadbalance service

## Notes 
Auto build turns off name service (resolv), so any outbound connections from amphora image to the world do not work.   
You cannot execute apt update/install within amphora VM. It is done to speed up solution.   
To change it - login to VM and execute mv /etc/nsswitch.conf /etc/nsswitch.conf.bak   
