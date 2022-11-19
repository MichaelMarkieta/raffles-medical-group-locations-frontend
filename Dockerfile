FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json /app/
RUN npm install
COPY . .
RUN npm run build

FROM nginx:stable-alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
ENV NGINX_ENTRYPOINT_QUIET_LOGS=1
CMD ["nginx", "-g", "daemon off;"]