{{/* Expand the name of the chart. */}}
{{- define "faceapi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "faceapi.fullname" -}}
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
{{- define "faceapi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/* Common labels */}}
{{- define "faceapi.labels" -}}
helm.sh/chart: {{ include "faceapi.chart" . }}
{{ include "faceapi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/* Selector labels */}}
{{- define "faceapi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "faceapi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/* faceapi license secret name */}}
{{- define "license_secret" -}}
{{ default (printf "%s-license" .Release.Name) .Values.licenseSecretName }}
{{- end }}

{{/* faceapi certificates secret name */}}
{{- define "certificate_secret" -}}
{{ default (printf "%s-certificates" .Release.Name) .Values.httpsCertificateSecretName }}
{{- end }}


{{/* Config map name */}}
{{- define "config" -}}
{{ (printf "%s-config" .Release.Name) }}
{{- end }}


{{/* version name */}}
{{- define "version" -}}
{{- if .Values.version | default "cpu" | lower | regexMatch "^(cpu|gpu)$" -}}
  {{ .Values.version | default "cpu" | lower }}
{{- else}}
  {{ required (printf "Incorrect 'version': %s. Possible value: cpu or gpu" .Values.version ) nil }}
{{- end -}}
{{- end -}}


{{/* User defined faceapi environment variables */}}
{{- define "faceapi_envs" -}}
  {{- range $i, $config := .Values.env }}
  - name: {{ $config.name }}
    value: {{ $config.value | quote }}
  {{- end }}
{{- end }}

{{/* Create a default fully qualified postgresql name. */}}
{{- define "faceapi.postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* identification enabled */}}
{{- define "identification" -}}
{{- if .Values.identification.enabled }}
- name: ENABLE_IDENTIFICATION
  value: "true"
{{- end -}}
{{- end -}}

{{- define "faceapi_postgres_envs" -}}
{{- if and .Values.identification.enabled .Values.postgresql.enabled }}
- name: SQL_USER
  value: "{{ .Values.postgresql.postgresqlUsername }}"
- name: SQL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-postgresql
      key: postgresql-password
- name: SQL_HOST
  value: "{{ include "faceapi.postgresql.fullname" . }}:{{ .Values.postgresql.service.port }}"
- name: SQL_DB
  value: "{{ .Values.postgresql.postgresqlDatabase }}"
- name: SQL_DIALECT
  value: "postgresql"
{{- else if and .Values.identification.enabled (not .Values.postgresql.enabled) (or .Values.externalPostgreSQLSecret .Values.externalPostgreSQL) }}
- name: SQL_URL
  {{- if .Values.externalPostgreSQLSecret }}
  valueFrom:
    secretKeyRef:
      {{- .Values.externalPostgreSQLSecret | toYaml | nindent 6 }}
  {{- else }}
  value: {{ default "" .Values.externalPostgreSQL | quote }}
  {{- end }}
{{- else if .Values.identification.enabled }}
{{ required (printf "Identification mode require postgresql to be enabled or externalPostgreSQL/externalPostgreSQLSecret values are set") nil }}
{{- end }}
{{- end }}


{{/* faceapi logs existing volume claim */}}
{{- define "logs_volume_claim" -}}
{{- if .Values.logs.persistence.existingClaim -}}
  {{ .Values.logs.persistence.existingClaim }}
{{- else -}}
  {{ .Release.Name }}-logs
{{- end -}}
{{- end -}}