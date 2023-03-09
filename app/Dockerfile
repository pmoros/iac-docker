FROM node:18-alpine

ENV MYSQL_HOST ""
ENV MYSQL_USER ""
ENV MYSQL_PASSWORD ""
ENV MYSQL_DB ""

WORKDIR /app
COPY . .
RUN yarn install 
CMD ["node", "src/index.js"]