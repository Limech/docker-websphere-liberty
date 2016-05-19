### Description

Installs WebSphere Liberty.
Meant to be used as base image for other apps.

Requires the following files to be in the same folder as the Dockerfile.

* wlp-kernel-8.5.5.9.zip
* ibm-java-jre-8.0-3.0-x86_64-archive.bin
* server.xml

#### To Build
`docker build -t websphere-liberty .`

#### To Run
`docker run -d --name mywsl websphere-liberty`


