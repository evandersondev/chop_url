# Etapa de build
FROM dart:stable AS build
WORKDIR /app

RUN apt-get update && apt-get install -y sqlite3 libsqlite3-dev
COPY . .
RUN dart pub get
RUN dart compile exe bin/chop_url.dart -o bin/server --enable-experiment=ffi-static

# Etapa final (com libsqlite3.so)
FROM debian:bullseye-slim

# Instala apenas a lib necessária
RUN apt-get update && apt-get install -y sqlite3 libsqlite3-dev libsqlite3-0 && apt-get clean

COPY --from=build /app/bin/server /app/bin/server
COPY --from=build /runtime/ /

CMD ["/app/bin/server"]
