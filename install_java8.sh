#!/bin/bash
echo "<---JAVA 8 installation started!-->"
JAVA_DOWNLOAD_URL=http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz
JAVA_DOWNLOAD_FILE=jdk8u45.tar.gz
JAVA_EXTRACTED_FOLDER=$1/jdk8
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" --output-document=$JAVA_DOWNLOAD_FILE $JAVA_DOWNLOAD_URL
mkdir $JAVA_EXTRACTED_FOLDER
tar xzf $JAVA_DOWNLOAD_FILE -C $JAVA_EXTRACTED_FOLDER --strip-components 1
#chown -R $USER:$USER $JAVA_EXTRACTED_FOLDER 
cd $JAVA_EXTARACTED_FOLDER
echo " - installing jdk"
INSTALL_JAVA8=$(alternatives --install /usr/bin/java java $JAVA_EXTRACTED_FOLDER/bin/java 3)
eval $INSTALL_JAVA8
INSTALL_JAVAC8=$(alternatives --install /usr/bin/javac javac $JAVA_EXTRACTED_FOLDER/bin/javac 2)
eval $INSTALL_JAVAC8
echo " - configuring default /usr/bin/java to use installed jdk"
alternatives --config java <<< '3'
alternatives --config javac <<< '2'
echo " - exporting env variables"
export JAVA_HOME=$JAVA_EXTRACTED_FOLDER
export JRE_HOME=$JAVA_EXTRACTED_FOLDER/jre
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
echo "<---JAVA 8 installation finished!-->"
