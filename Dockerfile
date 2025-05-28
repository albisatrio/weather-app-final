# Gunakan image dasar Android + Gradle
FROM openjdk:11

# Install dependensi
RUN apt-get update && apt-get install -y wget unzip

# Install Android SDK
RUN mkdir -p /opt/android-sdk && \
    cd /opt && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O tools.zip && \
    unzip tools.zip -d /opt/android-sdk/cmdline-tools && \
    mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest && \
    rm tools.zip

# Set environment variable
ENV ANDROID_HOME /opt/android-sdk
ENV PATH $PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator

# Install SDK packages
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2"

# Salin source code ke image
WORKDIR /app
COPY . .

# Build APK
RUN ./gradlew assembleDebug

# Output: app/build/outputs/apk/debug/app-debug.apk
