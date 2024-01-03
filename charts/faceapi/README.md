# Face-API Helm Chart

* Fast and accurate data extraction from identity documents. On-premise and cloud integration

## Get Repo Info

```console
helm repo add regulaforensics https://regulaforensics.github.io/helm-test
helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Prerequisites

- At least 3 GB of RAM available on your cluster per pod's worker
- Helm 3
- PV provisioner support in the underlying infrastructure (essential for storing logs)

## Installing the Chart

### Licensing

To install the chart you need to obtain the `regula.license` file e.g. at the [Client Portal](https://client.regulaforensics.com/) and then create kubernetes secret form that license file:

```console
kubectl create secret generic faceapi-license --from-file=regula.license
```

### Detect/Match

To install the chart with the release name `my-release` and Detect/Match capabilities (default):

```console
helm install my-release regulaforensics/faceapi --set licenseSecretName=faceapi-license
```

### Liveness

To install the chart with the release name `my-release` and Liveness capabilities:

```console
helm install my-release regulaforensics/faceapi --set licenseSecretName=faceapi-license --set liveness.enabled=true --set postgresql.enabled=true
```

### Search

To install the chart with the release name `my-release` and Search capabilities:

```console
helm install my-release regulaforensics/faceapi --set licenseSecretName=faceapi-license --set search.enabled=true --set milvus.enabled=true --set postgresql.enabled=true
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


## Common parameters

| Parameter                                 | Description                                                                                   | Default                             |
|-------------------------------------------|-----------------------------------------------------------------------------------------------|-------------------------------------|
| `replicas`                                | Number of nodes                                                                               | `1`                                 |
| `version`                                 | Face-API engine version. Possible values: `cpu`, `gpu`                                        | `cpu`                               |
| `image.repository`                        | Image repository                                                                              | `regulaforensics/face-api`          |
| `image.tag`                               | Overrides the Face-API image tag whose defaultis the chart appVersion                         | `""`                                |
| `image.pullPolicy`                        | Image pull policy                                                                             | `IfNotPresent`                      |
| `imagePullSecrets`                        | Image pull secrets                                                                            | `[]`                                |
| `nameOverride`                            | String to partially override common.names.fullname template (will maintain the release name)  | `""`                                |
| `fullnameOverride`                        | String to fully override common.names.fullname templated                                      | `""`                                |
| `resources`                               | CPU/Memory resource requests/limits                                                           | `{}`                                |
| `securityContext`                         | Enable security context                                                                       | `{}`                                |
| `podSecurityContext`                      | Enable pod security context                                                                   | `{}`                                |
| `podSecurityContext.fsGroup`              | Group ID for the pod                                                                          | `0`                                 |
| `podAnnotations`                          | Map of annotations to add to the pods                                                         | `{}`                                |
| `priorityClassName`                       | Priority Class to use for each pod                                                            | `""`                                |
| `nodeSelector`                            | Node labels for pods assignment                                                               | `{}`                                |
| `affinity`                                | Affinity for pods assignment                                                                  | `{}`                                |
| `tolerations`                             | Tolerations for pods assignment                                                               | `[]`                                |
| `topologySpreadConstraints`               | Topology Spread Constraints for pod assignment                                                | `[]`                                |
| `podDisruptionBudget.enabled`             | Enable Pod Disruption Budgets                                                                 | `false`                             |
| `podDisruptionBudget.config`              | Configure Pod Disruption Budgets                                                              | `maxUnavailable: 1`                 |
| `env`                                     | Additional environment variables                                                              | `[]`                                |
| `extraVolumes`                            | Additional Face-API volumes                                                                   | `[]`                                |
| `extraVolumeMounts`                       | Additional Face-API volume mounts                                                             | `[]`                                |
| `service.type`                            | Kubernetes service type                                                                       | `ClusterIP`                         |
| `service.port`                            | Kubernetes port where service is exposed                                                      | `80`                                |
| `service.annotations`                     | Service annotations (can be templated)                                                        | `{}`                                |
| `service.loadBalancerIP`                  | IP address to assign to load balancer (if supported)                                          | `nil`                               |
| `service.loadBalancerSourceRanges`        | List of IP CIDRs allowed access to lb (if supported)                                          | `[]`                                |
| `ingress.enabled`                         | Enables Ingress                                                                               | `false`                             |
| `ingress.className`                       | Ingress Class Name                                                                            | `false`                             |
| `ingress.annotations`                     | Ingress annotations                                                                           | `{}`                                |
| `ingress.hosts`                           | Ingress hostnames                                                                             | `[]`                                |
| `ingress.tls`                             | Ingress TLS configuration                                                                     | `[]`                                |
| `serviceAccount.create`                   | Whether to create Service Account                                                             | `false`                             |
| `serviceAccount.name`                     | Service Account name                                                                          | `""`                                |
| `serviceAccount.annotations`              | Service Account annotations                                                                   | `{}`                                |
| `metrics.enabled`                         | Whether to enable prometheus metrics endpoint                                                 | `false`                             |
| `metrics.serviceMonitor.enabled`          | Whether to create ServiceMonitor for Prometheus operator                                      | `false`                             |
| `metrics.serviceMonitor.namespace`        | ServiceMonitor namespace                                                                      | `""`                                |
| `metrics.serviceMonitor.interval`         | ServiceMonitor interval                                                                       | `30s`                               |
| `metrics.serviceMonitor.scrapeTimeout`    | ServiceMonitor scrape timeout                                                                 | `10s`                               |
| `metrics.serviceMonitor.additionalLabels` | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus         | `{}`                                |
| `livenessProbe.enabled`                   | Enable livenessProbe                                                                          | `true`                              |
| `readinessProbe.enabled`                  | Enable readinessProbe                                                                         | `true`                              |
| `autoscaling.enabled`                     | Enable autoscaling                                                                            | `false`                             |


