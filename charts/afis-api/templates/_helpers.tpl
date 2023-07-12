{{/*
Expand the name of the chart.
*/}}
{{- define "afis-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "afis-api.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "afis-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "afis-api.labels" -}}
helm.sh/chart: {{ include "afis-api.chart" . }}
{{ include "afis-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "afis-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "afis-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "afis-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "afis-api.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/* PostgreSQL host */}}
{{- define "afis-api.postgresql" -}}
{{ default (printf "%s-postgresql" .Release.Name) }}
{{- end }}

{{- define "afis-api.postgresql.secret" -}}
{{- if .Values.externalPostgreSQLSecret }}
- name: AFISAPI_SQL_URL
  valueFrom:
    secretKeyRef:
      {{- .Values.externalPostgreSQLSecret | toYaml | nindent 6 }}
{{- end }}
{{- end }}

