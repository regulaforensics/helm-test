{{- define "flower.config" -}}
RUNTIME: {{ .Values.gateway.config.runtime | quote }}
FLOWER_UNAUTHENTICATED_API: {{ .Values.flower.config.unauthenticatedApi | quote }}
{{- if .Values.redis.enabled }}
CELERY_BROKER_URL: {{ include "redis.host" . | quote }}
CELERY_RESULT_BACKEND: {{ include "redis.host" . | quote }}
{{ else }}
CELERY_BROKER_URL: {{ default "redis://redis:6379/0" .Values.celery.config.brokerUrl | quote }}
CELERY_RESULT_BACKEND: {{ default "redis://redis:6379/0" .Values.celery.config.resultBackend | quote }}
{{- end }}
{{- end }}
