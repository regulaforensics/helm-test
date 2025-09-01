{{- define "idv.config" -}}
mode: {{ quote .Values.config.mode }}
fernetKey: {{ quote .Values.config.fernetKey }}
baseUrl: {{ quote .Values.config.baseUrl }}
identifier: {{ quote .Values.config.identifier }}

services:
  api:
    enabled: true
    port: {{ .Values.config.services.api.port }}
    host: {{ quote .Values.config.services.api.host }}
    workers: {{ .Values.config.services.api.workers }}
    keepalive: {{ .Values.config.services.api.keepalive }}
    timeout: {{ .Values.config.services.api.timeout }}
    auth:
      enabled: {{ .Values.config.services.api.auth.enabled }}
      {{- if .Values.config.services.api.auth.enabled }}
      jwt:
        secret: {{ .Values.config.services.api.auth.jwt.secret }}
        jwkUrl: {{ .Values.config.services.api.auth.jwt.jwkUrl }}
      {{- end }}
    cors:
      enabled: {{ .Values.config.services.api.cors.enabled }}
      {{- if .Values.config.services.api.cors.enabled }}
      origins: {{ quote .Values.config.services.api.cors.origins }}
      methods: {{ quote .Values.config.services.api.cors.methods }}
      headers: {{ quote .Values.config.services.api.cors.headers }}
      maxAge: {{ .Values.config.services.api.cors.maxAge }}
      {{- end }}
    openapi: {{ .Values.config.services.api.openapi }}

  audit:
    enabled: true
    wsEnabled: {{ .Values.config.services.audit.wsEnabled }}
  
  indexer:
    enabled: true
    timeout: {{ .Values.config.services.indexer.timeout }}

  workflow:
    enabled: true
    workers: {{ .Values.config.services.workflow.workers }}

  scheduler:
    enabled: true
    jobs:
      expireSessions:
        cron: {{ quote .Values.config.services.scheduler.jobs.expireSessions.cron }}
      reloadWorkflows:
        cron: {{ quote .Values.config.services.scheduler.jobs.reloadWorkflows.cron }}
      cleanSessions:
        cron: {{ quote .Values.config.services.scheduler.jobs.cleanSessions.cron }}
        keepFor: {{ quote .Values.config.services.scheduler.jobs.cleanSessions.keepFor }}
      expireDeviceLogs:
        cron: {{ quote .Values.config.services.scheduler.jobs.expireDeviceLogs.cron }}
        keepFor: {{ quote .Values.config.services.scheduler.jobs.expireDeviceLogs.keepFor }}
      reloadLocales:
        cron: {{ quote .Values.config.services.scheduler.jobs.reloadLocales.cron }}
      cronWorkflow:
        cron: {{ quote .Values.config.services.scheduler.jobs.cronWorkflow.cron }}

  docreader:
    enabled: {{ .Values.config.services.docreader.enabled }}
    {{- if .Values.config.services.docreader.enabled }}
    prefix: {{ quote .Values.config.services.docreader.prefix }}
    url: {{ quote .Values.config.services.docreader.url }}
    {{- end }}

  faceapi:
    enabled: {{ .Values.config.services.faceapi.enabled }}
    {{- if .Values.config.services.faceapi.enabled }}
    prefix: {{ quote .Values.config.services.faceapi.prefix }}
    url: {{ quote .Values.config.services.faceapi.url }}
    {{- end }}

logging:
  level: {{ quote .Values.config.logging.level }}
  formatter: {{ quote .Values.config.logging.formatter }}
  console: {{ .Values.config.logging.console }}
  file: {{ .Values.config.logging.file }}
  path: {{ quote .Values.config.logging.path }}
  maxFileSize: {{ .Values.config.logging.maxFileSize }}
  filesCount: {{ .Values.config.logging.filesCount }}

