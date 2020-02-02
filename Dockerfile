# Build stage - could use maven or our image
FROM maven:3.3-jdk-8 as builder

COPY . .

RUN mvn clean install

FROM openliberty/open-liberty:springBoot2-ubi-min as staging
USER root
COPY --from=builder /target/cloudnativesampleapp-1.0-SNAPSHOT.jar app.jar

RUN springBootUtility thin \
    --sourceAppPath=app.jar \
    --targetThinAppPath=/staging/thinClinic.jar \
    --targetLibCachePath=/staging/lib.index.cache

FROM openliberty/open-liberty:springBoot2-ubi-min

COPY --chown=1001:0 --from=staging /staging/lib.index.cache /opt/ol/wlp/usr/shared/resources/lib.index.cache
COPY --chown=1001:0 --from=staging /staging/thinClinic.jar /config/dropins/spring/thinClinic.jar
