{{- define "docreader.config" -}}
sdk:
  chipVerification:
    enabled: {{ .Values.sdk.chipVerification.enabled }}
  rfid:
    rfidPkdPa: {{ .Values.sdk.rfid.rfidPkdPa }}
    {{- if .Values.sdk.rfid.rfidPkdPa }}
    rfidPkdPaPath: rfid_pkd
    {{- if .Values.sdk.rfid.paSensitiveCodes }}
    paSensitiveCodes: {{- toYaml .Values.sdk.rfid.paSensitiveCodes | nindent 4 }}
    {{- end }}
    {{- else }}
    {{- end }}
  # systemInfo: {{ .Values.sdk.systemInfo }}

service:
  webServer:
    port: {{ .Values.webServer.port }}
    workers: {{ .Values.webServer.workers }}
    timeout: {{ .Values.webServer.timeout }}
    demoApp:
      enabled: {{ .Values.webServer.demoApp.enabled }}
    cors:
      origins: {{ quote .Values.webServer.cors.origins }}
      headers: {{ quote .Values.webServer.cors.headers }}
      methods: {{ quote .Values.webServer.cors.methods }}
    ssl:
      enabled: {{ .Values.ssl.enabled }}
      {{- if .Values.ssl.enabled }}
      cert: certs/tls.crt
      key: certs/tls.key
      tlsVersion: {{ .Values.ssl.tlsVersion }}
      {{- else }}
      {{- end }}
    logging:
      level: {{ .Values.webServer.logging.level }}
      formatter: {{ .Values.webServer.logging.formatter }}
      access:
        console: {{ .Values.webServer.logging.access.console }}
        path: {{ .Values.webServer.logging.access.path }}
      app:
        console: {{ .Values.webServer.logging.app.console }}
        path: {{ .Values.webServer.logging.app.path }}
    metrics:
      enabled: {{ .Values.metrics.enabled }}
  apiV2:
    enabled: {{ .Values.apiV2.enabled }}
  storage:
    {{- if .Values.minio.enabled }}
    ## configuration has been overridden by minio.enabled=true value
    type: s3
    s3:
      accessKey: {{ .Values.minio.rootUser }}
      accessSecret: {{ .Values.minio.rootPassword }}
      endpointUrl: "http://{{ template "docreader.minio" . }}"
      secure: false
    {{- else }}
    {{- if eq .Values.storage.type "fs" }}
    type: fs
    {{- end }}
    {{- if eq .Values.storage.type "s3" }}
    type: s3
    s3:
      {{- if .Values.storage.s3.awsCredentialsSecretName }}
      ## accessKey/accessSecret values have been overridden by storage.s3.awsCredentialsSecretName value
      {{- else }}
      accessKey: {{ .Values.storage.s3.accessKey }}
      accessSecret: {{ .Values.storage.s3.accessSecret }}
      {{- end }}
      region: {{ default "eu-central-1" .Values.storage.s3.region }}
      secure: {{ default "true" .Values.storage.s3.secure }}
    {{- end }}
    {{- if eq .Values.storage.type "gcs" }}
    type: gcs
    gcs:
      gcsKeyJson: "/etc/credentials/gcs_key.json"
    {{- end }}
    {{- if eq .Values.storage.type "az" }}
    type: az
    az:
      {{- if .Values.storage.az.connectionStringSecretName }}
      ## connectionString value has been overridden by storage.az.connectionStringSecretName value
      {{- else }}
      connectionString: {{ .Values.storage.az.connectionString }}
      {{- end }}
    {{- end }}
    {{- end }}
  processing:
    results:
      enabled: {{ .Values.processing.results.enabled }}
      {{- if .Values.processing.results.enabled }}
      location:
        {{- if .Values.minio.enabled }}
        ## configuration has been overridden by minio.enabled=true value
        bucket: "{{ template "docreader.minio.bucket_name" . }}"
        {{- else }}
        {{- if or (eq .Values.storage.type "s3") (eq .Values.storage.type "gcs") }}
        bucket: {{ .Values.processing.results.location.bucket }}
        {{- end }}
        {{- if eq .Values.storage.type "az" }}
        container: {{ .Values.processing.results.location.container }}
        {{- end }}
        {{- if eq .Values.storage.type "fs" }}
        folder: output
        {{- end }}
        {{- end }}
      {{- else }}
      {{- end }}
  {{- if or .Values.apiV2.enabled .Values.sdk.chipVerification.enabled }}
  {{- if .Values.postgresql.enabled }}
  ## configuration has been overridden by postgresql.enabled=true value
  database:
    connectionString: "postgresql://{{ .Values.postgresql.auth.username }}:{{ .Values.postgresql.auth.password }}@{{ template "docreader.postgresql" . }}:5432/{{ .Values.postgresql.auth.database }}"
  {{- else }}
  database:
    {{- if .Values.database.connectionStringSecretName }}
    ## connectionString value has been overridden by database.connectionStringSecretName value
    {{- else }}
    connectionString: {{ .Values.database.connectionString }}
    {{- end }}
  {{- end }}
  {{- end }}
{{- end }}
