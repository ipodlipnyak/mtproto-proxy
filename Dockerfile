FROM ubuntu:jammy AS dependencies 
# Dependencies
RUN apt-get update
RUN apt install -y git curl build-essential libssl-dev zlib1g-dev
# Clone the repository and Build
RUN git clone https://github.com/TelegramMessenger/MTProxy

# Build fix: https://github.com/TelegramMessenger/MTProxy/pull/531
COPY /src/Makefile MTProxy/Makefile

FROM dependencies AS compilation

WORKDIR MTProxy
RUN make && cd objs/bin

# The final binary will be in objs/bin/mtproto-proxy

FROM ubuntu:jammy AS configuration

RUN apt-get update
RUN apt install -y curl xxd

RUN mkdir /config
COPY --from=compilation /MTProxy/objs/bin/mtproto-proxy /usr/local/bin/mtproto-proxy
COPY /src/start.sh start.sh
RUN chmod +x start.sh

CMD ./start.sh
