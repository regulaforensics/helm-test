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


{{/* Gateway labels */}}
{{- define "gateway.labels" -}}
helm.sh/chart: {{ include "gateway.chart" . }}
{{ include "gateway.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/* Gateway Selector labels */}}
{{- define "gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/* Gateway Config map name */}}
{{- define "gateway.config.name" -}}
{{ (printf "%s-gateway-config" .Release.Name) }}
{{- end }}


{{/* User defined gateway environment variables */}}
{{- define "gateway_envs" -}}
  {{- range $i, $config := .Values.gateway.env }}
  - name: {{ $config.name }}
    value: {{ $config.value | quote }}
  {{- end }}
{{- end }}


{{/* Celery labels */}}
{{- define "celery.labels" -}}
helm.sh/chart: {{ include "gateway.chart" . }}
{{ include "celery.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/* Celery Selector labels */}}
{{- define "celery.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gateway.name" . }}-celery
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/* Celery Config map name */}}
{{- define "celery.config.name" -}}
{{ (printf "%s-celery-config" .Release.Name) }}
{{- end }}


{{/* User defined celery environment variables */}}
{{- define "celery_envs" -}}
  {{- range $i, $config := .Values.celery.env }}
  - name: {{ $config.name }}
    value: {{ $config.value | quote }}
  {{- end }}
{{- end }}


{{/* Flower labels */}}
{{- define "flower.labels" -}}
helm.sh/chart: {{ include "gateway.chart" . }}
{{ include "flower.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/* Flower Selector labels */}}
{{- define "flower.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gateway.name" . }}-flower
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/* Flower Config map name */}}
{{- define "flower.config.name" -}}
{{ (printf "%s-flower-config" .Release.Name) }}
{{- end }}


{{/* User defined flower environment variables */}}
{{- define "flower_envs" -}}
  {{- range $i, $config := .Values.flower.env }}
  - name: {{ $config.name }}
    value: {{ $config.value | quote }}
  {{- end }}
{{- end }}


{{/* Gateway URL*/}}
{{- define "gateway.url" -}}
{{ include "gateway.fullname" . }}:8000
{{- end }}


{{/* Redis Host*/}}
{{- define "redis.host" -}}
{{ default (printf "redis://%s-redis-master:6379/0" .Release.Name) }}
{{- end }}


{{/* PostgreSQL Host */}}
{{- define "postgresql.host" -}}
{{ default (printf "%s-postgresql-ha-pgpool" .Release.Name) }}
{{- end }}
