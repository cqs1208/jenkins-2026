# 使用官方Jenkins LTS镜像
FROM jenkins/jenkins:lts

# 切换到root
USER root

# 修复权限问题
RUN mkdir -p /var/jenkins_home && \
    chown -R jenkins:jenkins /var/jenkins_home && \
    chmod -R 777 /var/jenkins_home

# 设置环境变量
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV JENKINS_USER=admin
ENV JENKINS_PASS=admin

# 安装插件
RUN jenkins-plugin-cli --plugins git workflow-aggregator docker-workflow

# 暴露端口
EXPOSE 8080 50000

# 使用root用户启动（注意安全风险）
USER root
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
