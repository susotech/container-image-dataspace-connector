ARG JDK_VERSION=11
ARG MVN_VERSION=3

FROM maven:${MVN_VERSION}-jdk-${JDK_VERSION} AS maven

ARG VERSION

RUN git clone https://github.com/International-Data-Spaces-Association/DataspaceConnector /tmp/DataspaceConnector

WORKDIR /tmp/DataspaceConnector

RUN git checkout tags/v${VERSION}
RUN mvn verify clean --fail-never
RUN mvn clean package -DskipTests -Dmaven.javadoc.skip=true

FROM gcr.io/distroless/java:${JDK_VERSION}
COPY --from=maven --chown=65532:65532 /tmp/DataspaceConnector/*.jar /app/app.jar

WORKDIR /app

EXPOSE 8080

USER nonroot

ENTRYPOINT ["java","-jar","app.jar"]

LABEL "org.opencontainers.image.documentation"="https://docs.suso.tech" \
      "org.opencontainers.image.licenses"="ASL 2.0" \
      "org.opencontainers.image.source"="https://github.com/susotech/container-image-dataspace-connector" \
      "org.opencontainers.image.url"="https://www.suso.tech" \
      "org.opencontainers.image.vendor"="Christian Berendt"
