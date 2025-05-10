# Build stage
FROM gradle:8.6-jdk21 AS build
WORKDIR /app
COPY . .
RUN gradle build --no-daemon

# Run stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Expose the port the app runs on
EXPOSE 8080

# Environment variables with defaults
ENV EUREKA_CLIENT_SERVICEURL_DEFAULTZONE=http://eureka-server:8761/eureka/
ENV EUREKA_INSTANCE_PREFER_IP_ADDRESS=true
ENV EUREKA_INSTANCE_HOSTNAME=eureka-server

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
