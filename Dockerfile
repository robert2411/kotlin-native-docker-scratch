FROM ubuntu AS builder
RUN apt update
RUN apt install openjdk-8-jdk -y
RUN apt install libncurses5 -y
WORKDIR project1
COPY . /project1
RUN ./gradlew build
ENTRYPOINT ["ldd", "/hello_world"]

FROM scratch
COPY --from=builder /lib/x86_64-linux-gnu/libdl.so.2 /lib/x86_64-linux-gnu/libdl.so.2
COPY --from=builder /lib/x86_64-linux-gnu/libm.so.6 /lib/x86_64-linux-gnu/libm.so.6
COPY --from=builder /lib/x86_64-linux-gnu/libpthread.so.0 /lib/x86_64-linux-gnu/libpthread.so.0
COPY --from=builder /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/x86_64-linux-gnu/libgcc_s.so.1
COPY --from=builder /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libc.so.6
COPY --from=builder /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2

COPY --from=builder /project1/build/bin/native/releaseExecutable/untitled1.kexe /hello_world
ENTRYPOINT ["/hello_world"]