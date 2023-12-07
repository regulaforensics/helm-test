{{/* Expand the name of the chart. */}}
{{- define "docreader.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "docreader.fullname" -}}
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
{{- define "docreader.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Common labels */}}
{{- define "docreader.labels" -}}
helm.sh/chart: {{ include "docreader.chart" . }}
{{ include "docreader.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Selector labels */}}
{{- define "docreader.selectorLabels" -}}
app.kubernetes.io/name: {{ include "docreader.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Docreader Config name */}}
{{- define "docreader.config.name" -}}
{{ (printf "%s-docreader-config" .Release.Name) }}
{{- end }}

{{/* Docreader license secret name */}}
{{- define "docreader.license.secret" -}}
{{- if .Values.licenseSecretName -}}
{{ default (printf "%s-license" .Release.Name) .Values.licenseSecretName }}
{{- end }}
{{- end }}

{{/* Docreader certificates secret name */}}
{{- define "docreader.certificates.secret" -}}
{{- if .Values.ssl.certificatesSecretName -}}
{{ default (printf "%s-certificates" .Release.Name) .Values.ssl.certificatesSecretName }}
{{- end }}
{{- end }}

{{/* Docreader AWS Credentials secret name */}}
{{- define "docreader.aws.credentials.secret" -}}
{{- if and (eq .Values.storage.type "s3") .Values.storage.s3.awsCredentialsSecretName -}}
{{ default (printf "%s-aws-credentials" .Release.Name) .Values.storage.s3.awsCredentialsSecretName }}
{{- end }}
{{- end }}

{{/* Docreader GCS Credentials secret name */}}
{{- define "docreader.gcs.credentials.secret" -}}
{{- if and (eq .Values.storage.type "gcs") .Values.storage.gcs.gcsKeyJsonSecretName -}}
{{ default (printf "%s-gcs-credentials" .Release.Name) .Values.storage.gcs.gcsKeyJsonSecretName }}
{{- end }}
{{- end }}

{{/* Docreader Azure Storage Connection String secret name */}}
{{- define "docreader.az.credentials.secret" -}}
{{- if and (eq .Values.storage.type "az") .Values.storage.az.connectionStringSecretName -}}
{{ default (printf "%s-az-credentials" .Release.Name) .Values.storage.az.connectionStringSecretName }}
{{- end }}
{{- end }}

{{/* Docreader Database Connection String secret name */}}
{{- define "docreader.db.credentials.secret" -}}
{{- if .Values.database.connectionStringSecretName -}}
{{ default (printf "%s-db-credentials" .Release.Name) .Values.database.connectionStringSecretName }}
{{- end }}
{{- end }}

{{/* Minio endpoint */}}
{{- define "docreader.minio" -}}
{{ default (printf "%s-minio:9000" .Release.Name) }}
{{- end }}

{{/* Minio bucket name */}}
{{- define "docreader.minio.bucket_name" -}}
{{- range .Values.minio.buckets -}}
{{ .name }}
{{- end }}
{{- end }}

{{/* PostgreSQL host */}}
{{- define "docreader.postgresql" -}}
{{ default (printf "%s-postgresql" .Release.Name) }}
{{- end }}

{{/* User defined docreader environment variables */}}
{{- define "docreader.envs" -}}
  {{- range $i, $config := .Values.env }}
  - name: {{ $config.name }}
    value: {{ $config.value | quote }}
  {{- end }}
{{- end }}

{{/* Docreader results existing volume claim */}}
{{- define "results_volume_claim" -}}
{{- if .Values.processing.results.persistence.existingClaim -}}
{{ .Values.processing.results.persistence.existingClaim }}
{{- else -}}
{{ .Release.Name }}-results
{{- end -}}
{{- end -}}

{{/* Docreader rfidpkd existing volume claim */}}
{{- define "rfidpkd_volume_claim" -}}
{{- if .Values.rfidpkd.existingClaim -}}
{{ .Values.rfidpkd.existingClaim }}
{{- end -}}
{{- end -}}
