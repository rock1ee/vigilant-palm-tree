#!/bin/sh

## setup nginx
cat << EOF > /etc/nginx/http.d/default.conf
server {
    listen ${PORT} default_server;
    listen [::]:${PORT} default_server;
    location / {
        root   /var/www/hls.js;
        index  index.html;
    }
    location ${WSPATH} {
    if (\$http_upgrade != "websocket") {
        return 404;
    }
    proxy_pass http://127.0.0.1:9008;
    proxy_redirect off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host \$host;
  }
}
EOF

## setup sing-box
cat << EOF > /tmp/config.json
{
    "inbounds": [
        {
            "type": "trojan",
            "listen": "::",
            "listen_port": 9008,
            "users": [{"password": "${PASSWORD}"}],
            "transport": {"type": "ws","path": "${WSPATH}","max_early_data": 2048,"early_data_header_name": "Sec-WebSocket-Protocol"}
        }
    ],
    "outbounds": [{"type": "direct"}]
}
EOF

## start service
nginx && sing-box run -c /tmp/config.json
