#!/bin/bash

# Concede permissão de execução aos scripts
chmod +x ./client-service-api/mvnw
chmod +x ./insurance-service-api/mvnw

# Entra na pasta client-service-api e gera o JAR
echo "Building client-service-api..."
cd client-service-api
./mvnw clean package -DskipTests
cd ..

# Entra na pasta insurance-service-api e gera o JAR
echo "Building insurance-service-api..."
cd insurance-service-api
./mvnw clean package -DskipTests
cd ..

echo "Build completed."
