FROM --platform=$BUILDPLATFORM node:16 as frontend

COPY ./ /github.com/meyskens/linux-itf

WORKDIR /github.com/meyskens/linux-itf

RUN npm install
RUN npm run build

FROM nginx:1.21-alpine

COPY --from=frontend  /github.com/meyskens/linux-itf/dist /var/www/
COPY nginx.conf /etc/nginx/conf.d/default.conf
