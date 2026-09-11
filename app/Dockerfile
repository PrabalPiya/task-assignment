FROM node:24-bookworm-slim

WORKDIR /app

COPY package.json .
RUN npm install --omit=dev

COPY server.js .

USER node

EXPOSE 5000

CMD ["node", "server.js"]
