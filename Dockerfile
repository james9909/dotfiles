FROM ubuntu:18.04

# Create test user
RUN useradd -m -s /bin/bash tester
RUN usermod -aG sudo tester
RUN echo "tester   ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

COPY . /home/tester/dotfiles
RUN chown -R tester:tester /home/tester/dotfiles

USER tester
ENV HOME /home/tester

WORKDIR /home/tester/dotfiles

RUN ./install.sh
CMD ["/bin/zsh"]
