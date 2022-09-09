{{/* Expand the name of the chart. */}}
{{- define "idv.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "idv.fullname" -}}
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
Create a default fully qualified standalone name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "idv.portal.fullname" -}}
{{ template "idv.fullname" . }}-portal
{{- end -}}


{{/*
Create a default fully qualified standalone name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "idv.proxy.fullname" -}}
{{ template "idv.fullname" . }}-proxy
{{- end -}}


{{/*
Create a default fully qualified standalone name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "idv.coordinator.fullname" -}}
{{ template "idv.fullname" . }}-coordinator
{{- end -}}


{{/*
Create a default fully qualified standalone name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "idv.identity.fullname" -}}
{{ template "idv.fullname" . }}-identity
{{- end -}}

{{/*
Create a default fully qualified standalone name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "idv.keycloakx.headless" -}}
{{ template "idv.fullname" . }}-headless
{{- end -}}


{{/*
Create a default fully qualified standalone name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "idv.keycloakx.http" -}}
{{ template "idv.fullname" . }}-http
{{- end -}}


{{/* Create chart name and version as used by the chart label. */}}
{{- define "idv.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/* Common labels */}}
{{- define "idv.labels" -}}
helm.sh/chart: {{ include "idv.chart" . }}
{{ include "idv.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/* Selector labels */}}
{{- define "idv.selectorLabels" -}}
app.kubernetes.io/name: {{ include "idv.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{- define "idv.coordinator.sql.url" -}}
{{- if .Values.coordinator.idvCoordinatorSqlUrl }}
- name: IDV_COORDINATOR_SQL_URL
  value: {{ .Values.coordinator.idvCoordinatorSqlUrl | quote }}
{{- end }}
{{- end }}


{{- define "idv.coordinator.sql.url.secret" -}}
{{- if .Values.coordinator.idvCoordinatorSqlUrlSecret }}
- name: IDV_COORDINATOR_SQL_URL
  valueFrom:
    secretKeyRef:
      {{- .Values.coordinator.idvCoordinatorSqlUrlSecret | toYaml | nindent 6 }}
{{- end }}
{{- end }}
