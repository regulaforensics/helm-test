{{- define "gateway.env_settings" -}}
SQL_USER = "{{ .Values.envSettings.sqlUser }}"
SQL_PASSWORD = "{{ .Values.envSettings.sqlPassword }}"
SQL_HOST = "{{ .Values.envSettings.sqlHost }}"
SQL_PORT = "{{ .Values.envSettings.sqlPort }}"
SQL_DATABASE = "{{ .Values.envSettings.sqlDatabase }}"
{{- end }}