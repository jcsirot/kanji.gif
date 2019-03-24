FROM ubuntu:18.04
LABEL maintainer="kanjis@chelonix.org"

RUN apt-get update && apt-get install -y \
    git \
    python-pip \
    imagemagick \
    gifsicle \
    curl \
    unzip
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g phantomjs-prebuilt svgexport --unsafe-perm
RUN pip install svg.path lxml
RUN mkdir -p /kanjivg
RUN curl -L https://github.com/KanjiVG/kanjivg/releases/download/r20160426/kanjivg-20160426-all.zip -o /tmp/kanjivg.zip 
RUN unzip /tmp/kanjivg.zip -d /kanjivg
RUN git clone https://github.com/jcsirot/kanimaji.git
RUN mkdir -p /out
RUN mkdir -p /in
COPY main.sh /main.sh
RUN chmod +x /main.sh
COPY codepoint.py /codepoint.py
RUN chmod +x /codepoint.py

WORKDIR /kanimaji
VOLUME ["/out"]
ENTRYPOINT ["/main.sh"]