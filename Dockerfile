FROM brainbeanapps/base-linux-build-environment:latest

LABEL maintainer="devops@brainbeanapps.com"

ENV ANDROID_HOME /opt/android-sdk
ENV DEBIAN_FRONTEND noninteractive

# Switching to root user
USER root

# Installing OpenJDK
RUN apt-get update \
    && apt-get install --no-install-recommends -y openjdk-8-jdk \
    && rm -rf /var/cache/oracle-jdk8-installer \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Install Android Source dependencies
RUN apt-get update \
  && apt-get install --no-install-recommends -y git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Android SDK
WORKDIR /opt
RUN mkdir -p /root/.android/ && touch /root/.android/repositories.cfg \
    && wget -q https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O android-sdk-tools.zip \
    && unzip -q android-sdk-tools.zip -d ${ANDROID_HOME} \
    && rm android-sdk-tools.zip
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

# Accepting license
RUN yes | sdkmanager --licenses

# Installing platform tools
RUN sdkmanager "tools" "platform-tools"

# Installing SDKs and other components
# Accepting all non-standard licenses
RUN yes | sdkmanager \
    "cmake;3.10.2.4988404" \
    "platforms;android-29" \
    "build-tools;29.0.1" \
    "build-tools;29.0.0" \
    "extras;android;m2repository" \
    "extras;google;m2repository" \
    "extras;google;google_play_services" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.1" \
    "patcher;v4" \
    "ndk-bundle" \
    "ndk;20.0.5594570"

# Install Node.js & npm
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
  && apt-get update \
  && apt-get install --no-install-recommends -y nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && npm install -g npm@latest

# Install Yarn & Ruby
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install --no-install-recommends -y yarn ruby ruby-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Switch to user
USER user
WORKDIR /home/user