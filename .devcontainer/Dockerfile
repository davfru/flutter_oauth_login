FROM ghcr.io/cirruslabs/flutter:3.27.1

# Install dependencies
RUN apt-get update && apt-get install -y \
    adb wget unzip curl \
    python3 python3-pip python3-venv \
    && apt-get clean

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/awscliv2.zip /tmp/aws

# Install AWS SAM CLI (official installation method)
RUN curl -Lo "/tmp/aws-sam-cli-linux-x86_64.zip" "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" && \
    unzip /tmp/aws-sam-cli-linux-x86_64.zip -d /tmp && \
    sudo /tmp/install && \
    rm -rf /tmp/aws-sam-cli-linux-x86_64.zip /tmp/install

# Install Firebase CLI
RUN curl -sL https://firebase.tools | bash

# Install FlutterFire CLI
RUN dart pub global activate flutterfire_cli

# Set up Android NDK
ENV ANDROID_NDK_VERSION=22
ENV ANDROID_HOME=/opt/android-sdk-linux
ENV ANDROID_NDK_HOME=$ANDROID_HOME/ndk/$ANDROID_NDK_VERSION

# Download and install the NDK
RUN mkdir -p $ANDROID_HOME/ndk && \
    wget https://dl.google.com/android/repository/android-ndk-r$ANDROID_NDK_VERSION-linux-x86_64.zip -O /tmp/ndk.zip && \
    unzip /tmp/ndk.zip -d $ANDROID_HOME/ndk && \
    mv $ANDROID_HOME/ndk/android-ndk-r$ANDROID_NDK_VERSION $ANDROID_NDK_HOME && \
    rm /tmp/ndk.zip

# Ensure the NDK and AWS CLI are in the PATH
ENV PATH="$ANDROID_NDK_HOME:/usr/local/bin:$PATH"

# For FlutterFire CLI
ENV PATH="/root/.pub-cache/bin:$PATH"
