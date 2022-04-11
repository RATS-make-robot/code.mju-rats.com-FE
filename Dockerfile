FROM node:12

WORKDIR /code.mju-rats.com-FE


COPY package*.json ./
COPY yarn.lock ./

COPY . .
RUN rm -rf node_modules
RUN npm install

EXPOSE 3000

CMD ["npm", "run", "dev"]
