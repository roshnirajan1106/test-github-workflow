# Dockerfile
FROM openjdk:17-jre-slim

# Build argument for version
ARG BUILD_VERSION=unknown
LABEL version=$BUILD_VERSION

# Create app directory
WORKDIR /app

# Copy the JAR file
COPY target/*.jar app.jar

# Create non-root user
RUN addgroup --system appgroup && adduser --system --group appuser appgroup
RUN chown -R appuser:appgroup /app
USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]