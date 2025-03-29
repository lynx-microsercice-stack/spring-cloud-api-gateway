FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app

# Install Gradle
RUN apk add --no-cache gradle

# Copy build files
COPY build.gradle settings.gradle ./
COPY src ./src

# Build the application
RUN gradle build -x test

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
EXPOSE 8761
ENTRYPOINT ["java", "-jar", "app.jar"] 