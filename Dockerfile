FROM centos:6.7

MAINTAINER Michel Vallee

RUN yum -y update \
    && yum -y install tar unzip \
    && yum clean all

# Install JRE
ENV JAVA_BIN=ibm-java-jre-8.0-3.0-x86_64-archive.bin \
    WLP_KERNEL=wlp-kernel-8.5.5.9.zip
COPY $JAVA_BIN /tmp/$JAVA_BIN
COPY $WLP_KERNEL /tmp/$WLP_KERNEL  

RUN echo "INSTALLER_UI=silent" > /tmp/response.properties \
    && echo "USER_INSTALL_DIR=/opt/ibm/java" >> /tmp/response.properties \
    && echo "LICENSE_ACCEPTED=TRUE" >> /tmp/response.properties \
    && mkdir -p /opt/ibm \
    && chmod +x /tmp/$JAVA_BIN \
    && /tmp/$JAVA_BIN -i silent -f /tmp/response.properties \
    && rm -f /tmp/response.properties \
    && rm -f /tmp/$JAVA_BIN
ENV JAVA_HOME=/opt/ibm/java \
    PATH=/opt/ibm/java/jre/bin:$PATH

# Install WebSphere Liberty
RUN unzip -q /tmp/$WLP_KERNEL -d /opt/ibm \
    && rm /tmp/$WLP_KERNEL 	
ENV PATH=/opt/ibm/wlp/bin:$PATH

# Set Path Shortcuts
ENV LOG_DIR=/logs \
    WLP_OUTPUT_DIR=/opt/ibm/wlp/output
RUN mkdir /logs \
    && ln -s $WLP_OUTPUT_DIR/defaultServer /output \
    && ln -s /opt/ibm/wlp/usr/servers/defaultServer /config

# Configure WebSphere Liberty
RUN /opt/ibm/wlp/bin/server create \
    && rm -rf $WLP_OUTPUT_DIR/.classCache
    
    
COPY server.xml /opt/ibm/wlp/usr/servers/defaultServer/ 
    
#RUN installUtility install --acceptLicense collectiveMember-1.0 monitor-1.0 webCache-1.0 ldapRegistry-3.0 appSecurity-2.0 localConnector-1.0 restConnector-1.0 ssl-1.0 requestTiming-1.0 sessionDatabase-1.0 
RUN installUtility install --acceptLicense adminCenter-1.0    
    
EXPOSE 9080 9443

CMD ["/opt/ibm/wlp/bin/server", "run", "defaultServer"]