{{/* Expand the name of the chart. */}}
{{- define "gateway.name" -}}
{{- default .Chart.Name .Values.gateway.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gateway.fullname" -}}
{{- if .Values.gateway.fullnameOverride }}
  {{- .Values.gateway.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
  {{- $name := default .Chart.Name .Values.gateway.nameOverride }}
{{- if contains $name .Release.Name }}
  {{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
  {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}


{{/* Create chart name and version as used by the chart label. */}}
{{- define "gateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/* Common labels */}}
{{- define "gateway.labels" -}}
helm.sh/chart: {{ include "gateway.chart" . }}
{{ include "gateway.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "flower.labels" -}}
helm.sh/chart: {{ include "gateway.chart" . }}
{{ include "flower.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/* Selector labels */}}
{{- define "gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "flower.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gateway.name" . }}-flower
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* PostgreSQL host */}}
{{- define "gateway.postgresql" -}}
{{ default (printf "%s-postgresql-ha-pgpool" .Release.Name) }}
{{- end }}

{{/* Redis */}}
{{- define "gateway.redis" -}}
{{- if .Values.redis.enabled }}
- name: GATEWAY_REDIS
  value: {{ (printf "redis://%s-redis-master:6379" .Release.Name) }}
{{- end }}
{{- end }}

{{/* User defined gateway environment variables */}}
{{- define "gateway_envs" -}}
  {{- range $i, $config := .Values.gateway.env }}
  - name: {{ $config.name }}
    value: {{ $config.value | quote }}
  {{- end }}
{{- end }}

{{/* Airflow DB SQL connection details */}}
{{- define "gateway.env_settings" -}}
- name: SERVICE
  value: "gateway"
- name: SQL_USER
  value: "{{ .Values.gateway.envSettings.sqlUser }}"
- name: SQL_PASSWORD
  value: "{{ .Values.gateway.envSettings.sqlPassword }}"
- name: SQL_HOST
  value: "{{ .Values.gateway.envSettings.sqlHost }}"
- name: SQL_PORT
  value: "{{ .Values.gateway.envSettings.sqlPort }}"
- name: SQL_DATABASE
  value: "{{ .Values.gateway.envSettings.sqlDatabase }}"
- name: AIRFLOW_USER
  value: "{{ .Values.gateway.envSettings.airflowUser }}"
- name: AIRFLOW_PASSWORD
  value: "{{ .Values.gateway.envSettings.airflowPassword }}"
{{- if .Values.gateway.custom_db.enabled }}
- name: GATEWAY_DB_USER
  value: "{{ .Values.gateway.custom_db.username }}"
- name: GATEWAY_DB_PASSWORD
  value: "{{ .Values.gateway.custom_db.password }}"
- name: GATEWAY_DB_NAME
  value: "{{ .Values.gateway.custom_db.database }}"
- name: GATEWAY_DB_HOST
  value: "{{ .Values.gateway.custom_db.host }}"
{{- else }}
- name: GATEWAY_DB_USER
  value: "{{ index .Values "postgresql-ha" "global" "postgresql" "username" }}"
- name: GATEWAY_DB_PASSWORD
  value: "{{ index .Values "postgresql-ha" "global" "postgresql" "password" }}"
- name: GATEWAY_DB_NAME
  value: "{{ index .Values "postgresql-ha" "global" "postgresql" "database" }}"
- name: GATEWAY_DB_HOST
  value: "{{ include "gateway.postgresql" . }}"
{{- end }}
- name: GATEWAY_ALLOWED_HOSTS
  value: "{{ .Values.gateway.envSettings.gatewayAllowedHosts }}"
- name: GATEWAY_DEBUG
  value: "{{ .Values.gateway.envSettings.gatewayDebug }}"
- name: GATEWAY_LOGS_BASE_PATH
  value: "{{ .Values.gateway.envSettings.gatewayLogs }}"
- name: RUNTIME
  value: "{{ .Values.gateway.envSettings.gatewayRuntime }}"
{{- if .Values.celery.enabled }}
{{- if .Values.redis.enabled }}
- name: CELERY_BROKER_URL
  value: {{ (printf "redis://%s-redis-master:6379" .Release.Name) }}
- name: CELERY_RESULT_BACKEND
  value: {{ (printf "redis://%s-redis-master:6379" .Release.Name) }}
{{- end }}
{{- end }}
{{- end }}

{{- define "celery_envs" -}}
- name: SERVICE
  value: "celery"
- name: CELERY_ACCEPT_CONTENT
  value: "['json']"
- name: CELERY_TASK_SERIALIZER
  value: "json"
- name: CELERY_RESULT_SERIALIZER
  value: "json"
- name: CELERY_TIMEZONE
  value: "UTC"
- name: CELERY_BROKER_CONNECTION_RETRY_ON_STARTUP
  value: "True"
{{- if .Values.redis.enabled }}
- name: CELERY_BROKER_URL
  value: {{ (printf "redis://%s-redis-master:6379" .Release.Name) }}
- name: CELERY_RESULT_BACKEND
  value: {{ (printf "redis://%s-redis-master:6379" .Release.Name) }}
{{- end }}
{{- range $i, $config := .Values.celery.env }}
- name: {{ $config.name }}
  value: {{ $config.value | quote }}
{{- end }}
{{- if .Values.gateway.service.loadBalancerIP }}
- name: CELERY_API_HOST
  value: "{{ .Values.gateway.service.loadBalancerIP }}"
{{- else }}
- name: CELERY_API_HOST
  value: "{{ include "gateway.fullname" . }}"
{{- end }}
{{- if .Values.gateway.custom_db.enabled }}
- name: DJANGO_DB_HOST
  value: "{{ .Values.gateway.custom_db.host }}"
- name: GATEWAY_DB_HOST
  value: "{{ .Values.gateway.custom_db.host }}"
{{- else }}
- name: DJANGO_DB_HOST
  value: "{{ include "gateway.postgresql" . }}"
- name: GATEWAY_DB_HOST
  value: "{{ include "gateway.postgresql" . }}"
{{- end }}
{{- end }}

{{- define "flower_envs" -}}
- name: SERVICE
  value: "flower"
{{- if .Values.celery.enabled }}
{{- if .Values.redis.enabled }}
- name: CELERY_BROKER_URL
  value: {{ (printf "redis://%s-redis-master:6379" .Release.Name) }}
- name: CELERY_RESULT_BACKEND
  value: {{ (printf "redis://%s-redis-master:6379" .Release.Name) }}
{{- end }}
{{- end }}
{{- range $i, $config := .Values.flower.env }}
- name: {{ $config.name }}
  value: {{ $config.value | quote }}
{{- end }}
{{- if .Values.gateway.custom_db.enabled }}
- name: DJANGO_DB_HOST
  value: "{{ .Values.gateway.custom_db.host }}"
- name: GATEWAY_DB_HOST
  value: "{{ .Values.gateway.custom_db.host }}"
{{- else }}
- name: DJANGO_DB_HOST
  value: "{{ include "gateway.postgresql" . }}"
- name: GATEWAY_DB_HOST
  value: "{{ include "gateway.postgresql" . }}"
{{- end }}
{{- end }}