metrics:
  statsd:
    enabled: {{ .Values.config.metrics.statsd.enabled }}
    {{- if .Values.config.metrics.statsd.enabled }}
    {{- if .Values.statsd.enabled }}
    ## prometheus-statsd-exporter subchart is enabled
    host: {{ template "idv.statsd" . }}
    port: {{ .Values.statsd.statsd.tcpPort | default 9125 }}
    {{- else }}
    host: {{ quote .Values.config.metrics.statsd.host }}
    port: {{ .Values.config.metrics.statsd.port | default 9125 }}
    {{- end }}
    prefix: {{ quote .Values.config.metrics.statsd.prefix }}
    {{- end }}

storage:
  {{- if eq .Values.config.storage.type "fs" }}
  type: fs
  fs:
    path: {{ .Values.config.storage.fs.path }}
  {{- end }}
  {{- if eq .Values.config.storage.type "s3" }}
  type: s3
  s3:
    endpoint: {{ .Values.config.storage.s3.endpoint }}
    accessKey: {{ quote .Values.config.storage.s3.accessKey }}
    accessSecret: {{ quote .Values.config.storage.s3.accessSecret }}
    region: {{ quote .Values.config.storage.s3.region }}
    secure: {{ .Values.config.storage.s3.secure }}
  {{- end }}
  {{- if eq .Values.config.storage.type "gcs" }}
  type: gcs
  {{- end}}

  sessions:
    location:
      {{- if eq .Values.config.storage.type "s3" }}
      bucket: {{ quote .Values.config.storage.sessions.location.bucket }}
      prefix: {{ quote .Values.config.storage.sessions.location.prefix }}
      {{- end }}
      {{- if eq .Values.config.storage.type "fs" }}
      folder: {{ quote .Values.config.storage.sessions.location.folder }}
      {{- end }}

  persons:
    location:
      {{- if eq .Values.config.storage.type "s3" }}
      bucket: {{ quote .Values.config.storage.persons.location.bucket }}
      prefix: {{ quote .Values.config.storage.persons.location.prefix }}
      {{- end }}
      {{- if eq .Values.config.storage.type "fs" }}
      folder: {{ quote .Values.config.storage.persons.location.folder }}
      {{- end }}

  workflows:
    location:
      {{- if eq .Values.config.storage.type "s3" }}
      bucket: {{ quote .Values.config.storage.workflows.location.bucket }}
      prefix: {{ quote .Values.config.storage.workflows.location.prefix }}
      {{- end }}
      {{- if eq .Values.config.storage.type "fs" }}
      folder: {{ quote .Values.config.storage.workflows.location.folder }}
      {{- end }}

  userFiles:
    location:
      {{- if eq .Values.config.storage.type "s3" }}
      bucket: {{ quote .Values.config.storage.userFiles.location.bucket }}
      prefix: {{ quote .Values.config.storage.userFiles.location.prefix }}
      {{- end }}
      {{- if eq .Values.config.storage.type "fs" }}
      folder: {{ quote .Values.config.storage.userFiles.location.folder }}
      {{- end }}

  locales:
    location:
      {{- if eq .Values.config.storage.type "s3" }}
      bucket: {{ quote .Values.config.storage.locales.location.bucket }}
      prefix: {{ quote .Values.config.storage.locales.location.prefix }}
      {{- end }}
      {{- if eq .Values.config.storage.type "fs" }}
      folder: {{ quote .Values.config.storage.locales.location.folder }}
      {{- end }}
  
  assets:
    location:
      {{- if eq .Values.config.storage.type "s3" }}
      bucket: {{ quote .Values.config.storage.assets.location.bucket }}
      prefix: {{ quote .Values.config.storage.assets.location.prefix }}
      {{- end }}
      {{- if eq .Values.config.storage.type "fs" }}
      folder: {{ quote .Values.config.storage.assets.location.folder }}
      {{- end }}

mongo:
  url: {{ quote .Values.config.mongo.url }}

