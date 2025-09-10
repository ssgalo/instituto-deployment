# --- ETAPA 1: Construcción del Frontend ---
# Usamos una imagen de Node.js para construir la app de React
FROM node:20-alpine AS builder

# Argumento para la variable de entorno de Vite
ARG VITE_API_BASE_URL

# Le pasamos el argumento a una variable de entorno real
ENV VITE_API_BASE_URL=$VITE_API_BASE_URL

WORKDIR /app

# Copiamos el código fuente completo del frontend
COPY ../instituto-asistencias-front .

# Instalamos dependencias y construimos para producción
RUN npm install
RUN npm run build

# --- ETAPA 2: Servidor de Producción con Nginx ---
# Usamos la imagen oficial y ligera de Nginx
FROM nginx:alpine

# Eliminamos la configuración por defecto de Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copiamos nuestra configuración personalizada
COPY nginx.conf /etc/nginx/conf.d/

# Copiamos los archivos construidos desde la etapa anterior
# Esta es la parte clave: tomamos solo el resultado de la construcción
COPY --from=builder /app/dist /usr/share/nginx/html

# Exponemos los puertos
EXPOSE 80
EXPOSE 443

# El comando por defecto de Nginx se encargará del resto
CMD ["nginx", "-g", "daemon off;"]
