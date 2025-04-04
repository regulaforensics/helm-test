{{/* Expand the name of the chart. */}}
{{- define "gateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gateway.fullname" -}}
{{- if .Values.fullnameOverride }}
  {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
  {{- $name := default .Chart.Name .Values.nameOverride }}
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


{{/* Selector labels */}}
{{- define "gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gateway.name" . }}
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
  {{- range $i, $config := .Values.env }}
  - name: {{ $config.name }}
    value: {{ $config.value | quote }}
  {{- end }}
{{- end }}

{{/* Airflow DB SQL connection details */}}
{{- define "gateway.env_settings" -}}
  - name: SQL_USER
    value: "{{ .Values.envSettings.sqlUser }}"
  - name: SQL_PASSWORD
    value: "{{ .Values.envSettings.sqlPassword }}"
  - name: SQL_HOST
    value: "{{ .Values.envSettings.sqlHost }}"
  - name: SQL_PORT
    value: "{{ .Values.envSettings.sqlPort }}"
  - name: SQL_DATABASE
    value: "{{ .Values.envSettings.sqlDatabase }}"
  - name: AIRFLOW_USER
    value: "{{ .Values.envSettings.airflowUser }}"
  - name: AIRFLOW_PASSWORD
    value: "{{ .Values.envSettings.airflowPassword }}"
{{- if .Values.custom_db.enabled }}
  - name: GATEWAY_DB_USER
    value: "{{ .Values.custom_db.username }}"
  - name: GATEWAY_DB_PASSWORD
    value: "{{ .Values.custom_db.password }}"
  - name: GATEWAY_DB_NAME
    value: "{{ .Values.custom_db.database }}"
  - name: GATEWAY_DB_HOST
    value: "{{ .Values.custom_db.host }}"
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
    value: "{{ .Values.envSettings.gatewayAllowedHosts }}"
  - name: GATEWAY_DEBUG
    value: "{{ .Values.envSettings.gatewayDebug }}"
  - name: GATEWAY_LOGS_BASE_PATH
    value: "{{ .Values.envSettings.gatewayLogs }}"
  - name: RUNTIME
    value: "{{ .Values.envSettings.gatewayRuntime }}"
{{- end }}