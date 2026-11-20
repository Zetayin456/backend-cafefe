FROM debian:stable

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends openjdk-21-jre-headless curl unzip ca-certificates \
    && useradd --create-home --home-dir /home/usuario --shell /usr/sbin/nologin usuario \
    && rm -rf /var/lib/apt/lists/*

USER usuario
WORKDIR /home/usuario
COPY --chown=usuario:usuario src/main/liberty/config/server.xml /tmp/server.xml
RUN curl -fsSL https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/24.0.0.3/openliberty-24.0.0.3.zip -o /tmp/openliberty.zip \
    && unzip -q /tmp/openliberty.zip -d /home/usuario \
    && rm /tmp/openliberty.zip \
    && mkdir -p /home/usuario/wlp/usr/servers/cafefe/dropins /home/usuario/wlp/usr/shared/resources \
    && curl -fsSL https://jdbc.postgresql.org/download/postgresql-42.7.4.jar -o /home/usuario/wlp/usr/shared/resources/postgresql.jar \
    && cp /tmp/server.xml /home/usuario/wlp/usr/servers/cafefe/server.xml \
    && rm /tmp/server.xml

EXPOSE 9080
CMD ["/home/usuario/wlp/bin/server", "run", "cafefe"]
