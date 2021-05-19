FROM lvillis/alpine:python-builder AS builder

COPY requirements.txt .

RUN pip wheel --wheel-dir=/root/wheels -r requirements.txt


FROM lvillis/alpine:python-base AS runtime

COPY requirements.txt .
COPY --from=builder /root/wheels /root/wheels
RUN python3 -m pip install -r requirements.txt --no-index --find-links=/root/wheels

COPY . /root/src
WORKDIR /root/src/

CMD python main.py