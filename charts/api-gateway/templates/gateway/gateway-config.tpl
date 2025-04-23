{{- define "gateway.config" -}}
RUNTIME: {{ .Values.gateway.config.runtime | quote }}
{{- if .Values.gateway.config.apiToken }}
GATEWAY_API_TOKEN: {{ .Values.gateway.config.apiToken | quote }}
{{- else if .Values.gateway.config.apiTokenSecret }}
{{- end }}
{{- if .Values.gateway.config.secretKey }}
GATEWAY_SECRET_KEY: {{ .Values.gateway.config.secretKey | quote }}
{{- else if .Values.gateway.config.secretKeySecret }}
{{- end }}
GATEWAY_DEBUG: {{ .Values.gateway.config.debug | quote }}
GATEWAY_LOGS_BASE_PATH: {{ .Values.gateway.config.logsBasePath | quote }}
GATEWAY_ALLOWED_HOSTS: {{ .Values.gateway.config.allowedHosts | quote }}
{{- if .Values.postgresql.enabled }}
GATEWAY_DB_USER: {{ .Values.postgresql.global.postgresql.username | quote }}
GATEWAY_DB_PASSWORD: {{ .Values.postgresql.global.postgresql.password | quote }}
GATEWAY_DB_NAME: {{ .Values.postgresql.global.postgresql.database | quote }}
GATEWAY_DB_HOST: {{ include "postgresql.host" . | quote }}
{{ else }}
GATEWAY_DB_HOST: {{ .Values.gateway.config.database.gateway.host | quote }}
GATEWAY_DB_PORT: {{ .Values.gateway.config.database.gateway.port | quote }}
GATEWAY_DB_NAME: {{ .Values.gateway.config.database.gateway.database | quote }}
{{- if not .Values.gateway.config.database.gateway.gatewaySecret }}
GATEWAY_DB_USER: {{ .Values.gateway.config.database.gateway.user | quote }}
GATEWAY_DB_PASSWORD: {{ .Values.gateway.config.database.gateway.password | quote }}
{{- end }}
{{- end }}
SQL_HOST: {{ .Values.gateway.config.database.tagger.host | quote }}
SQL_PORT: {{ .Values.gateway.config.database.tagger.port | quote }}
SQL_DATABASE: {{ .Values.gateway.config.database.tagger.database | quote }}
{{- if not .Values.gateway.config.database.tagger.taggerSecret }}
SQL_USER: {{ .Values.gateway.config.database.tagger.user | quote }}
SQL_PASSWORD: {{ .Values.gateway.config.database.tagger.password | quote }}
{{- end }}
{{- if not .Values.gateway.config.integration.airflow.airflowSecret }}
AIRFLOW_USER: {{ .Values.gateway.config.integration.airflow.user }}
AIRFLOW_PASSWORD: {{ .Values.gateway.config.integration.airflow.password }}
{{- end }}
{{- end }}
