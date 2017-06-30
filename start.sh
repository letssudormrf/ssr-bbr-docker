#!/bin/sh

if [ $# -gt 0 ];
then
        while getopts "p:k:m:O:o:" arg;
                do
                        case $arg in
                                p)
                                        sed -i "3,12s/^.*\"port\":.*$/        \"port\": ${OPTARG},/" mudb.json
                                ;;
                                k)
                                        sed -i "3,12s/^.*\"passwd\":.*$/        \"passwd\": \"${OPTARG}\",/" mudb.json
                                ;;
                                m)
                                        sed -i "3,12s/^.*\"method\":.*$/        \"method\": \"${OPTARG}\",/" mudb.json
                                ;;
                                O)
                                        sed -i "3,12s/^.*\"protocol\":.*$/        \"protocol\": \"${OPTARG}\",/" mudb.json
                                ;;
                                o)
                                        sed -i "3,12s/^.*\"obfs\":.*$/        \"obfs\": \"${OPTARG}\",/" mudb.json
                                ;;
                        esac
                done
fi
cat mudb.json | awk '$1=="\"port\":" {print $NF+0}' | awk '$NF<=65535' > /root/mudb_port.txt

echo -n "" > /root/rinetd.conf
while read line
do
        echo "0.0.0.0 $line 0.0.0.0 $line" >> /root/rinetd.conf
done < /root/mudb_port.txt

/root/rinetd_bbr_powered -f -c /root/rinetd.conf raw eth0 &
python /shadowsocksr/server.py m>> ssserver.log 2>&1
