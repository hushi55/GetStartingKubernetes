#!/bin/sh

APP=$1

cat <<EOF >./etc/jetty-deploy.xml
<?xml version="1.0"?>
<!DOCTYPE Configure PUBLIC "-//Jetty//Configure//EN" "http://www.eclipse.org/jetty/configure.dtd">

<!-- =============================================================== -->
<!-- Configure the Jetty Deployers                                   -->
<!-- =============================================================== -->

<Configure id="Server" class="org.eclipse.jetty.server.Server">

    <!-- =========================================================== -->
    <!-- Configure the deployment manager                            -->
    <!--                                                             -->
    <!-- Sets up 2 monitored dir app providers that are configured   -->
    <!-- to behave in a similaraly to the legacy ContextDeployer     -->
    <!-- and WebAppDeployer from previous versions of Jetty.         -->
    <!-- =========================================================== -->
    <Call name="addBean">
      <Arg>
        <New id="DeploymentManager" class="org.eclipse.jetty.deploy.DeploymentManager">
          <Set name="contexts">
            <Ref id="Contexts" />
          </Set>
          <Call name="setContextAttribute">
            <Arg>org.eclipse.jetty.server.webapp.ContainerIncludeJarPattern</Arg>
            <Arg>.*/servlet-api-[^/]*\.jar$</Arg>
          </Call>
          <!-- Providers of Apps via Context XML files.
               Configured to behave similar to the legacy ContextDeployer -->
          <Call name="addAppProvider">
            <Arg>
              <New class="org.eclipse.jetty.deploy.providers.ContextProvider">
                <Set name="monitoredDir"><Property name="jetty.home" default="." />/contexts</Set>
                <!-- <Set name="scanInterval">5</Set> -->
                <Set name="scanInterval">0</Set>
              </New>
            </Arg>
          </Call>
          <!-- Providers of Apps via WAR file existence.
               Configured to behave similar to the legacy WebAppDeployer -->
          <Call name="addAppProvider">
            <Arg>
              <New class="org.eclipse.jetty.deploy.providers.WebAppProvider">
                <Set name="monitoredDir">/kingdee/webapp/root\$${APP}</Set>
                <Set name="defaultsDescriptor"><Property name="jetty.home" default="."/>/etc/webdefault.xml</Set>
                <!-- <Set name="scanInterval">5</Set> -->
                <Set name="scanInterval">0</Set>
                <Set name="contextXmlDir"><Property name="jetty.home" default="." />/contexts</Set>
              </New>
            </Arg>
          </Call>
        </New>
      </Arg>
    </Call>
</Configure>
EOF
