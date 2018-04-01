FROM brainbeanapps/base-build-environment:latest

LABEL maintainer="devops@brainbeanapps.com"

# Switch to root
USER root

# Copy assets
WORKDIR /opt
COPY . .

# Install OpenJDK
# Ref: https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04
RUN apt-get update \
  && apt-get install -y --no-install-recommends openjdk-8-jdk \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/oracle-jdk8-installer;

# Setup JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Install Android Source dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Android SDK
ENV ANDROID_HOME /opt/android-sdk
ENV ANDROID_SDK="${ANDROID_HOME}"
# ANDROID_SDK_HOME should not be set in order to use user home directory
ENV ANDROID_SDK_ROOT="${ANDROID_HOME}"
ENV ANDROID_NDK="${ANDROID_HOME}/ndk-bundle"
ENV ANDROID_NDK_ROOT="${ANDROID_NDK}"
ENV ANDROID_NDK_HOME="${ANDROID_NDK}"
ENV PATH="${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_NDK}:${PATH}"
RUN mkdir -p "${ANDROID_HOME}" \
  && wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip -O /opt/sdk-tools-linux.zip \
  && unzip /opt/sdk-tools-linux.zip -d "${ANDROID_HOME}" \
  && rm /opt/sdk-tools-linux.zip \
  && yes | "${ANDROID_HOME}/tools/bin/sdkmanager" --licenses \
  && "${ANDROID_HOME}/tools/bin/sdkmanager" --update --include_obsolete \
  && (while read -r PACKAGE; do (echo "Installing ${PACKAGE}"; yes | "${ANDROID_HOME}/tools/bin/sdkmanager" "$PACKAGE") && continue; break; done < /opt/sdk-packages.list)

# Install Node.js & npm
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
  && apt-get update \
  && apt-get install -y --no-install-recommends nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

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
