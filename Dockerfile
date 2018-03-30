FROM brainbeanapps/base-build-environment:latest

LABEL maintainer="devops@brainbeanapps.com"

WORKDIR /opt
COPY . .

# Install Android SDK
ENV ANDROID_HOME /opt/android-sdk
ENV ANDROID_SDK="${ANDROID_HOME}"
ENV ANDROID_SDK_HOME="${ANDROID_HOME}"
ENV ANDROID_NDK="${ANDROID_HOME}/ndk-bundle"
ENV ANDROID_NDK_HOME="${ANDROID_NDK}"
ENV PATH="${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_NDK}:${PATH}"
RUN mkdir -p "${ANDROID_HOME}" \
  && mkdir -p "${ANDROID_HOME}/.android" \
  && touch "${ANDROID_HOME}/.android/repositories.cfg" \
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
