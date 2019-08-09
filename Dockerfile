FROM brainbeanapps/base-linux-build-environment:latest
LABEL maintainer="devops@brainbeanapps.com"

ENV ANDROID_HOME /opt/android-sdk

# Switching to root user
USER root

# Updating the system
RUN apt-get update -qq

# Installing OpenJDK and x86 dependencies
RUN dpkg --add-architecture i386
RUN apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-8-jdk libc6:i386 libstdc++6:i386 libgcc1:i386 libncurses5:i386 libz1:i386 \
    && rm -rf /var/cache/oracle-jdk8-installer \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Install Android Source dependencies
RUN apt-get install -y --no-install-recommends git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Android SDK
WORKDIR /opt
RUN wget -q https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O android-sdk-tools.zip \
    && unzip -q android-sdk-tools.zip -d ${ANDROID_HOME} \
    && rm android-sdk-tools.zip
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

# Accepting license
RUN yes | sdkmanager --licenses

# Installing platform tools
RUN sdkmanager "emulator" "tools" "platform-tools"

# Installing SDKs and other components
# Accepting all non-standard licenses
RUN yes | sdkmanager \
    "cmake;3.10.2.4988404" \
    "cmake;3.6.4111459" \
    "platforms;android-29" \
    "build-tools;29.0.1" \
    "build-tools;29.0.0" \
    "system-images;android-29;google_apis;x86" \
    "system-images;android-28;google_apis;x86" \
    "system-images;android-26;google_apis;x86" \
    "system-images;android-25;google_apis;armeabi-v7a" \
    "system-images;android-24;default;armeabi-v7a" \
    "system-images;android-22;default;armeabi-v7a" \
    "system-images;android-19;default;armeabi-v7a" \
    "extras;android;m2repository" \
    "extras;google;m2repository" \
    "extras;google;google_play_services" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.1" \
    "add-ons;addon-google_apis-google-23" \
    "add-ons;addon-google_apis-google-22" \
    "add-ons;addon-google_apis-google-21" \
    "patcher;v4" \
    "ndk-bundle" \
    "ndk;20.0.5594570" \

# Install Node.js & npm
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
  && apt-get update \
  && apt-get install -y --no-install-recommends nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && npm install -g npm@latest

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Switch to user
USER user
WORKDIR /home/user
