FROM ubuntu:18.04

# Create test user
RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/* && \
    useradd -m -s /bin/bash tester && \
    usermod -aG sudo tester && \
    echo "tester   ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

COPY . /home/tester/dotfiles
RUN chown -R tester:tester /home/tester/dotfiles

USER tester
ENV HOME /home/tester

WORKDIR /home/tester/dotfiles

RUN bash install.sh
CMD ["/bin/zsh"]