## Application parameters

| Parameter                                 | Description                                                                       | Default                                                   |
|-------------------------------------------|-----------------------------------------------------------------------------------|-----------------------------------------------------------|
| `licenseSecretName`                       | The name of an existing secret containing the regula.license file                 | `""`                                                      |
| `sdk.compare.limitPerImageTypes`          | Limit per Image Type                                                              | `2`                                                       |
| `sdk.logging.level`                       | Specify application logs level. Possible values: `ERROR`, `WARN`, `INFO`, `DEBUG` | `INFO`                                                    |
| `sdk.detect`                              | Configuration of SDK `detect` capabilities                                        | `[]`                                                      |
| `sdk.liveness`                            | Configuration of SDK `liveness` capabilities                                      | `[]`                                                      |
| `webServer.port`                          | Port server binding                                                               | `41101`                                                   |
| `webServer.workers`                       | Number of workers per pod                                                         | `1`                                                       |
| `webServer.timeout`                       | Number of seconds for the worker to process the request                           | `30`                                                      |
| `webServer.demoApp.enabled`               | Serve a demo web app                                                              | `true`                                                    |
| `webServer.cors.origins`                  | Origin, allowed to use API                                                        | `*`                                                       |
| `webServer.cors.headers`                  | Headers, allowed to read from the API                                             | `*`                                                       |
| `webServer.cors.methods`                  | Methods, allowed to invoke on the API                                             | `"POST,PUT,GET,DELETE,PATCH,HEAD,OPTIONS`                 |
| `webServer.logging.level`                 | Specify application logs level. Possible values: `ERROR`, `WARN`, `INFO`, `DEBUG` | `INFO`                                                    |
| `webServer.logging.formatter`             | Specify application logs format. Possible values: `text`, `json`                  | `text`                                                    |
| `webServer.logging.access.console`        | Whether to print access logs to a console                                         | `true`                                                    |
| `webServer.logging.access.path`           | Access logs file path                                                             | `logs/access/facesdk-reader-access.log`                   |
| `webServer.logging.app.console`           | Whether to print application logs to a console                                    | `true`                                                    |
| `webServer.logging.app.path`              | Application logs file path                                                        | `logs/app/facesdk-reader-app.log`                         |
| `ssl.enabled`                             | Whether to enable ssl mode                                                        | `false`                                                   |
| `ssl.certificatesSecretName`              | The name of an existing secret containing the cert/key files reuired for https    | `""`                                                      |
| `ssl.tlsVersion`                          | Specifies the version of the TLS protocol. Possible values: `1.1`, `1.2`, `1.3`   | `1.2`                                                     |
| `storage.type`                            | Global storage type. Possible values: `fs`, `s3`, `gcs`, `az`                     | `fs`                                                      |
| `storage.s3.accessKey`                    | S3 Access Key                                                                     | `""`                                                      |
| `storage.s3.accessSecret`                 | S3 Secret Access Key                                                              | `""`                                                      |
| `storage.s3.region`                       | S3 region                                                                         | `"eu-central-1"`                                          |
| `storage.s3.secure`                       | Secure connection                                                                 | `"true"`                                                  |
| `storage.s3.endpoint`                     | Enpoint to the S3 compatible storage                                              | `""`                                                      |
| `storage.s3.awsCredentialsSecretName`     | Secret name containing AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY credentials        | `""`                                                      |
| `storage.gcs.gcsKeyJsonSecretName`        | Secret name containing Google Service Account key (json file)                     | `""`                                                      |
| `storage.az.connectionString`             | Azure Storage Account connection string                                           | `""`                                                      |
| `storage.az.connectionStringSecretName`   | Secret name containing Azure Storage Account connection string                    | `""`                                                      |
| `database.connectionString`               | Database connection string                                                        | `""`                                                      |
| `database.connectionStringSecretName`     | Secret name containing Database connection string                                 | `""`                                                      |


