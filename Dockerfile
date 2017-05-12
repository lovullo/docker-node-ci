FROM node:4.8.3

# Update and Install Packages
RUN apt-get update -y && apt-get install -y \
    ant \
    apt-transport-https \
    curl \
    gawk \
    git \
    locales \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Install yarn apt repo
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install yarn
RUN apt-get update -y && apt-get install -y yarn

# Install node-gyp
RUN yarn global add node-gyp 

# Install Ant libraries
RUN curl -O http://dl.google.com/closure-compiler/compiler-20161201.tar.gz && \
    tar -xzvf compiler-20161201.tar.gz closure-compiler-v20161201.jar && \
    mv -v closure-compiler-v20161201.jar /usr/share/ant/lib/closure-compiler.jar && \
    chown root:root /usr/share/ant/lib/closure-compiler.jar && \
    chmod 0644 /usr/share/ant/lib/closure-compiler.jar && \
    rm compiler-20161201.tar.gz

# Set the locale, otherwise various processes using UTF8 files fail
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Disable host key checking from within builds as we cannot interactively accept them
# TODO: It might be a better idea to bake ~/.ssh/known_hosts into the container
RUN mkdir -p ~/.ssh
RUN printf "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
