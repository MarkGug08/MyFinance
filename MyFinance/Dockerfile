
FROM dart:stable

# Install dependencies
RUN apt-get update && \
    apt-get install -y unzip xz-utils zip libglu1-mesa && \
    rm -rf /var/lib/apt/lists/*

# Install Flutter SDK
WORKDIR /opt
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"


RUN flutter precache


RUN yes | flutter doctor --android-licenses


RUN flutter doctor -v


WORKDIR /app


COPY . .

# Get dependencies
RUN flutter pub get


RUN flutter analyze


RUN flutter test


RUN flutter build web --release


FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html


EXPOSE 8090


CMD ["nginx", "-g", "daemon off;"]
