FROM node:4.7.2

# Update and Install Packages
RUN apt-get update -y && apt-get install -y \
    ant \
    git \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Install Ant libraries
RUN curl -O http://dl.google.com/closure-compiler/compiler-20161201.tar.gz && \
    tar -xzvf compiler-20161201.tar.gz closure-compiler-v20161201.jar && \
    mv -v closure-compiler-v20161201.jar /usr/share/ant/lib/closure-compiler.jar && \
    chown root:root /usr/share/ant/lib/closure-compiler.jar && \
    chmod 0644 /usr/share/ant/lib/closure-compiler.jar && \
    rm compiler-20161201.tar.gz

RUN curl -O -L https://downloads.sourceforge.net/project/xframe/xsddoc/xsddoc-1.0/xsddoc-1.0.tar.gz && \
    tar -xzvf xsddoc-1.0.tar.gz xsddoc-1.0/lib/xsddoc.jar && \
    mv -v xsddoc-1.0/lib/xsddoc.jar /usr/share/ant/lib && \
    chown root:root /usr/share/ant/lib/xsddoc.jar && \
    chmod 0644 /usr/share/ant/lib/xsddoc.jar && \
    rm -r xsddoc-1.0/ xsddoc-1.0.tar.gz

# Disable host key checking from within builds as we cannot interactively accept them
# TODO: It might be a better idea to bake ~/.ssh/known_hosts into the container
RUN mkdir -p ~/.ssh
RUN printf "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
