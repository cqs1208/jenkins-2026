# 使用官方Jenkins LTS镜像
FROM jenkins/jenkins:lts

# 直接使用jenkins用户，但确保目录权限正确
USER root

# 修复权限问题
RUN chown -R jenkins:jenkins /var/jenkins_home && \
    chmod -R 755 /var/jenkins_home

# 设置环境变量
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV JENKINS_USER=admin
ENV JENKINS_PASS=admin

# 安装插件（在构建时安装，避免首次启动时的网络问题）
USER jenkins
RUN jenkins-plugin-cli --plugins git workflow-aggregator docker-workflow

# 暴露端口
EXPOSE 8080 50000

# 启动Jenkins
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
