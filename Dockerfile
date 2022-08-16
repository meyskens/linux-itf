FROM --platform=$BUILDPLATFORM node:16-alpine as frontend

RUN apk add --no-cache git

COPY ./ /go/src/github.com/meyskens/linux-server-graduaten
COPY ./.git /go/src/github.com/meyskens/linux-server-graduaten/.git

WORKDIR /go/src/github.com/meyskens/linux-server-graduaten

RUN npm install
RUN npm run build

FROM nginx:1.21-alpine

COPY --from=frontend  /go/src/github.com/meyskens/linux-server-graduaten/dist /var/www/
COPY nginx.conf /etc/nginx/conf.d/default.conf
