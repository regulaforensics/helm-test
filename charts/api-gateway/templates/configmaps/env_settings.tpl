{{- define "gateway.env_settings" -}}
MYSQL_USER = "{{ .Values.envSettings.sqlUser }}"
MYSQL_PASSWORD = "{{ .Values.envSettings.sqlPassword }}"
MYSQL_HOST = "{{ .Values.envSettings.sqlHost }}"
MYSQL_PORT = "{{ .Values.envSettings.sqlPort }}"
MYSQL_DATABASE = "{{ .Values.envSettings.sqlDatabase }}"
{{- end }}