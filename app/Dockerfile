ARG     node_image
FROM    $node_image
WORKDIR /app
COPY    . /app
RUN     npm install
CMD     [ "npm", "start" ]
