# Build stage - could use maven or our image
FROM maven:3.3-jdk-8 as builder

COPY . .
RUN mvn clean install

FROM openliberty/open-liberty:springBoot2-ubi-min as staging

COPY --chown=1001:0 --from=builder /target/cloudnativesampleapp-1.0-SNAPSHOT.jar /config/app.jar
RUN springBootUtility thin \
    --sourceAppPath=/config/app.jar \
    --targetThinAppPath=/config/dropins/spring/thinClinic.jar \
    --targetLibCachePath=/opt/ol/wlp/usr/shared/resources/lib.index.cache

#FROM openliberty/open-liberty:springBoot2-ubi-min

#COPY --chown=1001:0 --from=staging /config/thinClinic.jar /config/dropins/spring/thinClinic.jar
#COPY --chown=1001:0 --from=staging /config/lib.index.cache /opt/ol/wlp/usr/shared/resources/lib.index.cache
#USER root
#RUN mv /thinClinic.jar /config/dropins/thinClinic.jar
#RUN chown 1001:0 /config/dropins/thinClinic.jar
#USER 1001
#USER root
#RUN chown -R 1001:0 /config && chmod -R g+rw /config
#RUN chown -R 1001.0 /opt/ol/wlp/usr/shared/resources/lib.index.cache && chmod -R g+rw /opt/ol/wlp/usr/shared/resources/lib.index.cache
#USER 1001



