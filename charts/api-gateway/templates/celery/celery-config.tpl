{{- define "celery.config" -}}
RUNTIME: {{ .Values.gateway.config.runtime | quote }}
CELERY_API_HOST: {{ include "gateway.url" . | quote }}
{{- if .Values.redis.enabled }}
CELERY_BROKER_URL: {{ include "redis.host" . | quote }}
CELERY_RESULT_BACKEND: {{ include "redis.host" . | quote }}
{{ else }}
CELERY_BROKER_URL: {{ default "redis://redis:6379/0" .Values.flower.config.brokerUrl | quote }}
CELERY_RESULT_BACKEND: {{ default "redis://redis:6379/0" .Values.flower.config.resultBackend | quote }}
{{- end }}
{{- end }}
