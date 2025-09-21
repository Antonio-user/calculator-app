# Image de base Java 17
FROM eclipse-temurin:17-jre

# Copier le jar généré par Maven dans le conteneur
COPY target/calculator-app-1.0-SNAPSHOT.jar app.jar

# Lancer la calculatrice
ENTRYPOINT ["java","-cp","/app.jar","com.example.Calculator"]
