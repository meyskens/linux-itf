FROM --platform=$BUILDPLATFORM node:16-alpine as frontend

RUN apk add --no-cache git

COPY ./ /github.com/meyskens/linux-itf
COPY ./.git /github.com/meyskens/linux-itf/.git

WORKDIR /github.com/meyskens/linux-itf

RUN npm install
RUN npm run build

FROM nginx:1.21-alpine

COPY --from=frontend  /github.com/meyskens/linux-itf/dist /var/www/
COPY nginx.conf /etc/nginx/conf.d/default.conf
