FROM golang:alpine AS build-env

RUN apk update && apk add git

RUN go get -d gobot.io/x/gobot/...

WORKDIR /

RUN git clone https://github.com/CiscoDevNet/foosball_demo.git

RUN go build -o foosball_player1 /foosball_demo/player1_svc/ir_sensor_mqtt_player1.go

FROM alpine

WORKDIR /

COPY --from=build-env /foosball_player1 .

LABEL "cisco.cpuarch"="x86_64" \
      "cisco.resources.profile"="custom" \
      "cisco.resources.cpu"="50" \
      "cisco.resources.memory"="50" \
      "cisco.resources.disk"="50" \
      "cisco.resources.network.0.interface-name"="eth0"

CMD ["./foosball_player1"]


