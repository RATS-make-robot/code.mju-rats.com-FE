#build stage
FROM node:14.7.0-alpine3.10 as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
RUN npm run build
#CMD ["npm", "run", "dev"] 

#production
FROM nginx:1.19.1-alpine as production-stage

RUN rm -rf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/nginx/default.conf /etc/nginx/conf.d/default.conf

RUN rm -rf /usr/share/nginx/html/*
COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 3000
CMD [ "nginx", "-g", "daemon off;" ]