## Detect/Match parameters

| Parameter                                           | Description                                                                                         | Default                         		|
|-----------------------------------------------------|-----------------------------------------------------------------------------------------------------|---------------------------------------|
| `detectMatch.enabled`                               | Whether to enable Detect/Match mode (default)                                                       | Always `true`                   		|
| `detectMatch.results.location.bucket`               | The Detect/Match result logs bucket name in case of `s3/gcs` storage type                           | `""`                            		|
| `detectMatch.results.location.container`            | The Detect/Match result logs storage container name in case of `az` storage type                    | `""`                            		|
| `detectMatch.results.location.folder`               | The Detect/Match result logs folder name in case of `fs` storage type                               | `"/app/faceapi-detect-match/results"` |
| `detectMatch.results.location.prefix`               | The Detect/Match result logs prefix path in the `bucket/container`                           		| `"results"`                     		|
| `detectMatch.results.persistence.enabled`           | Whether to enable Detect/Match result logs persistence (Applicable only for the `fs` storage type)  | `false`                         		|
| `detectMatch.results.persistence.accessMode`        | The Detect/Match logs data Persistence access modes                                                 | `ReadWriteMany`                 		|
| `detectMatch.results.persistence.size`              | The size of Detect/Match logs data Persistent Volume Storage Class                                  | `10Gi`                          		|
| `detectMatch.results.persistence.storageClassName`  | The Detect/Match logs data Persistent Volume Storage Class                                          | `""`                            		|
| `detectMatch.results.persistence.existingClaim`     | Name of the existing Persistent Volume Claim                                                        | `""`                            		|


## Liveness parameters

| Parameter                                           | Description                                                                                 | Default                         		|
|-----------------------------------------------------|---------------------------------------------------------------------------------------------|---------------------------------------|
| `liveness.enabled`                                  | Whether to enable Liveness mode                                                             | `false`                         		|
| `liveness.ecdhSchema`                               | ECDH schema to use                                                                          | `default`                       		|
| `liveness.hideMetadata`                             | Whether to hide processing data's metadata                                                  | `false`                         		|
| `liveness.protectPersonalInfo`                      | Whether to hide Personal information metadata                                               | `false`                         		|
| `detectMatch.sessions.location.bucket`              | The Liveness sessions bucket name in case of `s3/gcs` storage type                          | `""`                            		|
| `detectMatch.sessions.location.container`           | The Liveness sessions storage container name in case of `az` storage type                   | `""`                            		|
| `detectMatch.sessions.location.folder`              | The Liveness sessions folder name in case of `fs` storage type                              | `"/app/faceapi-liveness/sessions"`	|
| `detectMatch.sessions.location.prefix`              | The Liveness sessions prefix path in the `bucket/container`                          		| `"sessions"`                    		|
| `detectMatch.sessions.persistence.enabled`          | Whether to enable Liveness sessions persistence (Applicable only for the `fs` storage type) | `false`                         		|
| `detectMatch.sessions.persistence.accessMode`       | The Liveness sessions data Persistence access modes                                         | `ReadWriteMany`                 		|
| `detectMatch.sessions.persistence.size`             | The size of Liveness sessions data Persistent Volume Storage Class                          | `10Gi`                          		|
| `detectMatch.sessions.persistence.storageClassName` | The Liveness sessions data Persistent Volume Storage Class                                  | `""`                            		|
| `detectMatch.sessions.persistence.existingClaim`    | Name of the existing Persistent Volume Claim                                                | `""`                            		|


