# Face-API Helm Chart

* Fast and accurate data extraction from identity documents. On-premise and cloud integration

## Get Repo Info

```console
helm repo add regulaforensics https://regulaforensics.github.io/helm-test
helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Prerequisites

- At least 2 GB of RAM available on your cluster per pod's worker
- Helm 3
- PV provisioner support in the underlying infrastructure (essential for storing logs)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release regulaforensics/face-api
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


## Configuration

| Parameter                                 | Description                                   | Default                                                   |
|-------------------------------------------|-----------------------------------------------|-----------------------------------------------------------|
| `replicas`                                | Number of nodes                               | `1`                                                       |
| `image.repository`                        | Image repository                              | `regulaforensics/face-api`                                |
| `image.tag`                               | Overrides the Face-API image tag whose defaultis the chart appVersion    | ``                             |
| `image.pullPolicy`                        | Image pull policy                             | `IfNotPresent`                                            |
| `imagePullSecrets`                        | Image pull secrets                            | `[]`                                                      |
| `resources`                               | CPU/Memory resource requests/limits           | `{}`                                                      |
| `externalPostgreSQL`                      | Connection String to the Postgres database    | `none` Option 1. Required by Identification module        |
| `externalPostgreSQLSecret`                | Secret name of the Connection String          | `none` Option 2. Required by Identification module. ex. `postgresql://user:pass@host:5432/database`   |
| `postgresql.enabled`                      | Whether to enable postgresql subchart         | `false` Option 3. Required by Identification module       |
| `postgresql.postgresqlUsername`           | postgresql Username                           | `regula`                                                  |
| `postgresql.postgresqlPassword`           | postgresql Password                           | `Regulapasswd#1`                                          |
| `postgresql.postgresqlDatabase`           | postgresql Database                           | `regula_db`                                               |
| `env`                                     | Additional environment variables              | `[]`                                                      |
| `extraVolumes`                            | Additional Face-API volumes                   | `[]`                                                      |
| `extraVolumeMounts`                       | Additional Face-API volume mounts             | `[]`                                                      |
| `service.type`                            | Kubernetes service type                       | `ClusterIP`                                               |
| `service.port`                            | Kubernetes port where service is exposed      | `80`                                                      |
| `service.annotations`                     | Service annotations (can be templated)        | `{}`                                                      |
| `service.loadBalancerIP`                  | IP address to assign to load balancer (if supported) | `nil`                                              |
| `service.loadBalancerSourceRanges`        | List of IP CIDRs allowed access to lb (if supported) | `[]`                                               |
| `ingress.enabled`                         | Enables Ingress                               | `false`                                                   |
| `ingress.className`                       | Ingress Class Name                            | `false`                                                   |
| `ingress.annotations`                     | Ingress annotations                           | `{}`                                                      |
| `ingress.labels`                          | Ingress labels                                | `{}`                                                      |
| `ingress.hosts`                           | Ingress hostnames                             | `[]`                                                      |
| `livenessProbe.enabled`                   | Enable livenessProbe                          | `true`                                                    |
| `readinessProbe.enabled`                  | Enable readinessProbe                         | `true`                                                    |
| `autoscaling.enabled`                     | Enable autoscaling                            | `false`                                                   |
