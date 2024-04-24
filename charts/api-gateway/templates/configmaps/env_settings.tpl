{{- define "gateway.env_settings" -}}
## AIrflow DB SQL connection details
SQL_USER = "{{ .Values.envSettings.sqlUser }}"
SQL_PASSWORD = "{{ .Values.envSettings.sqlPassword }}"
SQL_HOST = "{{ .Values.envSettings.sqlHost }}"
SQL_PORT = "{{ .Values.envSettings.sqlPort }}"
SQL_DATABASE = "{{ .Values.envSettings.sqlDatabase }}"
AIRFLOW_USER = "{{ .Values.envSettings.airflowUser }}"
AIRFLOW_PASSWORD = "{{ .Values.envSettings.airflowPassword }}"
{{- end }}