## Search parameters

| Parameter                                           | Description                                                                              | Default                    		|
|-----------------------------------------------------|------------------------------------------------------------------------------------------|----------------------------------|
| `search.enabled`                                    | Whether to enable Identification 1:N (aka Search) mode                                   | `false`                    		|
| `search.persons.location.bucket`                    | The Search persons bucket name in case of `s3/gcs` storage type                          | `""`                       		|
| `search.persons.location.container`                 | The Search persons storage container name in case of `az` storage type                   | `""`                       		|
| `search.persons.location.folder`                    | The Search persons folder name in case of `fs` storage type                              | `"/app/faceapi-search/persons"`	|
| `search.persons.location.prefix`                    | The Search persons prefix path in the `bucket/container`                          		 | `"persons"`                		|
| `search.persons.persistence.enabled`                | Whether to enable Search persons persistence (Applicable only for the `fs` storage type) | `false`                    		|
| `search.persons.persistence.accessMode`             | The Search persons data Persistence access modes                                         | `ReadWriteMany`            		|
| `search.persons.persistence.size`                   | The size of Search persons data Persistent Volume Storage Class                          | `10Gi`                     		|
| `search.persons.persistence.storageClassName`       | The Search persons data Persistent Volume Storage Class                                  | `""`                       		|
| `search.persons.persistence.existingClaim`          | Name of the existing Persistent Volume Claim                                             | `""`                       		|
| `search.threshold`                                  | Search similarity threshold                                                              | `1.0`                      		|
| `search.vectorDatabase.type`                        | Search VectorDatabase type                                                               | `milvus`                   		|
| `search.vectorDatabase.milvus.user`                 | Milvus user                                                                              | `""`                       		|
| `search.vectorDatabase.milvus.password`             | Milvus password                                                                          | `""`                       		|
| `search.vectorDatabase.milvus.token`                | Milvus token                                                                             | `""`                       		|
| `search.vectorDatabase.milvus.endpoint`             | Milvus endpoint                                                                          | `"http://localhost:19530"` 		|
| `search.vectorDatabase.milvus.consistency`          | Milvus [consistency level](https://milvus.io/docs/consistency.md)                        | `"Bounded"`                		|
| `search.vectorDatabase.milvus.reload`               | Milvus reload                                                                            | `false`                    		|
| `search.vectorDatabase.milvus.index.type`           | Milvus [index type](https://milvus.io/docs/index.md)                                     | `IVF_FLAT`                 		|
| `search.vectorDatabase.milvus.index.params.nlist`   | Milvus nlist cluster units                                                               | `128`                      		|
| `search.vectorDatabase.milvus.search.type`          | Milvus search type. [Similarity metrics](https://milvus.io/docs/metric.md)               | `"L2"`                     		|
| `search.vectorDatabase.milvus.search.params.nprobe` | Milvus search parameters. nprobe. The number of cluster units to search                  | `5`                        		|


> [!NOTE]
> The subcharts are used for the demonstration and Dev/Test purposes related to the `liveness` and/or the `search` capabilities.
> We strongly recommend to deploy separate installations of the VectorDatabase (search) and DB (liveness/search) in Production

> [!TIP]
> Configuration for milvus subchart
> For the advanced Milvus configuration please referer to the official documentation
> ref: https://github.com/zilliztech/milvus-helm/tree/master/charts/milvus

> [!TIP]
> Configuration for postgresql subchart
>For the advanced PostgreSQL configuration please referer to the official documentation
> ref: https://github.com/bitnami/charts/tree/main/bitnami/postgresql

## Subchart parameters

| Parameter                   | Description                             | Default                                                       |
|-----------------------------|-----------------------------------------|---------------------------------------------------------------|
| `milvus.enabled`            | Whether to enable Milvus subchart       | `false` Required by Search mode                               |
| `postgresql.enabled`        | Whether to enable postgresql subchart   | `false` Required by Liveness/Search mode                      |
| `postgresql.auth.username`  | postgresql Username                     | `regula`                                                      |
| `postgresql.auth.password`  | postgresql Password                     | `Regulapasswd#1`                                              |
| `postgresql.auth.database`  | postgresql Database                     | `regula_db`                                                   |
