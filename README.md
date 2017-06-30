SSR-BBR-DOCKER
==================

Quick Start
-----------

This image uses Shadowsocksr multi-user feature to run the multi-user on one port containers with 3 types(BBR/BBR_POWERED/PCC) tcp congestion.

    docker run --privileged -d -p 443:443/tcp -p 443:443/udp --name ssr-bbr-docker letssudormrf/ssr-bbr-docker

Also it can specify the vaule of "-p PORT -k PASSWORD -m METHOD -O PROTOCOL -o OBFS" to run the container.

    docker run --privileged -d -p 465:465/tcp -p 465:465/udp --name ssr-bbr-docker letssudormrf/ssr-bbr-docker -p 465 -k password -m aes-128-ctr -O auth_aes128_sha1 -o http_post

Keep the Docker container running automatically after starting, add **--restart always**.

    docker run --restart always --privileged -d -p 443:443/tcp -p 443:443/udp --name ssr-bbr-docker letssudormrf/ssr-bbr-docker

**important:** For using the feature of multi-user on one port, please set up the multi-user's port greater than 65535

To add multi-user imformation

    docker exec -it ssr-bbr-docker python mujson_mgr.py -a -u USER1_ID -p 100000 -k USER1_PW

To edit multi-user imformation

    docker exec -it ssr-bbr-docker python mujson_mgr.py -e -u USER1_ID -p 100000 -k USER1_PW

To delete multi-user imformation

    docker exec -it ssr-bbr-docker python mujson_mgr.py -d -u USER1_ID

To list multi-user imformation

    docker exec -it ssr-bbr-docker python mujson_mgr.py -l -u USER1_ID

To limit device connection number(2 devices)

    docker exec -it ssr-bbr-docker python mujson_mgr.py -e -u USER1_ID -G 2

To limit transfer bandwidth(1 GB)

    docker exec -it ssr-bbr-docker python mujson_mgr.py -e -u USER1_ID -t 1 

Advanced Usage 
-----------

To backup the mudb.json configuration file to local mudb.json.bak

    docker exec -i ssr-bbr-docker cat mudb.json > ./mudb.json.bak

To recovery the mudb.json configuration file from local mudb.json.bak

    docker exec -i ssr-bbr-docker /bin/sh -c "cat > mudb.json" < ./mudb.json.bak 

To redirect the authentication failed connecting to others ip or website (IP:1.2.3.4 port:80)

    docker exec -it ssr-bbr-docker sed -i "s/^.*\"redirect\":.*$/    \"redirect\": \"1.2.3.4:80\",/" user-config.json
    docker restart ssr-bbr-docker

To change to the others congestion, then restart the container (Default:BBR_POWERED)

    sed -i 's/^\/root\/rinetd_.*/\/root\/rinetd_bbr -f -c \/root\/rinetd.conf raw eth0 \&/' start.sh
    
    sed -i 's/^\/root\/rinetd_.*/\/root\/rinetd_bbr_powered -f -c \/root\/rinetd.conf raw eth0 \&/' start.sh
    
    sed -i 's/^\/root\/rinetd_.*/\/root\/rinetd_pcc -f -c \/root\/rinetd.conf raw eth0 \&/' start.sh
    
    docker restart ssr-bbr-docker

IPv6 Connection
-----------
**Support for IPv6:** (untested)
Using NDP proxying
<https://docs.docker.com/engine/userguide/networking/default_network/ipv6/#using-ndp-proxying>

Simple command sample(2001:db8::c009 is docker container global ipv6 address):
   
    sysctl -w net.ipv6.conf.eth0.proxy_ndp=1
    ip -6 neigh add proxy 2001:db8::c009 dev eth0

Also use the following command for changing to IPv6 DNS, then restart the container.

    docker exec -it ssr-bbr-docker sed -i 's/"dns_ipv6": false/"dns_ipv6": true/' user-config.json
    docker restart ssr-bbr-docker

More Options
-----------

```
usage: python mujson_manage.py -a|-d|-e|-c|-l [OPTION]...

Actions:
  -a ADD               add/edit a user
  -d DELETE            delete a user
  -e EDIT              edit a user
  -c CLEAR             set u/d to zero
  -l LIST              display a user infomation or all users infomation

Options:
  -u USER              the user name
  -p PORT              server port (only this option must be set if add a user)
  -k PASSWORD          password
  -m METHOD            encryption method, default: aes-128-ctr
  -O PROTOCOL          protocol plugin, default: auth_aes128_md5
  -o OBFS              obfs plugin, default: tls1.2_ticket_auth_compatible
  -G PROTOCOL_PARAM    protocol plugin param
  -g OBFS_PARAM        obfs plugin param
  -t TRANSFER          max transfer for G bytes, default: 8388608 (8 PB or 8192 TB)
  -f FORBID            set forbidden ports. Example (ban 1~79 and 81~100): -f "1-79,81-100"
  -i MUID              set sub id to display (only work with -l)

General options:
  -h, --help           show this help message and exit
```
