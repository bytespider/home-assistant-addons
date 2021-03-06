protocol mqtt
user root
log_dest stdout
log_type error
log_type warning
log_type notice
log_type information
persistence true
persistence_location /data/

# Authentication plugin
plugin /usr/lib/mosquitto_dynamic_security.so
plugin_opt_config_file /etc/mosquitto/dynamic-security.json

# auth_plugin /usr/share/mosquitto/auth-plug.so
# auth_opt_backends files,http
# auth_opt_cache true
# auth_opt_auth_cacheseconds 300
# auth_opt_auth_cachejitter 30
# auth_opt_acl_cacheseconds 300
# auth_opt_acl_cachejitter 30
# auth_opt_log_quiet true

# HTTP backend for the authentication plugin
# auth_opt_password_file /etc/mosquitto/pw
# auth_opt_acl_file /etc/mosquitto/acl

# HTTP backend for the authentication plugin
# auth_opt_http_ip 127.0.0.1
# auth_opt_http_port 80
# auth_opt_http_getuser_uri /authentication
# auth_opt_http_superuser_uri /superuser
# auth_opt_http_aclcheck_uri /acl

{{ if .customize }}
include_dir /share/{{ .customize_folder }}
{{ end }}

tls_version tlsv1.2

listener 1883
protocol mqtt

listener 1884
protocol websockets

{{ if .ssl }}

# Follow SSL listener if a certificate exists
listener 8883
protocol mqtt
{{ if .cafile }}
cafile {{ .cafile }}
{{ else }}
cafile {{ .certfile }}
{{ end }}
certfile {{ .certfile }}
keyfile {{ .keyfile }}
require_certificate {{ .require_certificate }}

listener 8884
protocol websockets
{{ if .cafile }}
cafile {{ .cafile }}
{{ else }}
cafile {{ .certfile }}
{{ end }}
certfile {{ .certfile }}
keyfile {{ .keyfile }}
require_certificate {{ .require_certificate }}

{{ end }}