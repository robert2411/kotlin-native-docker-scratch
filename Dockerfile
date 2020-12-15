FROM ubuntu AS builder
RUN apt update
RUN apt install openjdk-8-jdk -y
RUN apt install libncurses5 -y
WORKDIR project
COPY . /project
RUN ./gradlew build
RUN mkdir libs
RUN ldd /project/build/bin/native/releaseExecutable/untitled1.kexe | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp --parents {} libs

FROM scratch
COPY --from=builder /project/libs/ /
COPY --from=builder /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
COPY --from=builder /project/build/bin/native/releaseExecutable/untitled1.kexe /hello_world
ENTRYPOINT ["/hello_world"]