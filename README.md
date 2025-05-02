# Regula Kubernetes Helm Charts

## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```
helm repo add regula-test https://raw.githubusercontent.com/regulaforensics/helm-test/refs/heads/helm-chart-releases/helm-releases/
helm repo update
```

You can then run `helm search repo regula-test` to see the charts.

- [Docreader](https://github.com/regulaforensics/helm-test/tree/main/charts/docreader)
- [FaceAPI](https://github.com/regulaforensics/helm-test/tree/main/charts/faceapi)
- [afis-api](https://github.com/regulaforensics/helm-test/tree/main/charts/afis-api)
- [api-gateway](https://github.com/regulaforensics/helm-test/tree/main/charts/api-gateway)

<!-- Keep full URL links to repo files because this README syncs from main to gh-pages.  -->
Chart documentation is available at [docs.regulaforensics.com](https://docs.regulaforensics.com).
