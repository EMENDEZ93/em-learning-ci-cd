# Usa una imagen base con Gradle preinstalado
FROM gradle:6.8.3-jdk8 AS build

# Configura el directorio de trabajo
WORKDIR /present-verb

# Clona el repositorio y cambia a la rama especificada
RUN git clone -b feature/ciclo https://github.com/EMENDEZ93/present-verb.git .


# Construye el proyecto sin excluir la tarea 'test'
#RUN gradle build -x test --info
RUN gradle build --info
#RUN gradle build --no-daemon --info

# Usa una imagen más ligera para el runtime
FROM openjdk:8-jre-slim AS runtime

# Expone el puerto 8091
EXPOSE 8091

# Crea el directorio de la aplicación
RUN mkdir /app

# Copia el archivo jar construido desde la etapa de construcción a la imagen final
COPY --from=build /present-verb/build/libs/*.jar /app/spring-boot-application.jar

# Define el comando de inicio
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app/spring-boot-application.jar"]

#ENTRYPOINT ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/spring-boot-application.jar"]
