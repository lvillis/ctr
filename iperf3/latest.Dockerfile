FROM lvillis/alpine:python-builder AS builder

ENV DIR iperf3
COPY $DIR/requirements.txt .

RUN pip wheel --wheel-dir=/root/wheels -r requirements.txt


FROM lvillis/alpine:python-base AS runtime

COPY --from=builder /root/wheels /root/wheels
RUN python3 -m pip install -r requirements.txt --no-index --find-links=/root/wheels

COPY $DIR/ /root/src
WORKDIR /root/src/

CMD python main.py