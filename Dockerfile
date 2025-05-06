# Etapa de build
FROM dart:stable AS build

WORKDIR /app

RUN apt-get update && \
    apt-get install -y sqlite3 libsqlite3-dev

COPY . .
RUN dart pub get
RUN dart compile exe bin/chop_url.dart -o bin/server

FROM scratch

COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/server

COPY --from=build /usr/lib/x86_64-linux-gnu/libsqlite3.so.0 /usr/lib/libsqlite3.so.0

CMD ["/app/bin/server"]
