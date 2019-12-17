ARG VERSION="18.04"
FROM ubuntu:$VERSION
RUN echo "version ...."$VERSION
#First dockerfile
LABEL MAINTAINER sp@apps.com
RUN mkdir /code
COPY Sample.sh /code/Sample.sh
COPY testfile /code/testfile
RUN chmod +x /code/Sample.sh
RUN echo "Image is build at `date`"
#ENTRYPOINT ["sh","/code/Sample.sh"]
#default parameter
#CMD ["/code/testfile"]
CMD echo "Container being build"
CMD env
