FROM golang:1.4

RUN apt-get update && apt-get install -y \
	curl vim mercurial git tree \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& useradd -u 1000 dev \
	&& mkdir -p /home/dev \
	&& git clone https://github.com/gmarik/Vundle.vim.git /home/dev/.vim/bundle/Vundle.vim \
	&& mkdir -p /home/dev/go/src \
	&& mkdir -p /var/shared/ \
	&& go get -u github.com/derekparker/delve/cmd/dlv \
	&& go get -u github.com/nsf/gocode \
	&& go get -u golang.org/x/tools/cmd/goimports \
	&& go get -u github.com/rogpeppe/godef \
	&& go get -u golang.org/x/tools/cmd/oracle \
	&& go get -u golang.org/x/tools/cmd/gorename \
	&& go get -u github.com/golang/lint/golint \
	&& go get -u github.com/kisielk/errcheck \
	&& go get -u github.com/jstemmer/gotags 

WORKDIR /home/dev
ENV HOME /home/dev
ENV GOPATH /home/dev/go:$GOPATH
ENV PATH $GOPATH/bin:$PATH
COPY . /home/dev

RUN chown -R dev:dev /var/shared \
	&& chown -R dev:dev /home/dev 

USER dev

RUN ln -s /var/shared/.ssh \
	&& ln -s /var/shared/.bash_history \
	&& ln -s /var/shared/.maintainercfg \
	&& vim +PluginInstall +qall 

CMD ["/bin/bash"]
