# Fase 1: Construcción
FROM node:14 AS builder

# Instalar pnpm globalmente
RUN npm install -g pnpm

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar los archivos de configuración
COPY package.json pnpm-lock.yaml ./

# Instalar las dependencias
RUN pnpm install

# Copiar el resto de la aplicación
COPY . .

# Compilar la aplicación
RUN pnpm run build

# Fase 2: Producción
FROM nginx:alpine

# Copiar los archivos compilados desde la fase de construcción
COPY --from=builder /app/build /usr/share/nginx/html

# Exponer el puerto que utilizará nginx
EXPOSE 80

# Comando para ejecutar nginx
CMD ["nginx", "-g", "daemon off;"]
