FROM nightexcessive/gmod-server
MAINTAINER Michael Johnson <michael AT johnson DOT computer>

RUN mkdir /opt/gmod/garrysmod/gamemodes/spaceage
COPY . /opt/gmod/garrysmod/gamemodes/spaceage

ENV GAMEMODE="spaceage"
