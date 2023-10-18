# nginx-ss

nginx-ss == nginx + static site

Deploy static website to docker container.

The default website is hls-player base on hls.js, which let you play video online.

## Config(optional)

ENV:

```
PASSWORD: password of trojan
WSPATH: websocket path
PORT: nginx server port
```

Client:

```
- name: trojan-ws
  type: trojan
  server: server
  port: 443
  password: "PASSWORD"
  network: ws
  sni: example.com
  udp: true
  ws-opts:
    path: /WSPATH
    headers:
      Host: example.com
```

## Reference

https://stackdiary.com/free-hosting-for-developers/

https://www.luke516.blog/blog/free-cloud-hosting