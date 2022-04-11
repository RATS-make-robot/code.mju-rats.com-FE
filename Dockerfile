FROM node:12

WORKDIR /code.mju-rats.com-FE
# RUN npm rebuild esbuild
# RUN npm install -g pm2

COPY package*.json ./
COPY yarn.lock ./

COPY . .
RUN rm -rf node_modules
RUN npm install

EXPOSE 3000
# CMD ["npx", "pm2", "start", "ecosystem.config.js", "--no-daemon"]
# CMD ["webpack-dev-server", "--host", "0.0.0.0", "--port", "3000"]
CMD ["npm", "run", "dev"]