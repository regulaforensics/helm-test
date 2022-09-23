{{- define "coordinator.config" -}}
# PostgreSQL
## Please mind if idvCoordinatorSqlUrlSecret value is set, it overrides any other PostgreSQL related values
ALEMBIC_DB_CONN_STR="{{ .Values.coordinator.idvCoordinatorSqlUrl }}"

# Pulsar
IDV_COORDINATOR_PULSAR_URL="{{ template "idv.pulsar.url" . }}"
IDV_COORDINATOR_PULSAR_TENANT="{{ .Values.coordinator.idvCoordinatorPulsarTenant }}"
IDV_COORDINATOR_PULSAR_NAMESPACE="{{ .Values.coordinator.idvCoordinatorPulsarNamespace }}"
IDV_COORDINATOR_SERVER_ACTION_TOPIC="{{ .Values.coordinator.idvCoordinatorPulsarActionTopic }}"
IDV_COORDINATOR_SERVER_ACTION_SUBSCRIPTION="{{ .Values.coordinator.idvCoordinatorPulsarActionSubscription }}"
IDV_COORDINATOR_SERVER_ACTION_RESULTS_BUCKET="{{ .Values.coordinator.idvCoordinatorPulsarActionResultsBucket }}"

# Minio/S3
IDV_COORDINATOR_STORAGE_ENDPOINT="{{ template "idv.coordinator.storage_endpoint" . }}"
IDV_COORDINATOR_STORAGE_REGION="{{ .Values.coordinator.idvCoordinatorStorageRegion }}"
IDV_COORDINATOR_STORAGE_ACCESS_KEY="{{ .Values.coordinator.idvCoordinatorStorageAccessKey }}"
IDV_COORDINATOR_STORAGE_SECRET_KEY="{{ .Values.coordinator.idvCoordinatorStorageSecretKey }}"

# FaceAPI
IDV_COORDINATOR_FACEAPI_URL="{{ template "idv.coordinator.faceapi.url" . }}"

# Third Party FP service
IDV_COORDINATOR_TODAS_FINGERPRINT_SERVICE_URL="{{ .Values.coordinator.idvCoordinatorFingerprintService }}"
{{- end }}
