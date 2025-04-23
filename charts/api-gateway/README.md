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
helm install my-release regulaforensics/api-gateway
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


## Configuration
