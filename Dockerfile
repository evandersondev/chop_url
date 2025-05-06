FROM dart:stable AS build

WORKDIR /app

COPY . .

RUN dart pub get

RUN dart compile exe bin/chop_url.dart -o bin/server

FROM alpine:latest

# Instala libsqlite3
RUN apk update && apk add sqlite-libs

# Cria diretório de app
WORKDIR /app

COPY --from=build /runtime/ /runtime/
COPY --from=build /app/bin/server /app/bin/server

CMD ["/app/bin/server"]