topics:
  event:
    name: event
    url: {{ quote .Values.config.topics.event.url }}
    {{- if .Values.config.topics.event.options }}
    options: {{- toYaml  .Values.config.topics.event.options | nindent 8 }}
    {{- end }}
  audit:
    name: audit
    url: {{ quote .Values.config.topics.audit.url }}
    {{- if .Values.config.topics.audit.options }}
    options: {{- toYaml  .Values.config.topics.audit.options | nindent 8 }}
    {{- end }}
  client:
    name: client
    url: {{ quote .Values.config.topics.client.url }}
    {{- if .Values.config.topics.client.options }}
    options: {{- toYaml  .Values.config.topics.client.options | nindent 8 }}
    {{- end }}

faceSearch:
  enabled: {{ .Values.config.faceSearch.enabled }}
  {{- if .Values.config.faceSearch.enabled }}
  limit: {{.Values.config.faceSearch.limit}}
  threshold: {{.Values.config.faceSearch.threshold}}
  database:
    type: {{ quote .Values.config.faceSearch.database.type}}
    {{- if eq .Values.config.faceSearch.database.type "opensearch" }}
    opensearch:
      host: {{ quote .Values.config.faceSearch.database.opensearch.host }}
      port: {{ quote .Values.config.faceSearch.database.opensearch.port }}
      useSsl: {{ .Values.config.faceSearch.database.opensearch.useSsl }}
      verifyCerts: {{ .Values.config.faceSearch.database.opensearch.verifyCerts }}
      username: {{ quote .Values.config.faceSearch.database.opensearch.username }}
      password: {{ quote .Values.config.faceSearch.database.opensearch.password }}
      dimension: {{ .Values.config.faceSearch.database.opensearch.dimension }}
      indexName: {{ quote .Values.config.faceSearch.database.opensearch.indexName }}
      awsAuth:
        enabled: {{ .Values.config.faceSearch.database.opensearch.awsAuth.enabled }}
        region: {{ quote .Values.config.faceSearch.database.opensearch.awsAuth.region }}
        accessKey: {{ quote .Values.config.faceSearch.database.opensearch.awsAuth.accessKey }}
        secretKey: {{ quote .Values.config.faceSearch.database.opensearch.awsAuth.secretKey }}
    {{- end }}
    {{- if eq .Values.config.faceSearch.database.type "atlas" }}
    atlas:
      dimension: {{ .Values.config.faceSearch.database.atlas.dimension }}
    {{- end }}
  {{- end }}

mobile:
{{ .Values.config.mobile | toYaml | indent 2 }}

oauth2:
  enabled: {{ .Values.config.oauth2.enabled }}
  {{- if .Values.config.oauth2.enabled }}
  providers:
  {{- range .Values.config.oauth2.providers }}
    - name: {{ .name | quote }}
      clientId: {{ .clientId | quote }}
      scope: {{ .scope | quote }}
      secret: {{ .secret | quote }}
      type: {{ .type | quote }}
      defaultRoles: {{ .defaultRoles | toJson }}
      defaultGroups: {{ .defaultGroups | toJson }}
      urls:
        jwk: {{ .urls.jwk | quote }}
        authorize: {{ .urls.authorize | quote }}
        token: {{ .urls.token | quote }}
        refresh: {{ .urls.refresh | quote }}
        revoke: {{ .urls.revoke | quote }}
  {{- end }}
  {{- end }}

smtp:
  enabled: {{ .Values.config.smtp.enabled }}
  {{- if .Values.config.smtp.enabled }}
  host: {{ .Values.config.smtp.host | quote }}
  port: {{ .Values.config.smtp.port }}
  username: {{ .Values.config.smtp.username | quote }}
  password: {{ .Values.config.smtp.password | quote }}
  tls: {{ .Values.config.smtp.tls }}
  {{- end }}

textSearch:
  enabled: {{ .Values.config.textSearch.enabled }}
  {{- if .Values.config.textSearch.enabled }}
  limit: {{ .Values.config.textSearch.limit }}
  analyzers: {{ .Values.config.textSearch.analyzers | toYaml | nindent 4 }}
  database:
    type: {{ quote .Values.config.textSearch.database.type }}
  {{- end }}
{{- end }}
