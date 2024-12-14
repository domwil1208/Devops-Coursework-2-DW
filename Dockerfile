FROM node:18

COPY server.js .

EXPOSE 3000

CMD ["node", "server.js"]
