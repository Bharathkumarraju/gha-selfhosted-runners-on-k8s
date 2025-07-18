# gha-selfhosted-runners-on-k8s
github self hosted runners on kubernetes(AWS EKS Cluster)

## terraform remote state
create s3 as tf remote state [tf-remote-state-pipeline](https://github.com/Bharathkumarraju/gha-selfhosted-runners-on-k8s/actions/runs/16358410949)

## create vpc 
deploy aws vpc through terraform [aws-vpc-pipeline](https://github.com/Bharathkumarraju/gha-selfhosted-runners-on-k8s/actions/runs/16360740048)

## EKS cluster 
deploy an aws eks cluster [aws-eks-pipeline](https://github.com/Bharathkumarraju/gha-selfhosted-runners-on-k8s/actions/runs/16362142754/job/46232034246#step:8:353)


## GHA Runner 
Deploy GHA Runner helm charts [gha-runner-helmchart](https://github.com/Bharathkumarraju/gha-selfhosted-runners-on-k8s/actions/runs/16362454846/job/46232899389#step:8:35)

### gha-runner-scale-set-controller OCI(Open Container Initiative)helm-chart
```shell
bharathkumardasaraju@external$ helm pull  oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller --vers
ion 0.12.1
Pulled: ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller:0.12.1
Digest: sha256:621fb48c3fbf79cb817f03da35d19a26c35ad34de13e8cfa9816f9e462d2ce80
bharathkumardasaraju@external$
```
```shell
bharathkumardasaraju@external$ helm show values oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller --version 0.12.1
Pulled: ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller:0.12.1
Digest: sha256:621fb48c3fbf79cb817f03da35d19a26c35ad34de13e8cfa9816f9e462d2ce80
# Default values for gha-runner-scale-set-controller.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.
labels: {}

# leaderElection will be enabled when replicaCount>1,
# So, only one replica will in charge of reconciliation at a given time
# leaderElectionId will be set to {{ define gha-runner-scale-set-controller.fullname }}.
replicaCount: 1

image:
  repository: "ghcr.io/actions/gha-runner-scale-set-controller"
  pullPolicy: IfNotPresent
  # Overrides the image tag whose default is the chart appVersion.
  tag: ""

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

env:
## Define environment variables for the controller pod
#  - name: "ENV_VAR_NAME_1"
#    value: "ENV_VAR_VALUE_1"
#  - name: "ENV_VAR_NAME_2"
#    valueFrom:
#      secretKeyRef:
#        key: ENV_VAR_NAME_2
#        name: secret-name
#        optional: true

serviceAccount:
  # Specifies whether a service account should be created for running the controller pod
  create: true
  # Annotations to add to the service account
  annotations: {}
  # The name of the service account to use.
  # If not set and create is true, a name is generated using the fullname template
  # You can not use the default service account for this.
  name: ""

podAnnotations: {}

podLabels: {}

podSecurityContext: {}
# fsGroup: 2000

securityContext: {}
# capabilities:
#   drop:
#   - ALL
# readOnlyRootFilesystem: true
# runAsNonRoot: true
# runAsUser: 1000

resources: {}
## We usually recommend not to specify default resources and to leave this as a conscious
## choice for the user. This also increases chances charts run on environments with little
## resources, such as Minikube. If you do want to specify resources, uncomment the following
## lines, adjust them as necessary, and remove the curly braces after 'resources:'.
# limits:
#   cpu: 100m
#   memory: 128Mi
# requests:
#   cpu: 100m
#   memory: 128Mi

nodeSelector: {}

tolerations: []

affinity: {}

topologySpreadConstraints: []

# Mount volumes in the container.
volumes: []
volumeMounts: []

# Leverage a PriorityClass to ensure your pods survive resource shortages
# ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/
# PriorityClass: system-cluster-critical
priorityClassName: ""

## If `metrics:` object is not provided, or commented out, the following flags
## will be applied the controller-manager and listener pods with empty values:
## `--metrics-addr`, `--listener-metrics-addr`, `--listener-metrics-endpoint`.
## This will disable metrics.
##
## To enable metrics, uncomment the following lines.
# metrics:
#   controllerManagerAddr: ":8080"
#   listenerAddr: ":8080"
#   listenerEndpoint: "/metrics"

flags:
  ## Log level can be set here with one of the following values: "debug", "info", "warn", "error".
  ## Defaults to "debug".
  logLevel: "debug"
  ## Log format can be set with one of the following values: "text", "json"
  ## Defaults to "text"
  logFormat: "text"

  ## Restricts the controller to only watch resources in the desired namespace.
  ## Defaults to watch all namespaces when unset.
  # watchSingleNamespace: ""

  ## The maximum number of concurrent reconciles which can be run by the EphemeralRunner controller.
  # Increase this value to improve the throughput of the controller.
  # It may also increase the load on the API server and the external service (e.g. GitHub API).
  runnerMaxConcurrentReconciles: 2

  ## Defines how the controller should handle upgrades while having running jobs.
  ##
  ## The strategies available are:
  ## - "immediate": (default) The controller will immediately apply the change causing the
  ##   recreation of the listener and ephemeral runner set. This can lead to an
  ##   overprovisioning of runners, if there are pending / running jobs. This should not
  ##   be a problem at a small scale, but it could lead to a significant increase of
  ##   resources if you have a lot of jobs running concurrently.
  ##
  ## - "eventual": The controller will remove the listener and ephemeral runner set
  ##   immediately, but will not recreate them (to apply changes) until all
  ##   pending / running jobs have completed.
  ##   This can lead to a longer time to apply the change but it will ensure
  ##   that you don't have any overprovisioning of runners.
  updateStrategy: "immediate"

  ## Defines a list of prefixes that should not be propagated to internal resources.
  ## This is useful when you have labels that are used for internal purposes and should not be propagated to internal resources.
  ## See https://github.com/actions/actions-runner-controller/issues/3533 for more information.
  ##
  ## By default, all labels are propagated to internal resources
  ## Labels that match prefix specified in the list are excluded from propagation.
  # excludeLabelPropagationPrefixes:
  #   - "argocd.argoproj.io/instance"

# Overrides the default `.Release.Namespace` for all resources in this chart.
namespaceOverride: ""

## Defines the K8s client rate limiter parameters.
  # k8sClientRateLimiterQPS: 20
  # k8sClientRateLimiterBurst: 30

bharathkumardasaraju@external$

```
```shell
bharathkumardasaraju@external$ helm show chart oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller --version 0.12.1
Pulled: ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller:0.12.1
Digest: sha256:621fb48c3fbf79cb817f03da35d19a26c35ad34de13e8cfa9816f9e462d2ce80
apiVersion: v2
appVersion: 0.12.1
description: A Helm chart for install actions-runner-controller CRD
home: https://github.com/actions/actions-runner-controller
maintainers:
- name: actions
  url: https://github.com/actions
name: gha-runner-scale-set-controller
sources:
- https://github.com/actions/actions-runner-controller
type: application
version: 0.12.1

bharathkumardasaraju@external$
```


### gha-runner-scale-set OCI(Open Container Initiative)helm-chart

```shell
bharathkumardasaraju@external$ helm pull  oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set --version 0.12.1
Pulled: ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set:0.12.1
Digest: sha256:97125addd369e3fd2838ff279fc685a83d7cfe7e29d56af435c7733633026d53
bharathkumardasaraju@external$

```

```shell
bharathkumardasaraju@external$ helm show values oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set --version 0.12.1
Pulled: ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set:0.12.1
Digest: sha256:97125addd369e3fd2838ff279fc685a83d7cfe7e29d56af435c7733633026d53
## githubConfigUrl is the GitHub url for where you want to configure runners
## ex: https://github.com/myorg/myrepo or https://github.com/myorg
githubConfigUrl: ""

## githubConfigSecret is the k8s secret information to use when authenticating via the GitHub API.
## You can choose to supply:
##   A) a PAT token,
##   B) a GitHub App, or
##   C) a pre-defined secret.
## The syntax for each of these variations is documented below.
## (Variation A) When using a PAT token, the syntax is as follows:
githubConfigSecret:
  # Example:
  # github_token: "ghp_sampleSampleSampleSampleSampleSample"
  github_token: ""
#
## (Variation B) When using a GitHub App, the syntax is as follows:
# githubConfigSecret:
#   # NOTE: IDs MUST be strings, use quotes
#   # The github_app_id can be an app_id or the client_id
#   github_app_id: ""
#   github_app_installation_id: ""
#   github_app_private_key: |
#      private key line 1
#      private key line 2
#      .
#      .
#      .
#      private key line N
#
## (Variation C) When using a pre-defined secret.
## The secret can be pulled either directly from Kubernetes, or from the vault, depending on configuration.
## Kubernetes secret in the same namespace that the gha-runner-scale-set is going to deploy.
## On the other hand, if the vault is configured, secret name will be used to fetch the app configuration.
## The syntax is as follows:
# githubConfigSecret: pre-defined-secret
## Notes on using pre-defined Kubernetes secrets:
##   You need to make sure your predefined secret has all the required secret data set properly.
##   For a pre-defined secret using GitHub PAT, the secret needs to be created like this:
##   > kubectl create secret generic pre-defined-secret --namespace=my_namespace --from-literal=github_token='ghp_your_pat'
##   For a pre-defined secret using GitHub App, the secret needs to be created like this:
##   > kubectl create secret generic pre-defined-secret --namespace=my_namespace --from-literal=github_app_id=123456 --from-literal=github_app_installation_id=654321 --from-literal=github_app_private_key='-----BEGIN CERTIFICATE-----*******'

## proxy can be used to define proxy settings that will be used by the
## controller, the listener and the runner of this scale set.
#
# proxy:
#   http:
#     url: http://proxy.com:1234
#     credentialSecretRef: proxy-auth # a secret with `username` and `password` keys
#   https:
#     url: http://proxy.com:1234
#     credentialSecretRef: proxy-auth # a secret with `username` and `password` keys
#   noProxy:
#     - example.com
#     - example.org

## maxRunners is the max number of runners the autoscaling runner set will scale up to.
# maxRunners: 5

## minRunners is the min number of idle runners. The target number of runners created will be
## calculated as a sum of minRunners and the number of jobs assigned to the scale set.
# minRunners: 0

# runnerGroup: "default"

## name of the runner scale set to create.  Defaults to the helm release name
# runnerScaleSetName: ""

## A self-signed CA certificate for communication with the GitHub server can be
## provided using a config map key selector. If `runnerMountPath` is set, for
## each runner pod ARC will:
## - create a `github-server-tls-cert` volume containing the certificate
##   specified in `certificateFrom`
## - mount that volume on path `runnerMountPath`/{certificate name}
## - set NODE_EXTRA_CA_CERTS environment variable to that same path
## - set RUNNER_UPDATE_CA_CERTS environment variable to "1" (as of version
##   2.303.0 this will instruct the runner to reload certificates on the host)
##
## If any of the above had already been set by the user in the runner pod
## template, ARC will observe those and not overwrite them.
## Example configuration:
#
# githubServerTLS:
#   certificateFrom:
#     configMapKeyRef:
#       name: config-map-name
#       key: ca.crt
#   runnerMountPath: /usr/local/share/ca-certificates/

# keyVault:
  # Available values: "azure_key_vault"
  # type: ""
  # Configuration related to azure key vault
  # azure_key_vault:
  #   url: ""
  #   client_id: ""
  #   tenant_id: ""
  #   certificate_path: ""
    # proxy:
    #   http:
    #     url: http://proxy.com:1234
    #     credentialSecretRef: proxy-auth # a secret with `username` and `password` keys
    #   https:
    #     url: http://proxy.com:1234
    #     credentialSecretRef: proxy-auth # a secret with `username` and `password` keys
    #   noProxy:
    #     - example.com
    #     - example.org

## Container mode is an object that provides out-of-box configuration
## for dind and kubernetes mode. Template will be modified as documented under the
## template object.
##
## If any customization is required for dind or kubernetes mode, containerMode should remain
## empty, and configuration should be applied to the template.
# containerMode:
#   type: "dind"  ## type can be set to dind or kubernetes
#   ## the following is required when containerMode.type=kubernetes
#   kubernetesModeWorkVolumeClaim:
#     accessModes: ["ReadWriteOnce"]
#     # For local testing, use https://github.com/openebs/dynamic-localpv-provisioner/blob/develop/docs/quickstart.md to provide dynamic provision volume with storageClassName: openebs-hostpath
#     storageClassName: "dynamic-blob-storage"
#     resources:
#       requests:
#         storage: 1Gi
#

## listenerTemplate is the PodSpec for each listener Pod
## For reference: https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#PodSpec
# listenerTemplate:
#   spec:
#     containers:
#     # Use this section to append additional configuration to the listener container.
#     # If you change the name of the container, the configuration will not be applied to the listener,
#     # and it will be treated as a side-car container.
#     - name: listener
#       securityContext:
#         runAsUser: 1000
#     # Use this section to add the configuration of a side-car container.
#     # Comment it out or remove it if you don't need it.
#     # Spec for this container will be applied as is without any modifications.
#     - name: side-car
#       image: example-sidecar

## listenerMetrics are configurable metrics applied to the listener.
## In order to avoid helm merging these fields, we left the metrics commented out.
## When configuring metrics, please uncomment the listenerMetrics object below.
## You can modify the configuration to remove the label or specify custom buckets for histogram.
##
## If the buckets field is not specified, the default buckets will be applied. Default buckets are
## provided here for documentation purposes
# listenerMetrics:
#   counters:
#     gha_started_jobs_total:
#       labels:
#         ["repository", "organization", "enterprise", "job_name", "event_name", "job_workflow_ref"]
#     gha_completed_jobs_total:
#       labels:
#         [
#           "repository",
#           "organization",
#           "enterprise",
#           "job_name",
#           "event_name",
#           "job_result",
#           "job_workflow_ref",
#         ]
#   gauges:
#     gha_assigned_jobs:
#       labels: ["name", "namespace", "repository", "organization", "enterprise"]
#     gha_running_jobs:
#       labels: ["name", "namespace", "repository", "organization", "enterprise"]
#     gha_registered_runners:
#       labels: ["name", "namespace", "repository", "organization", "enterprise"]
#     gha_busy_runners:
#       labels: ["name", "namespace", "repository", "organization", "enterprise"]
#     gha_min_runners:
#       labels: ["name", "namespace", "repository", "organization", "enterprise"]
#     gha_max_runners:
#       labels: ["name", "namespace", "repository", "organization", "enterprise"]
#     gha_desired_runners:
#       labels: ["name", "namespace", "repository", "organization", "enterprise"]
#     gha_idle_runners:
#       labels: ["name", "namespace", "repository", "organization", "enterprise"]
#   histograms:
#     gha_job_startup_duration_seconds:
#       labels:
#         ["repository", "organization", "enterprise", "job_name", "event_name","job_workflow_ref"]
#       buckets:
#         [
#           0.01,
#           0.05,
#           0.1,
#           0.5,
#           1.0,
#           2.0,
#           3.0,
#           4.0,
#           5.0,
#           6.0,
#           7.0,
#           8.0,
#           9.0,
#           10.0,
#           12.0,
#           15.0,
#           18.0,
#           20.0,
#           25.0,
#           30.0,
#           40.0,
#           50.0,
#           60.0,
#           70.0,
#           80.0,
#           90.0,
#           100.0,
#           110.0,
#           120.0,
#           150.0,
#           180.0,
#           210.0,
#           240.0,
#           300.0,
#           360.0,
#           420.0,
#           480.0,
#           540.0,
#           600.0,
#           900.0,
#           1200.0,
#           1800.0,
#           2400.0,
#           3000.0,
#           3600.0,
#         ]
#     gha_job_execution_duration_seconds:
#       labels:
#         [
#           "repository",
#           "organization",
#           "enterprise",
#           "job_name",
#           "event_name",
#           "job_result",
#           "job_workflow_ref"
#         ]
#       buckets:
#         [
#           0.01,
#           0.05,
#           0.1,
#           0.5,
#           1.0,
#           2.0,
#           3.0,
#           4.0,
#           5.0,
#           6.0,
#           7.0,
#           8.0,
#           9.0,
#           10.0,
#           12.0,
#           15.0,
#           18.0,
#           20.0,
#           25.0,
#           30.0,
#           40.0,
#           50.0,
#           60.0,
#           70.0,
#           80.0,
#           90.0,
#           100.0,
#           110.0,
#           120.0,
#           150.0,
#           180.0,
#           210.0,
#           240.0,
#           300.0,
#           360.0,
#           420.0,
#           480.0,
#           540.0,
#           600.0,
#           900.0,
#           1200.0,
#           1800.0,
#           2400.0,
#           3000.0,
#           3600.0,
#         ]

## template is the PodSpec for each runner Pod
## For reference: https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#PodSpec
template:
  ## template.spec will be modified if you change the container mode
  ## with containerMode.type=dind, we will populate the template.spec with following pod spec
  ## template:
  ##   spec:
  ##     initContainers:
  ##     - name: init-dind-externals
  ##       image: ghcr.io/actions/actions-runner:latest
  ##       command: ["cp", "-r", "/home/runner/externals/.", "/home/runner/tmpDir/"]
  ##       volumeMounts:
  ##         - name: dind-externals
  ##           mountPath: /home/runner/tmpDir
  ##     - name: dind
  ##       image: docker:dind
  ##       args:
  ##         - dockerd
  ##         - --host=unix:///var/run/docker.sock
  ##         - --group=$(DOCKER_GROUP_GID)
  ##       env:
  ##         - name: DOCKER_GROUP_GID
  ##           value: "123"
  ##       securityContext:
  ##         privileged: true
  ##       restartPolicy: Always
  ##       startupProbe:
  ##         exec:
  ##           command:
  ##             - docker
  ##             - info
  ##         initialDelaySeconds: 0
  ##         failureThreshold: 24
  ##         periodSeconds: 5
  ##       volumeMounts:
  ##         - name: work
  ##           mountPath: /home/runner/_work
  ##         - name: dind-sock
  ##           mountPath: /var/run
  ##         - name: dind-externals
  ##           mountPath: /home/runner/externals
  ##     containers:
  ##     - name: runner
  ##       image: ghcr.io/actions/actions-runner:latest
  ##       command: ["/home/runner/run.sh"]
  ##       env:
  ##         - name: DOCKER_HOST
  ##           value: unix:///var/run/docker.sock
  ##         - name: RUNNER_WAIT_FOR_DOCKER_IN_SECONDS
  ##           value: "120"
  ##       volumeMounts:
  ##         - name: work
  ##           mountPath: /home/runner/_work
  ##         - name: dind-sock
  ##           mountPath: /var/run
  ##     volumes:
  ##     - name: work
  ##       emptyDir: {}
  ##     - name: dind-sock
  ##       emptyDir: {}
  ##     - name: dind-externals
  ##       emptyDir: {}
  ######################################################################################################
  ## with containerMode.type=kubernetes, we will populate the template.spec with following pod spec
  ## template:
  ##   spec:
  ##     containers:
  ##     - name: runner
  ##       image: ghcr.io/actions/actions-runner:latest
  ##       command: ["/home/runner/run.sh"]
  ##       env:
  ##         - name: ACTIONS_RUNNER_CONTAINER_HOOKS
  ##           value: /home/runner/k8s/index.js
  ##         - name: ACTIONS_RUNNER_POD_NAME
  ##           valueFrom:
  ##             fieldRef:
  ##               fieldPath: metadata.name
  ##         - name: ACTIONS_RUNNER_REQUIRE_JOB_CONTAINER
  ##           value: "true"
  ##       volumeMounts:
  ##         - name: work
  ##           mountPath: /home/runner/_work
  ##     volumes:
  ##       - name: work
  ##         ephemeral:
  ##           volumeClaimTemplate:
  ##             spec:
  ##               accessModes: [ "ReadWriteOnce" ]
  ##               storageClassName: "local-path"
  ##               resources:
  ##                 requests:
  ##                   storage: 1Gi
  spec:
    containers:
      - name: runner
        image: ghcr.io/actions/actions-runner:latest
        command: ["/home/runner/run.sh"]
## Optional controller service account that needs to have required Role and RoleBinding
## to operate this gha-runner-scale-set installation.
## The helm chart will try to find the controller deployment and its service account at installation time.
## In case the helm chart can't find the right service account, you can explicitly pass in the following value
## to help it finish RoleBinding with the right service account.
## Note: if your controller is installed to only watch a single namespace, you have to pass these values explicitly.
# controllerServiceAccount:
#   namespace: arc-system
#   name: test-arc-gha-runner-scale-set-controller

# Overrides the default `.Release.Namespace` for all resources in this chart.
namespaceOverride: ""

## Optional annotations and labels applied to all resources created by helm installation
##
## Annotations applied to all resources created by this helm chart. Annotations will not override the default ones, so make sure
## the custom annotation is not reserved.
# annotations:
#   key: value
##
## Labels applied to all resources created by this helm chart. Labels will not override the default ones, so make sure
## the custom label is not reserved.
# labels:
#   key: value

## If you want more fine-grained control over annotations applied to particular resource created by this chart,
## you can use `resourceMeta`.
## Order of applying labels and annotations is:
## 1. Apply labels/annotations globally, using `annotations` and `labels` field
## 2. Apply `resourceMeta` labels/annotations
## 3. Apply reserved labels/annotations
# resourceMeta:
#   autoscalingRunnerSet:
#     labels:
#       key: value
#     annotations:
#       key: value
#   githubConfigSecret:
#     labels:
#       key: value
#     annotations:
#       key: value
#   kubernetesModeRole:
#     labels:
#       key: value
#     annotations:
#       key: value
#   kubernetesModeRoleBinding:
#     labels:
#       key: value
#     annotations:
#       key: value
#   kubernetesModeServiceAccount:
#     labels:
#       key: value
#     annotations:
#       key: value
#   managerRole:
#     labels:
#       key: value
#     annotations:
#       key: value
#   managerRoleBinding:
#     labels:
#       key: value
#     annotations:
#       key: value
#   noPermissionServiceAccount:
#     labels:
#       key: value
#     annotations:
#       key: value

bharathkumardasaraju@external$


```

```shell
bharathkumardasaraju@external$ helm show chart oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set --version 0.12.1
Pulled: ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set:0.12.1
Digest: sha256:97125addd369e3fd2838ff279fc685a83d7cfe7e29d56af435c7733633026d53
apiVersion: v2
appVersion: 0.12.1
description: A Helm chart for deploying an AutoScalingRunnerSet
home: https://github.com/actions/actions-runner-controller
maintainers:
- name: actions
  url: https://github.com/actions
name: gha-runner-scale-set
sources:
- https://github.com/actions/actions-runner-controller
type: application
version: 0.12.1

bharathkumardasaraju@external$

```


## create github APP 
Create a github app and authenticate to guthub runner controller for github API access..
get below details 
```shell
  github_app_id = "1619953"
  github_app_installation_id = "76260063"

  data "aws_ssm_parameter" "github_privatekey" {
  name = "/dev/github_app_privatekey"
}

```

## Install actions runner controller helm charts
```shell
(external) bharathkumardasaraju@4.gha-runner-helm$ terraform apply --auto-approve
data.terraform_remote_state.aws-eks: Reading...
data.terraform_remote_state.aws-vpc: Reading...
data.aws_ssm_parameter.github_privatekey: Reading...
data.aws_region.current: Reading...
data.aws_availability_zones.available: Reading...
data.aws_caller_identity.current: Reading...
data.aws_region.current: Read complete after 0s [id=ap-south-1]
data.aws_caller_identity.current: Read complete after 0s [id=172586632398]
data.aws_ssm_parameter.github_privatekey: Read complete after 0s [id=/dev/github_app_privatekey]
data.aws_availability_zones.available: Read complete after 0s [id=ap-south-1]
data.terraform_remote_state.aws-vpc: Read complete after 1s
data.terraform_remote_state.aws-eks: Read complete after 1s
kubernetes_namespace_v1.actions: Refreshing state... [id=actions]
kubernetes_secret_v1.github_runner_config: Refreshing state... [id=actions/github-config]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # helm_release.arc_runners will be created
  + resource "helm_release" "arc_runners" {
      + atomic                     = false
      + chart                      = "gha-runner-scale-set"
      + cleanup_on_fail            = false
      + create_namespace           = false
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "gha-runner"
      + namespace                  = "actions"
      + pass_credentials           = false
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + repository                 = "oci://ghcr.io/actions/actions-runner-controller-charts"
      + reset_values               = false
      + reuse_values               = false
      + set_wo                     = (write-only attribute)
      + skip_crds                  = false
      + status                     = "deployed"
      + timeout                    = 300
      + values                     = [
          + <<-EOT
                "githubConfigSecret": "github-config"
                "githubConfigUrl": "https://github.com/1dot618labs"
            EOT,
        ]
      + verify                     = false
      + version                    = "0.12.1"
      + wait                       = true
      + wait_for_jobs              = false
    }

  # helm_release.arc_systems will be created
  + resource "helm_release" "arc_systems" {
      + atomic                     = false
      + chart                      = "gha-runner-scale-set-controller"
      + cleanup_on_fail            = false
      + create_namespace           = false
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "arc-systems"
      + namespace                  = "actions"
      + pass_credentials           = false
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + repository                 = "oci://ghcr.io/actions/actions-runner-controller-charts"
      + reset_values               = false
      + reuse_values               = false
      + set_wo                     = (write-only attribute)
      + skip_crds                  = false
      + status                     = "deployed"
      + timeout                    = 300
      + verify                     = false
      + version                    = "0.12.1"
      + wait                       = true
      + wait_for_jobs              = false
    }

Plan: 2 to add, 0 to change, 0 to destroy.
helm_release.arc_systems: Creating...
helm_release.arc_systems: Still creating... [00m10s elapsed]
helm_release.arc_systems: Creation complete after 19s [id=arc-systems]
helm_release.arc_runners: Creating...
helm_release.arc_runners: Creation complete after 5s [id=gha-runner]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
(external) bharathkumardasaraju@4.gha-runner-helm$ 
```

```shell
(external) bharathkumardasaraju@4.gha-runner-helm$ pwd
/Users/bharathkumardasaraju/external/gha-selfhosted-runners-on-k8s/4.gha-runner-helm
(external) bharathkumardasaraju@4.gha-runner-helm$ helm list -n actions
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                                   APP VERSION
arc-systems     actions         1               2025-07-18 14:36:27.119579 +0800 +08    deployed        gha-runner-scale-set-controller-0.12.1  0.12.1     
gha-runner      actions         1               2025-07-18 14:36:43.276959 +0800 +08    deployed        gha-runner-scale-set-0.12.1             0.12.1     
(external) bharathkumardasaraju@4.gha-runner-helm$ kubectl get all -n actions
NAME                                                 READY   STATUS    RESTARTS   AGE
pod/arc-systems-gha-rs-controller-6d46c5dc94-7gpzj   1/1     Running   0          33m
pod/gha-runner-748d99b5-listener                     1/1     Running   0          33m

NAME                                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/arc-systems-gha-rs-controller   1/1     1            1           33m

NAME                                                       DESIRED   CURRENT   READY   AGE
replicaset.apps/arc-systems-gha-rs-controller-6d46c5dc94   1         1         1       33m
(external) bharathkumardasaraju@4.gha-runner-helm$ 
```