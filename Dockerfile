FROM debian:latest

MAINTAINER letssudormrf


#Download applications
RUN apt-get update \
    && apt-get install -y libsodium-dev python git ca-certificates iptables --no-install-recommends


#Make ssr-mudb
ENV PORT="443" \
    PASSWORD="ssr-bbr-docker" \
    METHOD="none" \
    PROTOCOL="auth_chain_a" \
    OBFS="tls1.2_ticket_auth"

RUN git clone https://github.com/shadowsocksr/shadowsocksr.git \
    && cd shadowsocksr \
    && bash initcfg.sh \
    && sed -i 's/sspanelv2/mudbjson/' userapiconfig.py \
    && python mujson_mgr.py -a -u MUDB -p ${PORT} -k ${PASSWORD} -m ${METHOD} -O ${PROTOCOL} -o ${OBFS} -G "#"


#Execution environment
COPY rinetd_bbr rinetd_bbr_powered rinetd_pcc start.sh /root/
RUN chmod a+x /root/rinetd_bbr /root/rinetd_bbr_powered /root/rinetd_pcc /root/start.sh
WORKDIR /shadowsocksr
ENTRYPOINT ["/root/start.sh"]
CMD /root/start.sh
