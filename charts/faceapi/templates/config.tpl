{{- define "faceapi.config" -}}
sdk:
  compare:
    limitPerImageTypes: {{ .Values.sdk.compare.limitPerImageTypes }}
  logging:
    level: {{ quote .Values.sdk.logging.level }}

  {{- if .Values.sdk.detect }}
  detect: {{- toYaml .Values.sdk.detect | nindent 4 }}
  {{- end }}

  {{- if and .Values.liveness.enabled .Values.sdk.liveness  }}
  liveness: {{- toYaml .Values.sdk.liveness | nindent 4 }}
  {{- end }}

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
      cert: "certs/tls.crt"
      key: "certs/tls.key"
      tlsVersion: {{ .Values.ssl.tlsVersion }}
      {{- else }}
      {{- end }}
    logging:
      level: {{ quote .Values.webServer.logging.level }}
      formatter: {{ quote .Values.webServer.logging.formatter }}
      access:
        console: {{ .Values.webServer.logging.access.console }}
        path: {{ quote .Values.webServer.logging.access.path }}
      app:
        console: {{ .Values.webServer.logging.app.console }}
        path: {{ quote .Values.webServer.logging.app.path }}
    metrics:
      enabled: {{ .Values.metrics.enabled }}

  storage:
    {{- if eq .Values.storage.type "fs" }}
    type: fs
    {{- end }}
    {{- if eq .Values.storage.type "s3" }}
    type: s3
    s3:
      {{- if .Values.storage.s3.awsCredentialsSecretName }}
      ## `storage.s3.accessKey/storage.s3.accessSecret` values have been overridden by `storage.s3.awsCredentialsSecretName` value
      {{- else }}
      accessKey: {{ .Values.storage.s3.accessKey }}
      accessSecret: {{ .Values.storage.s3.accessSecret }}
      {{- end }}
      region: {{ default "us-east-1" .Values.storage.s3.region | quote }}
      secure: {{ ne .Values.storage.s3.secure false }}
      endpointUrl: {{ default "https://s3.amazonaws.com" .Values.storage.s3.endpointUrl | quote }}
    {{- end }}
    {{- if eq .Values.storage.type "gcs" }}
    type: gcs
    gcs:
      gcsKeyJson: "/etc/credentials/gcs_key.json"
    {{- end }}
    {{- if eq .Values.storage.type "az" }}
    type: az
    {{- if .Values.storage.az.connectionStringSecretName }}
    ## `storage.az.connectionString` value has been overridden by `storage.az.connectionStringSecretName` value
    {{- else }}
    az:
      connectionString: {{ quote .Values.storage.az.connectionString }}
    {{- end }}
    {{- end }}
  {{- if or .Values.liveness.enabled .Values.search.enabled }}
  {{ if .Values.postgresql.enabled }}
  ## `database` configuration has been overridden by `postgresql.enabled=true` value
  database:
    connectionString: "postgresql://{{ .Values.postgresql.auth.username }}:{{ .Values.postgresql.auth.password }}@{{ template "faceapi.postgresql" . }}:5432/{{ .Values.postgresql.auth.database }}"
  {{- else }}
  {{- if .Values.database.connectionStringSecretName }}
  ## `database` configuration has been overridden by `database.connectionStringSecretName` value
  {{- else }}
  database:
    connectionString: {{ quote .Values.database.connectionString }}
  {{- end }}
  {{- end }}
  {{- end }}

  detectMatch:
    enabled: {{ .Values.detectMatch.enabled }}
    {{- if .Values.detectMatch.enabled }}
    results:
      location:
        {{- if or (eq .Values.storage.type "s3") (eq .Values.storage.type "gcs") }}
        bucket: {{ quote .Values.detectMatch.results.location.bucket }}
        prefix: {{ quote .Values.detectMatch.results.location.prefix }}
        {{- end }}
        {{- if eq .Values.storage.type "az" }}
        container: {{ quote .Values.detectMatch.results.location.container }}
        prefix: {{ quote .Values.detectMatch.results.location.prefix }}
        {{- end }}
        {{- if eq .Values.storage.type "fs" }}
        folder: {{ quote .Values.detectMatch.results.location.folder }}
        {{- end }}
    {{- else }}
    {{- end }}

  liveness:
    enabled: {{ .Values.liveness.enabled }}
    {{- if .Values.liveness.enabled }}
    ecdhSchema: {{ quote .Values.liveness.ecdhSchema }}
    hideMetadata: {{ .Values.liveness.hideMetadata }}
    protectPersonalInfo: {{ .Values.liveness.protectPersonalInfo }}
    sessions:
      location:
        {{- if or (eq .Values.storage.type "s3") (eq .Values.storage.type "gcs") }}
        bucket: {{ quote .Values.liveness.sessions.location.bucket }}
        prefix: {{ quote .Values.liveness.sessions.location.prefix }}
        {{- end }}
        {{- if eq .Values.storage.type "az" }}
        container: {{ quote .Values.liveness.sessions.location.container }}
        prefix: {{ quote .Values.liveness.sessions.location.prefix }}
        {{- end }}
        {{- if eq .Values.storage.type "fs" }}
        folder: {{ quote .Values.liveness.sessions.location.folder }}
        {{- end }}
    {{- else }}
    {{- end }}

  search:
    enabled: {{ .Values.search.enabled }}
    {{- if .Values.search.enabled }}
    persons:
      location:
        {{- if or (eq .Values.storage.type "s3") (eq .Values.storage.type "gcs") }}
        bucket: {{ quote .Values.search.persons.location.bucket }}
        prefix: {{ quote .Values.search.persons.location.prefix }}
        {{- end }}
        {{- if eq .Values.storage.type "az" }}
        container: {{ quote .Values.search.persons.location.container }}
        prefix: {{ quote .Values.search.persons.location.prefix }}
        {{- end }}
        {{- if eq .Values.storage.type "fs" }}
        folder: {{ quote .Values.search.persons.location.folder }}
        {{- end }}

    threshold: {{ .Values.search.threshold }}

    vectorDatabase:
      type: {{ quote .Values.search.vectorDatabase.type }}
      {{- if eq .Values.search.vectorDatabase.type "milvus" }}
      milvus:
        user: {{ quote .Values.search.vectorDatabase.milvus.user }}
        password: {{ quote .Values.search.vectorDatabase.milvus.password }}
        token: {{ quote .Values.search.vectorDatabase.milvus.token }}
        {{- if .Values.milvus.enabled }}
        ## `vectorDatabase.milvus.endpoint` value has been overridden by `milvus.enabled=true` value
        endpoint: "http://{{ template "faceapi.milvus" . }}"
        {{- else }}
        endpoint: {{ quote .Values.search.vectorDatabase.milvus.endpoint }}
        {{- end }}
        consistency: {{ quote .Values.search.vectorDatabase.milvus.consistency }}
        reload: {{ .Values.search.vectorDatabase.milvus.reload }}
        index:
          type: {{ quote .Values.search.vectorDatabase.milvus.index.type }}
          params:
            nlist: {{ .Values.search.vectorDatabase.milvus.index.params.nlist }}
        search:
          type: {{ quote .Values.search.vectorDatabase.milvus.search.type }}
          params:
            nprobe: {{ .Values.search.vectorDatabase.milvus.search.params.nprobe }}
      {{- else }}
      {{- end }}
    {{- else }}
    {{- end }}
{{- end }}
