FROM node:20-alpine AS builder

WORKDIR /app
COPY ./instituto-asistencias-front/package*.json ./
RUN npm install
COPY ./instituto-asistencias-front .

ARG VITE_API_BASE_URL
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}

RUN npm run build

FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY ./instituto-deployment/nginx/nginx.conf /etc/nginx/conf.d/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

