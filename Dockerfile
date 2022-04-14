#build stage
FROM node:14.7.0-alpine3.10 as build-stage
WORKDIR /app
COPY package*.json ./
#CMD ["npm", "install"]
RUN npm install
COPY . .
RUN npm run build

#production
FROM nginx:1.19.1-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 3000
CMD [ "nginx", "-g", "daemon off;" ]
