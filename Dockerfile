FROM ubuntu:14.04
MAINTAINER Ove Klinghed "ove.klinghed@gmail.com"
ENV REFRESHED_AT 2015-09-29

RUN apt-get update -yqq && apt-get install -qqy curl apt-transport-https
RUN curl https://get.docker.com/gpg | apt-key add -
RUN echo deb http://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-get -y update && apt-get install -y iptables ca-certificates lxc openjdk-7-jdk git-core lxc-docker

ENV JENKINS_HOME /opt/jenkins/data
ENV JENKINS_MIRROR http://mirrors.jenkins-ci.org

RUN mkdir -p $JENKINS_HOME/plugins
RUN curl -sf -o /opt/jenkins/jenkins.war -L $JENKINS_MIRROR/war-stable/latest/jenkins.war

RUN for plugin in chucknorris greenballs scm-api git-client ws-cleanup ;\
  do curl -sf -o $JENKINS_HOME/plugins/${plugin}.hpi \
    -L $JENKINS_MIRROR/plugins/${plugin}/latest/${plugin}.hpi; done

ADD ./dockerjenkins.sh /usr/local/bin/dockerjenkins.sh
RUN chmod +x /usr/local/bin/dockerjenkins.sh

VOLUME /var/lib/docker

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/dockerjenkins.sh"]
