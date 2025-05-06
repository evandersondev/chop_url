# Build stage
FROM dart:stable AS build

WORKDIR /app
COPY . .
RUN dart pub get
RUN dart compile exe bin/chop_url.dart -o bin/server

# Runtime stage
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/server

CMD ["/app/bin/server"]
