import ("strconv")

"airbyte": {
	annotations: {}
	labels: {}
	attributes: {
		apiResource: {
				definition: {
						apiVersion: "bdc.bdos.io/v1alpha1"
						kind:       "Application"
						type:       "bdos-airbyte"
					}
		}
	}
	description: "airbyte xdefinition"
	type:        "xdefinition"
}
template: {
	output: {
		"apiVersion": "core.oam.dev/v1beta1"
		"kind":       "Application"
		"metadata": {
			"name":      context["name"]
			"namespace": context["namespace"]
			"labels": {
				"app.core.bdos/type": "system"
			}
		annotations: {
			"app.core.bdos/catalog":     "bdosInfra",
			"app.core.bdos/extra-image": "airbyte/db:0.40.0-alpha,minio/minio:latest,bitnami/kubectl,airbyte/server:0.40.0-alpha,temporalio/auto-setup:1.7.0,airbyte/webapp:0.40.0-alpha,airbyte/container-orchestrator:0.40.2,airbyte/worker:0.40.0-alpha,airbyte/bootloader:0.40.0-alpha,airbyte/source-dameng:1.5.0,airbyte/source-kingbase:1.5.0,airbyte/source-customize-api:2.0.0"
		}
	}
		spec: {
		components: [{
			name: "airbyte-admin-role"
			type: "raw"
			properties: {
				apiVersion: "rbac.authorization.k8s.io/v1"
				kind:       "Role"
				metadata: {
					name:      "airbyte-admin-role"
					namespace: 	context["namespace"]
				}
				rules: [{
					apiGroups: ["*"]
					resources: [
						"jobs",
						"pods",
						"pods/log",
						"pods/exec",
						"pods/attach",
					]
					verbs: [
						"get",
						"list",
						"watch",
						"create",
						"update",
						"patch",
						"delete",
					]
				}]
			}
		}, {
			name: "airbyte-admin-binding"
			type: "raw"
			properties: {
				apiVersion: "rbac.authorization.k8s.io/v1"
				kind:       "RoleBinding"
				metadata: {
					name:      "airbyte-admin-binding"
					namespace: context["namespace"]
				}
				roleRef: {
					apiGroup: ""
					kind:     "Role"
					name:     "airbyte-admin-role"
				}
				subjects: [{
					kind:      "ServiceAccount"
					name:      "airbyte-admin"
					namespace: context["namespace"]
				}]
			}
		}, {
			name: "airbyte-env-bmbkmbbdbm"
			type: "raw"
			properties: {
				apiVersion: "v1"
				data: {
					DEPLOYMENT_MODE:                                   "CLOUD"
					ACTIVITY_INITIAL_DELAY_BETWEEN_ATTEMPTS_SECONDS:   ""
					ACTIVITY_MAX_ATTEMPT:                              ""
					ACTIVITY_MAX_DELAY_BETWEEN_ATTEMPTS_SECONDS:       ""
					AIRBYTE_VERSION:                                   "0.40.0-alpha"
					API_URL:                                           "/api/v1/"
					CONFIG_ROOT:                                       "/configs"
					CONFIGS_DATABASE_MINIMUM_FLYWAY_MIGRATION_VERSION: "0.35.15.001"
					CONTAINER_ORCHESTRATOR_ENABLED:                    "true"
					DATA_DOCKER_MOUNT:                                 "airbyte_data"
					DATABASE_DB:                                       "airbyte"
					DATABASE_HOST:                                     "airbyte-db-svc"
					DATABASE_PORT:                                     "5432"
					DATABASE_URL:                                      "jdbc:postgresql://airbyte-db-svc:5432/airbyte"
					DB_DOCKER_MOUNT:                                   "airbyte_db"
					FULLSTORY:                                         "enabled"
					GCS_LOG_BUCKET:                                    ""
					INTERNAL_API_HOST:                                 "airbyte-server-svc:8001"
					IS_DEMO:                                           "false"
					JOB_KUBE_ANNOTATIONS:                              ""
					JOB_KUBE_MAIN_CONTAINER_IMAGE_PULL_POLICY:         ""
					JOB_KUBE_NODE_SELECTORS:                           ""
					JOB_KUBE_TOLERATIONS:                              ""
					JOB_MAIN_CONTAINER_CPU_LIMIT:                      ""
					JOB_MAIN_CONTAINER_CPU_REQUEST:                    ""
					JOB_MAIN_CONTAINER_MEMORY_LIMIT:                   ""
					JOB_MAIN_CONTAINER_MEMORY_REQUEST:                 ""
					JOBS_DATABASE_MINIMUM_FLYWAY_MIGRATION_VERSION:    "0.29.15.001"
					LOCAL_ROOT:                                        "/tmp/airbyte_local"
					LOG_LEVEL:                                         "INFO"
					METRIC_CLIENT:                                     ""
					NORMALIZATION_JOB_MAIN_CONTAINER_CPU_LIMIT:        ""
					NORMALIZATION_JOB_MAIN_CONTAINER_CPU_REQUEST:      ""
					NORMALIZATION_JOB_MAIN_CONTAINER_MEMORY_LIMIT:     ""
					NORMALIZATION_JOB_MAIN_CONTAINER_MEMORY_REQUEST:   ""
					OTEL_COLLECTOR_ENDPOINT:                           ""
					RUN_DATABASE_MIGRATION_ON_STARTUP:                 "true"
					S3_LOG_BUCKET:                                     "airbyte-dev-logs"
					S3_LOG_BUCKET_REGION:                              ""
					S3_MINIO_ENDPOINT:                                 "http://airbyte-minio-svc:9000"
					S3_PATH_STYLE_ACCESS:                              "true"
					STATE_STORAGE_MINIO_BUCKET_NAME:                   "airbyte-dev-logs"
					STATE_STORAGE_MINIO_ENDPOINT:                      "http://airbyte-minio-svc:9000"
					TEMPORAL_HOST:                                     "airbyte-temporal-svc:7233"
					TEMPORAL_WORKER_PORTS:                             "9001,9002,9003,9004,9005,9006,9007,9008,9009,9010,9011,9012,9013,9014,9015,9016,9017,9018,9019,9020,9021,9022,9023,9024,9025,9026,9027,9028,9029,9030,9031,9032,9033,9034,9035,9036,9037,9038,9039,9040"
					TRACKING_STRATEGY:                                 "segment"
					USE_STREAM_CAPABLE_STATE:                          "true"
					WEBAPP_URL:                                        "airbyte-webapp-svc:80"
					WORKER_ENVIRONMENT:                                "kubernetes"
					WORKFLOW_FAILURE_RESTART_DELAY_SECONDS:            ""
					WORKSPACE_DOCKER_MOUNT:                            "airbyte_workspace"
					WORKSPACE_ROOT:                                    "/workspace"
				}
				kind: "ConfigMap"
				metadata: {
					name:      "airbyte-env-bmbkmbbdbm"
					namespace: context["namespace"]
				}
			}
		}, {
			name: "airbyte-temporal-dynamicconfig"
			type: "raw"
			properties: {
				apiVersion: "v1"
				data: "development.yaml": """
					# when modifying, remember to update the docker-compose version of this file in temporal/dynamicconfig/development.yaml
					frontend.enableClientVersionCheck:
					  - value: true
					    constraints: {}
					history.persistenceMaxQPS:
					  - value: 3000
					    constraints: {}
					frontend.persistenceMaxQPS:
					  - value: 3000
					    constraints: {}
					frontend.historyMgrNumConns:
					  - value: 30
					    constraints: {}
					frontend.throttledLogRPS:
					  - value: 20
					    constraints: {}
					history.historyMgrNumConns:
					  - value: 50
					    constraints: {}
					system.advancedVisibilityWritingMode:
					  - value: \"off\"
					    constraints: {}
					history.defaultActivityRetryPolicy:
					  - value:
					      InitialIntervalInSeconds: 1
					      MaximumIntervalCoefficient: 100.0
					      BackoffCoefficient: 2.0
					      MaximumAttempts: 0
					history.defaultWorkflowRetryPolicy:
					  - value:
					      InitialIntervalInSeconds: 1
					      MaximumIntervalCoefficient: 100.0
					      BackoffCoefficient: 2.0
					      MaximumAttempts: 0
					# Limit for responses. This mostly impacts discovery jobs since they have the largest responses.
					limit.blobSize.error:
					  - value: 15728640 # 15MB
					    constraints: {}
					limit.blobSize.warn:
					  - value: 10485760 # 10MB
					    constraints: {}

					"""

				kind: "ConfigMap"
				metadata: {
					name:      "airbyte-temporal-dynamicconfig"
					namespace: context["namespace"]
				}
			}
		}, {
			name: "sweep-pod-script"
			type: "raw"
			properties: {
				apiVersion: "v1"
				data: "sweep-pod.sh": """
					#!/bin/bash

					get_worker_pods () {
					  kubectl -n ${KUBE_NAMESPACE} -L airbyte -l airbyte=worker-pod \\
					    --field-selector status.phase!=Running get pods \\
					    -o=jsonpath='{range .items[*]} {.metadata.name} {.status.phase} {.status.conditions[0].lastTransitionTime} {.status.startTime}{\"\\n\"}{end}'
					}

					delete_worker_pod() {
					  printf \"From status '%s' since '%s', \" $2 $3
					  echo \"$1\" | grep -v \"STATUS\" | awk '{print $1}' | xargs --no-run-if-empty kubectl -n ${KUBE_NAMESPACE} delete pod
					}

					while :
					do
					  # Shorter time window for completed pods
					  SUCCESS_DATE_STR=`date -d 'now - 2 hours' --utc -Ins`
					  SUCCESS_DATE=`date -d $SUCCESS_DATE_STR +%s`
					  # Longer time window for pods in error (to debug)
					  NON_SUCCESS_DATE_STR=`date -d 'now - 24 hours' --utc -Ins`
					  NON_SUCCESS_DATE=`date -d $NON_SUCCESS_DATE_STR +%s`
					  (
					      IFS=$'\\n'
					      for POD in `get_worker_pods`; do
					          IFS=' '
					          POD_NAME=`echo $POD | cut -d \" \" -f 1`
					          POD_STATUS=`echo $POD | cut -d \" \" -f 2`
					          POD_DATE_STR=`echo $POD | cut -d \" \" -f 3`
					          POD_START_DATE_STR=`echo $POD | cut -d \" \" -f 4`
					          POD_DATE=`date -d ${POD_DATE_STR:-$POD_START_DATE_STR} '+%s'`
					          if [ \"$POD_STATUS\" = \"Succeeded\" ]; then
					            if [ \"$POD_DATE\" -lt \"$SUCCESS_DATE\" ]; then
					              delete_worker_pod \"$POD_NAME\" \"$POD_STATUS\" \"$POD_DATE_STR\"
					            fi
					          else
					            if [ \"$POD_DATE\" -lt \"$NON_SUCCESS_DATE\" ]; then
					              delete_worker_pod \"$POD_NAME\" \"$POD_STATUS\" \"$POD_DATE_STR\"
					            fi
					          fi
					      done
					  )
					  sleep 60
					done

					"""

				kind: "ConfigMap"
				metadata: {
					name:      "sweep-pod-script"
					namespace: context["namespace"]
				}
			}
		}, {
			name: "airbyte-secrets-ttfdbcfh47"
			type: "raw"
			properties: {
				apiVersion: "v1"
				data: {
					AWS_ACCESS_KEY_ID:                     "bWluaW8="
					AWS_SECRET_ACCESS_KEY:                 "bWluaW8xMjM="
					DATABASE_PASSWORD:                     "ZG9ja2Vy"
					DATABASE_USER:                         "ZG9ja2Vy"
					GOOGLE_APPLICATION_CREDENTIALS:        ""
					STATE_STORAGE_MINIO_ACCESS_KEY:        "bWluaW8="
					STATE_STORAGE_MINIO_SECRET_ACCESS_KEY: "bWluaW8xMjM="
				}
				kind: "Secret"
				metadata: {
					name:      "airbyte-secrets-ttfdbcfh47"
					namespace: context["namespace"]
				}
				type: "Opaque"
			}
		}, {
			name: "gcs-log-creds"
			type: "raw"
			properties: {
				apiVersion: "v1"
				data: "gcp.json": ""
				kind: "Secret"
				metadata: {
					name:      "gcs-log-creds"
					namespace: context["namespace"]
				}
			}
		}, {
			name: "airbyte-db-svc"
			type: "raw"
			properties: {
				apiVersion: "v1"
				kind:       "Service"
				metadata: {
					name:      "airbyte-db-svc"
					namespace: context["namespace"]
				}
				spec: {
					ports: [{
						port:     5432
						protocol: "TCP"
					}]
					selector: airbyte: "db"
					type: "ClusterIP"
				}
			}
		}, {
			name: "airbyte-minio-svc"
			type: "raw"
			properties: {
				apiVersion: "v1"
				kind:       "Service"
				metadata: {
					name:      "airbyte-minio-svc"
					namespace: context["namespace"]
				}
				spec: {
					ports: [{
						port:       9000
						protocol:   "TCP"
						targetPort: 9000
					}]
					selector: app: "airbyte-minio"
				}
			}
		}, {
			name: "airbyte-server-svc"
			type: "raw"
			properties: {
				apiVersion: "v1"
				kind:       "Service"
				metadata: {
					name:      "airbyte-server-svc"
					namespace: context["namespace"]
				}
				spec: {
					ports: [{
						port:     8001
						protocol: "TCP"
					}]
					selector: airbyte: "server"
					type: "ClusterIP"
				}
			}
		}, {
			name: "airbyte-temporal-svc"
			type: "raw"
			properties: {
				apiVersion: "v1"
				kind:       "Service"
				metadata: {
					name:      "airbyte-temporal-svc"
					namespace: context["namespace"]
				}
				spec: {
					ports: [{
						port:     7233
						protocol: "TCP"
					}]
					selector: airbyte: "temporal"
					type: "ClusterIP"
				}
			}
		}, {
			name: "airbyte-webapp-svc"
			type: "raw"
			properties: {
				apiVersion: "v1"
				kind:       "Service"
				metadata: {
					name:      "airbyte-webapp-svc"
					namespace: context["namespace"]
				}
				spec: {
					ports: [{
						port:     80
						protocol: "TCP"
					}]
					selector: airbyte: "webapp"
					type: "ClusterIP"
				}
			}
		}, {
			name: "airbyte-minio-pv-claim"
			type: "raw"
			properties: {
				apiVersion: "v1"
				kind:       "PersistentVolumeClaim"
				metadata: {
					labels: app: "airbyte-minio-storage-claim"
					name:      "airbyte-minio-pv-claim"
					namespace: context["namespace"]
				}
				spec: {
					accessModes: ["ReadWriteOnce"]
					resources: requests: storage: "3072Mi"
					storageClassName: context["storage_config.storage_class_mapping.nfs"]
					volumeMode:       "Filesystem"
				}
			}
		}, {
			name: "airbyte-volume-configs"
			type: "raw"
			properties: {
				apiVersion: "v1"
				kind:       "PersistentVolumeClaim"
				metadata: {
					labels: airbyte: "volume-configs"
					name:      "airbyte-volume-configs"
					namespace: context["namespace"]
				}
				spec: {
					accessModes: ["ReadWriteOnce"]
					resources: requests: storage: "3072Mi"
					storageClassName: context["storage_config.storage_class_mapping.nfs"]
					volumeMode:       "Filesystem"
				}
			}
		}, {
			name: "airbyte-volume-db"
			type: "raw"
			properties: {
				apiVersion: "v1"
				kind:       "PersistentVolumeClaim"
				metadata: {
					labels: airbyte: "volume-db"
					name:      "airbyte-volume-db"
					namespace: context["namespace"]
				}
				spec: {
					accessModes: ["ReadWriteOnce"]
					resources: requests: storage: "3072Mi"
					storageClassName: context["storage_config.storage_class_mapping.nfs"]
					volumeMode:       "Filesystem"
				}
			}
		}, {
			name: "airbyte-db"
			type: "raw"
			properties: {
				apiVersion: "apps/v1"
				kind:       "Deployment"
				metadata: {
					name:      "airbyte-db"
					namespace: context["namespace"]
				}
				spec: {
					replicas: 1
					selector: matchLabels: airbyte: "db"
					strategy: type: "Recreate"
					template: {
						metadata: labels: airbyte: "db"
						spec: {
							containers: [{
								env: [{
									name:  "POSTGRES_DB"
									value: "db-airbyte"
								}, {
									name:  "POSTGRES_PASSWORD"
									value: "docker"
								}, {
									name:  "POSTGRES_USER"
									value: "docker"
								}, {
									name:  "PGDATA"
									value: "/var/lib/postgresql/data/pgdata"
								}]
								image: context["docker_registry"] + "/airbyte/db:0.40.0-alpha"
								name:  "airbyte-db-container"
								ports: [{
									containerPort: 5432
								}]
								volumeMounts: [{
									mountPath: "/var/lib/postgresql/data"
									name:      "airbyte-volume-db"
								}]
							}]
							imagePullSecrets: [{
								name: context["K8S_IMAGE_PULL_SECRETS_NAME"]
							}]
							volumes: [{
								name: "airbyte-volume-db"
								persistentVolumeClaim: claimName: "airbyte-volume-db"
							}]
						}
					}
				}
			}
		}, {
			name: "airbyte-minio"
			type: "raw"
			properties: {
				apiVersion: "apps/v1"
				kind:       "Deployment"
				metadata: {
					name:      "airbyte-minio"
					namespace: context["namespace"]
				}
				spec: {
					selector: matchLabels: app: "airbyte-minio"
					strategy: type: "Recreate"
					template: {
						metadata: labels: app: "airbyte-minio"
						spec: {
							containers: [{
								args: [
									"server",
									"/storage",
								]
								env: [{
									name:  "MINIO_ACCESS_KEY"
									value: "minio"
								}, {
									name:  "MINIO_SECRET_KEY"
									value: "minio123"
								}]
								image: context["docker_registry"] +"/minio/minio:latest"
								name:  "airbyte-minio"
								ports: [{
									containerPort: 9000
								}]
								volumeMounts: [{
									mountPath: "/storage"
									name:      "storage"
								}]
							}]
							imagePullSecrets: [{
								name: context["K8S_IMAGE_PULL_SECRETS_NAME"]
							}]
							volumes: [{
								name: "storage"
								persistentVolumeClaim: claimName: "airbyte-minio-pv-claim"
							}]
						}
					}
				}
			}
		}, {
			name: "pod-sweeper"
			type: "raw"
			properties: {
				apiVersion: "apps/v1"
				kind:       "Deployment"
				metadata: {
					name:      "airbyte-pod-sweeper"
					namespace: context["namespace"]
				}
				spec: {
					replicas: 1
					selector: matchLabels: airbyte: "pod-sweeper"
					template: {
						metadata: labels: airbyte: "pod-sweeper"
						spec: {
							containers: [{
								command: [
									"/bin/bash",
									"-c",
									"/script/sweep-pod.sh",
								]
								env: [{
									name: "KUBE_NAMESPACE"
									valueFrom: fieldRef: fieldPath: "metadata.namespace"
								}]
								image:           context["docker_registry"] +"/bitnami/kubectl"
								imagePullPolicy: "IfNotPresent"
								name:            "airbyte-pod-sweeper"
								volumeMounts: [{
									mountPath: "/script/sweep-pod.sh"
									name:      "sweep-pod-script"
									subPath:   "sweep-pod.sh"
								}]
							}]
							serviceAccountName: "airbyte-admin"
							imagePullSecrets: [{
								name: context["K8S_IMAGE_PULL_SECRETS_NAME"]
							}]
							volumes: [{
								configMap: {
									defaultMode: 493
									name:        "sweep-pod-script"
								}
								name: "sweep-pod-script"
							}]
						}
					}
				}
			}
		}, {
			name: "airbyte-server"
			type: "raw"
			properties: {
				apiVersion: "apps/v1"
				kind:       "Deployment"
				metadata: {
					name:      "airbyte-server"
					namespace: context["namespace"]
				}
				spec: {
					replicas: 1
					selector: matchLabels: airbyte: "server"
					template: {
						metadata: labels: airbyte: "server"
						spec: {
							containers: [{
								env: [{
									name: "AIRBYTE_VERSION"
									valueFrom: configMapKeyRef: {
										key:  "AIRBYTE_VERSION"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "CONFIG_ROOT"
									valueFrom: configMapKeyRef: {
										key:  "CONFIG_ROOT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "DATABASE_PASSWORD"
									valueFrom: secretKeyRef: {
										key:  "DATABASE_PASSWORD"
										name: "airbyte-secrets-ttfdbcfh47"
									}
								}, {
									name: "DATABASE_URL"
									valueFrom: configMapKeyRef: {
										key:  "DATABASE_URL"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "DATABASE_USER"
									valueFrom: secretKeyRef: {
										key:  "DATABASE_USER"
										name: "airbyte-secrets-ttfdbcfh47"
									}
								}, {
									name: "TRACKING_STRATEGY"
									valueFrom: configMapKeyRef: {
										key:  "TRACKING_STRATEGY"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "WORKER_ENVIRONMENT"
									valueFrom: configMapKeyRef: {
										key:  "WORKER_ENVIRONMENT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "WORKSPACE_ROOT"
									valueFrom: configMapKeyRef: {
										key:  "WORKSPACE_ROOT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "WEBAPP_URL"
									valueFrom: configMapKeyRef: {
										key:  "WEBAPP_URL"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "TEMPORAL_HOST"
									valueFrom: configMapKeyRef: {
										key:  "TEMPORAL_HOST"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "LOG_LEVEL"
									valueFrom: configMapKeyRef: {
										key:  "LOG_LEVEL"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "JOB_MAIN_CONTAINER_CPU_REQUEST"
									valueFrom: configMapKeyRef: {
										key:  "JOB_MAIN_CONTAINER_CPU_REQUEST"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "JOB_MAIN_CONTAINER_CPU_LIMIT"
									valueFrom: configMapKeyRef: {
										key:  "JOB_MAIN_CONTAINER_CPU_LIMIT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "JOB_MAIN_CONTAINER_MEMORY_REQUEST"
									valueFrom: configMapKeyRef: {
										key:  "JOB_MAIN_CONTAINER_MEMORY_REQUEST"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "JOB_MAIN_CONTAINER_MEMORY_LIMIT"
									valueFrom: configMapKeyRef: {
										key:  "JOB_MAIN_CONTAINER_MEMORY_LIMIT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "S3_LOG_BUCKET"
									valueFrom: configMapKeyRef: {
										key:  "S3_LOG_BUCKET"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "S3_LOG_BUCKET_REGION"
									valueFrom: configMapKeyRef: {
										key:  "S3_LOG_BUCKET_REGION"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "AWS_ACCESS_KEY_ID"
									valueFrom: secretKeyRef: {
										key:  "AWS_ACCESS_KEY_ID"
										name: "airbyte-secrets-ttfdbcfh47"
									}
								}, {
									name: "AWS_SECRET_ACCESS_KEY"
									valueFrom: secretKeyRef: {
										key:  "AWS_SECRET_ACCESS_KEY"
										name: "airbyte-secrets-ttfdbcfh47"
									}
								}, {
									name: "S3_MINIO_ENDPOINT"
									valueFrom: configMapKeyRef: {
										key:  "S3_MINIO_ENDPOINT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "S3_PATH_STYLE_ACCESS"
									valueFrom: configMapKeyRef: {
										key:  "S3_PATH_STYLE_ACCESS"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "GOOGLE_APPLICATION_CREDENTIALS"
									valueFrom: secretKeyRef: {
										key:  "GOOGLE_APPLICATION_CREDENTIALS"
										name: "airbyte-secrets-ttfdbcfh47"
									}
								}, {
									name: "GCS_LOG_BUCKET"
									valueFrom: configMapKeyRef: {
										key:  "GCS_LOG_BUCKET"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "CONFIGS_DATABASE_MINIMUM_FLYWAY_MIGRATION_VERSION"
									valueFrom: configMapKeyRef: {
										key:  "CONFIGS_DATABASE_MINIMUM_FLYWAY_MIGRATION_VERSION"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "JOBS_DATABASE_MINIMUM_FLYWAY_MIGRATION_VERSION"
									valueFrom: configMapKeyRef: {
										key:  "JOBS_DATABASE_MINIMUM_FLYWAY_MIGRATION_VERSION"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}]
								image: context["docker_registry"] +"/airbyte/server:0.40.0-alpha"
								name:  "airbyte-server-container"
								ports: [{
									containerPort: 8001
								}]
								volumeMounts: [{
									mountPath: "/configs"
									name:      "airbyte-volume-configs"
								}, {
									mountPath: "/secrets/gcs-log-creds"
									name:      "gcs-log-creds-volume"
									readOnly:  true
								}]
							}]
							imagePullSecrets: [{
								name: context["K8S_IMAGE_PULL_SECRETS_NAME"]
							}]
							volumes: [{
								name: "airbyte-volume-configs"
								persistentVolumeClaim: claimName: "airbyte-volume-configs"
							}, {
								name: "gcs-log-creds-volume"
								secret: secretName: "gcs-log-creds"
							}]
						}
					}
				}
			}
		}, {
			name: "airbyte-temporal"
			type: "raw"
			properties: {
				apiVersion: "apps/v1"
				kind:       "Deployment"
				metadata: {
					name:      "airbyte-temporal"
					namespace: context["namespace"]
				}
				spec: {
					replicas: 1
					selector: matchLabels: airbyte: "temporal"
					template: {
						metadata: labels: airbyte: "temporal"
						spec: {
							containers: [{
								env: [{
									name: "POSTGRES_USER"
									valueFrom: secretKeyRef: {
										key:  "DATABASE_USER"
										name: "airbyte-secrets-ttfdbcfh47"
									}
								}, {
									name: "POSTGRES_PWD"
									valueFrom: secretKeyRef: {
										key:  "DATABASE_PASSWORD"
										name: "airbyte-secrets-ttfdbcfh47"
									}
								}, {
									name:  "DYNAMIC_CONFIG_FILE_PATH"
									value: "config/dynamicconfig/development.yaml"
								}, {
									name:  "DB"
									value: "postgresql"
								}, {
									name: "DB_PORT"
									valueFrom: configMapKeyRef: {
										key:  "DATABASE_PORT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "POSTGRES_SEEDS"
									valueFrom: configMapKeyRef: {
										key:  "DATABASE_HOST"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}]
								image: context["docker_registry"] +"/temporalio/auto-setup:1.7.0"

								name: "airbyte-temporal"
								ports: [{
									containerPort: 7233
								}]
								volumeMounts: [{
									mountPath: "/etc/temporal/config/dynamicconfig/"
									name:      "airbyte-temporal-dynamicconfig"
								}]
							}]
							imagePullSecrets: [{
								name: context["K8S_IMAGE_PULL_SECRETS_NAME"]
							}]
							volumes: [{
								configMap: {
									items: [{
										key:  "development.yaml"
										path: "development.yaml"
									}]
									name: "airbyte-temporal-dynamicconfig"
								}
								name: "airbyte-temporal-dynamicconfig"
							}]
						}
					}
				}
			}
		}, {
			name: "airbyte-webapp"
			type: "raw"
			properties: {
				apiVersion: "apps/v1"
				kind:       "Deployment"
				metadata: {
					name:      "airbyte-webapp"
					namespace: context["namespace"]
				}
				spec: {
					replicas: 1
					selector: matchLabels: airbyte: "webapp"
					template: {
						metadata: labels: airbyte: "webapp"
						spec: {
							containers: [{
								env: [{
									name: "AIRBYTE_VERSION"
									valueFrom: configMapKeyRef: {
										key:  "AIRBYTE_VERSION"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "API_URL"
									valueFrom: configMapKeyRef: {
										key:  "API_URL"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "TRACKING_STRATEGY"
									valueFrom: configMapKeyRef: {
										key:  "TRACKING_STRATEGY"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "FULLSTORY"
									valueFrom: configMapKeyRef: {
										key:  "FULLSTORY"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "IS_DEMO"
									valueFrom: configMapKeyRef: {
										key:  "IS_DEMO"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "INTERNAL_API_HOST"
									valueFrom: configMapKeyRef: {
										key:  "INTERNAL_API_HOST"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}]
								image: context["docker_registry"] + "/airbyte/webapp:0.40.0-alpha"
								name:  "airbyte-webapp-container"
								ports: [{
									containerPort: 80
								}]
							}]
							imagePullSecrets: [{
								name: context["K8S_IMAGE_PULL_SECRETS_NAME"]
							}]
						}
					}
				}
			}
		}, {
			name: "airbyte-worker"
			type: "raw"
			properties: {
				apiVersion: "apps/v1"
				kind:       "Deployment"
				metadata: {
					name:      "airbyte-worker"
					namespace: 	context["namespace"]
				}
				spec: {
					replicas: 1
					selector: matchLabels: airbyte: "worker"
					template: {
						metadata: labels: airbyte: "worker"
						spec: {
							automountServiceAccountToken: true
							containers: [{
								env: [{
									name: "AIRBYTE_VERSION"
									valueFrom: configMapKeyRef: {
										key:  "AIRBYTE_VERSION"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "CONFIG_ROOT"
									valueFrom: configMapKeyRef: {
										key:  "CONFIG_ROOT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "DATABASE_HOST"
									valueFrom: configMapKeyRef: {
										key:  "DATABASE_HOST"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name:  "JOB_ERROR_REPORTING_STRATEGY"
									value: "logging"
								}, {
									name:  "DEPLOYMENT_MODE"
									value: "CLOUD"
								}, {
									name: "DATABASE_PORT"
									valueFrom: configMapKeyRef: {
										key:  "DATABASE_PORT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "DATABASE_PASSWORD"
									valueFrom: secretKeyRef: {
										key:  "DATABASE_PASSWORD"
										name: "airbyte-secrets-ttfdbcfh47"
									}
								}, {
									name: "DATABASE_URL"
									valueFrom: configMapKeyRef: {
										key:  "DATABASE_URL"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "DATABASE_USER"
									valueFrom: secretKeyRef: {
										key:  "DATABASE_USER"
										name: "airbyte-secrets-ttfdbcfh47"
									}
								}, {
									name: "TRACKING_STRATEGY"
									valueFrom: configMapKeyRef: {
										key:  "TRACKING_STRATEGY"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name:  "WORKSPACE_DOCKER_MOUNT"
									value: "workspace"
								}, {
									name: "WORKSPACE_ROOT"
									valueFrom: configMapKeyRef: {
										key:  "WORKSPACE_ROOT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "WORKER_ENVIRONMENT"
									valueFrom: configMapKeyRef: {
										key:  "WORKER_ENVIRONMENT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "LOCAL_ROOT"
									valueFrom: configMapKeyRef: {
										key:  "LOCAL_ROOT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "WEBAPP_URL"
									valueFrom: configMapKeyRef: {
										key:  "WEBAPP_URL"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "TEMPORAL_HOST"
									valueFrom: configMapKeyRef: {
										key:  "TEMPORAL_HOST"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "TEMPORAL_WORKER_PORTS"
									valueFrom: configMapKeyRef: {
										key:  "TEMPORAL_WORKER_PORTS"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "LOG_LEVEL"
									valueFrom: configMapKeyRef: {
										key:  "LOG_LEVEL"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "JOB_KUBE_NAMESPACE"
									valueFrom: fieldRef: fieldPath: "metadata.namespace"
								}, {
									name: "JOB_MAIN_CONTAINER_CPU_REQUEST"
									valueFrom: configMapKeyRef: {
										key:  "JOB_MAIN_CONTAINER_CPU_REQUEST"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "JOB_MAIN_CONTAINER_CPU_LIMIT"
									valueFrom: configMapKeyRef: {
										key:  "JOB_MAIN_CONTAINER_CPU_LIMIT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "JOB_MAIN_CONTAINER_MEMORY_REQUEST"
									valueFrom: configMapKeyRef: {
										key:  "JOB_MAIN_CONTAINER_MEMORY_REQUEST"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "JOB_MAIN_CONTAINER_MEMORY_LIMIT"
									valueFrom: configMapKeyRef: {
										key:  "JOB_MAIN_CONTAINER_MEMORY_LIMIT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "NORMALIZATION_JOB_MAIN_CONTAINER_MEMORY_REQUEST"
									valueFrom: configMapKeyRef: {
										key:  "NORMALIZATION_JOB_MAIN_CONTAINER_MEMORY_REQUEST"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "NORMALIZATION_JOB_MAIN_CONTAINER_MEMORY_LIMIT"
									valueFrom: configMapKeyRef: {
										key:  "NORMALIZATION_JOB_MAIN_CONTAINER_MEMORY_LIMIT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "NORMALIZATION_JOB_MAIN_CONTAINER_CPU_REQUEST"
									valueFrom: configMapKeyRef: {
										key:  "NORMALIZATION_JOB_MAIN_CONTAINER_CPU_REQUEST"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "NORMALIZATION_JOB_MAIN_CONTAINER_CPU_LIMIT"
									valueFrom: configMapKeyRef: {
										key:  "NORMALIZATION_JOB_MAIN_CONTAINER_CPU_LIMIT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "S3_LOG_BUCKET"
									valueFrom: configMapKeyRef: {
										key:  "S3_LOG_BUCKET"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "S3_LOG_BUCKET_REGION"
									valueFrom: configMapKeyRef: {
										key:  "S3_LOG_BUCKET_REGION"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "AWS_ACCESS_KEY_ID"
									valueFrom: secretKeyRef: {
										key:  "AWS_ACCESS_KEY_ID"
										name: "airbyte-secrets-ttfdbcfh47"
									}
								}, {
									name: "AWS_SECRET_ACCESS_KEY"
									valueFrom: secretKeyRef: {
										key:  "AWS_SECRET_ACCESS_KEY"
										name: "airbyte-secrets-ttfdbcfh47"
									}
								}, {
									name: "S3_MINIO_ENDPOINT"
									valueFrom: configMapKeyRef: {
										key:  "S3_MINIO_ENDPOINT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "S3_PATH_STYLE_ACCESS"
									valueFrom: configMapKeyRef: {
										key:  "S3_PATH_STYLE_ACCESS"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "GOOGLE_APPLICATION_CREDENTIALS"
									valueFrom: secretKeyRef: {
										key:  "GOOGLE_APPLICATION_CREDENTIALS"
										name: "airbyte-secrets-ttfdbcfh47"
									}
								}, {
									name: "GCS_LOG_BUCKET"
									valueFrom: configMapKeyRef: {
										key:  "GCS_LOG_BUCKET"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "INTERNAL_API_HOST"
									valueFrom: configMapKeyRef: {
										key:  "INTERNAL_API_HOST"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "JOB_KUBE_TOLERATIONS"
									valueFrom: configMapKeyRef: {
										key:  "JOB_KUBE_TOLERATIONS"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "JOB_KUBE_ANNOTATIONS"
									valueFrom: configMapKeyRef: {
										key:  "JOB_KUBE_ANNOTATIONS"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "JOB_KUBE_NODE_SELECTORS"
									valueFrom: configMapKeyRef: {
										key:  "JOB_KUBE_NODE_SELECTORS"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "JOB_KUBE_MAIN_CONTAINER_IMAGE_PULL_POLICY"
									valueFrom: configMapKeyRef: {
										key:  "JOB_KUBE_MAIN_CONTAINER_IMAGE_PULL_POLICY"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "STATE_STORAGE_MINIO_BUCKET_NAME"
									valueFrom: configMapKeyRef: {
										key:  "STATE_STORAGE_MINIO_BUCKET_NAME"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "STATE_STORAGE_MINIO_ENDPOINT"
									valueFrom: configMapKeyRef: {
										key:  "STATE_STORAGE_MINIO_ENDPOINT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "STATE_STORAGE_MINIO_ACCESS_KEY"
									valueFrom: secretKeyRef: {
										key:  "STATE_STORAGE_MINIO_ACCESS_KEY"
										name: "airbyte-secrets-ttfdbcfh47"
									}
								}, {
									name: "STATE_STORAGE_MINIO_SECRET_ACCESS_KEY"
									valueFrom: secretKeyRef: {
										key:  "STATE_STORAGE_MINIO_SECRET_ACCESS_KEY"
										name: "airbyte-secrets-ttfdbcfh47"
									}
								}, {
									name: "CONTAINER_ORCHESTRATOR_ENABLED"
									valueFrom: configMapKeyRef: {
										key:  "CONTAINER_ORCHESTRATOR_ENABLED"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name:  "CONTAINER_ORCHESTRATOR_IMAGE"
									value: "airbyte/container-orchestrator:0.40.2"
								}, {
									name: "CONFIGS_DATABASE_MINIMUM_FLYWAY_MIGRATION_VERSION"
									valueFrom: configMapKeyRef: {
										key:  "CONFIGS_DATABASE_MINIMUM_FLYWAY_MIGRATION_VERSION"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "JOBS_DATABASE_MINIMUM_FLYWAY_MIGRATION_VERSION"
									valueFrom: configMapKeyRef: {
										key:  "JOBS_DATABASE_MINIMUM_FLYWAY_MIGRATION_VERSION"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "METRIC_CLIENT"
									valueFrom: configMapKeyRef: {
										key:  "METRIC_CLIENT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "OTEL_COLLECTOR_ENDPOINT"
									valueFrom: configMapKeyRef: {
										key:  "OTEL_COLLECTOR_ENDPOINT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "ACTIVITY_MAX_ATTEMPT"
									valueFrom: configMapKeyRef: {
										key:  "ACTIVITY_MAX_ATTEMPT"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "ACTIVITY_INITIAL_DELAY_BETWEEN_ATTEMPTS_SECONDS"
									valueFrom: configMapKeyRef: {
										key:  "ACTIVITY_INITIAL_DELAY_BETWEEN_ATTEMPTS_SECONDS"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "ACTIVITY_MAX_DELAY_BETWEEN_ATTEMPTS_SECONDS"
									valueFrom: configMapKeyRef: {
										key:  "ACTIVITY_MAX_DELAY_BETWEEN_ATTEMPTS_SECONDS"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "WORKFLOW_FAILURE_RESTART_DELAY_SECONDS"
									valueFrom: configMapKeyRef: {
										key:  "WORKFLOW_FAILURE_RESTART_DELAY_SECONDS"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name: "USE_STREAM_CAPABLE_STATE"
									valueFrom: configMapKeyRef: {
										key:  "USE_STREAM_CAPABLE_STATE"
										name: "airbyte-env-bmbkmbbdbm"
									}
								}, {
									name:  "JOB_KUBE_MAIN_CONTAINER_IMAGE_PULL_SECRET"
									value: context["K8S_IMAGE_PULL_SECRETS_NAME"]
								}]
								image: context["docker_registry"] + "/airbyte/worker:0.40.0-alpha"
								name:  "airbyte-worker-container"
								ports: [{
									containerPort: 9000
								}, {
									containerPort: 9001
								}, {
									containerPort: 9002
								}, {
									containerPort: 9003
								}, {
									containerPort: 9004
								}, {
									containerPort: 9005
								}, {
									containerPort: 9006
								}, {
									containerPort: 9007
								}, {
									containerPort: 9008
								}, {
									containerPort: 9009
								}, {
									containerPort: 9010
								}, {
									containerPort: 9011
								}, {
									containerPort: 9012
								}, {
									containerPort: 9013
								}, {
									containerPort: 9014
								}, {
									containerPort: 9015
								}, {
									containerPort: 9016
								}, {
									containerPort: 9017
								}, {
									containerPort: 9018
								}, {
									containerPort: 9019
								}, {
									containerPort: 9020
								}, {
									containerPort: 9021
								}, {
									containerPort: 9022
								}, {
									containerPort: 9023
								}, {
									containerPort: 9024
								}, {
									containerPort: 9025
								}, {
									containerPort: 9026
								}, {
									containerPort: 9027
								}, {
									containerPort: 9028
								}, {
									containerPort: 9029
								}, {
									containerPort: 9030
								}]
								volumeMounts: [{
									mountPath: "/secrets/gcs-log-creds"
									name:      "gcs-log-creds-volume"
									readOnly:  true
								}]
							}]
							serviceAccountName: "airbyte-admin"
							imagePullSecrets: [{
								name: context["K8S_IMAGE_PULL_SECRETS_NAME"]
							}]
							volumes: [{
								name: "gcs-log-creds-volume"
								secret: secretName: "gcs-log-creds"
							}]
						}
					}
				}
			}
		}, {
			name: "airbyte-bootloader"
			type: "raw"
			properties: {
				apiVersion: "batch/v1"
				kind:       "Job"
				metadata: {
					name:      "airbyte-bootloader"
					namespace: context["namespace"]
				}
				spec: {
					template: spec: {
						containers: [{
							env: [{
								name: "AIRBYTE_VERSION"
								valueFrom: configMapKeyRef: {
									key:  "AIRBYTE_VERSION"
									name: "airbyte-env-bmbkmbbdbm"
								}
							}, {
								name: "DATABASE_HOST"
								valueFrom: configMapKeyRef: {
									key:  "DATABASE_HOST"
									name: "airbyte-env-bmbkmbbdbm"
								}
							}, {
								name: "DATABASE_PORT"
								valueFrom: configMapKeyRef: {
									key:  "DATABASE_PORT"
									name: "airbyte-env-bmbkmbbdbm"
								}
							}, {
								name: "DATABASE_PASSWORD"
								valueFrom: secretKeyRef: {
									key:  "DATABASE_PASSWORD"
									name: "airbyte-secrets-ttfdbcfh47"
								}
							}, {
								name: "DATABASE_URL"
								valueFrom: configMapKeyRef: {
									key:  "DATABASE_URL"
									name: "airbyte-env-bmbkmbbdbm"
								}
							}, {
								name: "DATABASE_USER"
								valueFrom: secretKeyRef: {
									key:  "DATABASE_USER"
									name: "airbyte-secrets-ttfdbcfh47"
								}
							}]
							image: context["docker_registry"] + "/airbyte/bootloader:0.40.0-alpha"
							name:  "airbyte-bootloader-container"
						}]
						restartPolicy: "Never"
						imagePullSecrets: [{
							name: context["K8S_IMAGE_PULL_SECRETS_NAME"]
						}]
					}
					ttlSecondsAfterFinished: 5
				}
			}
		}, {
			name: "airbyte-admin"
			type: "raw"
			properties: {
				apiVersion: "v1"
				kind:       "ServiceAccount"
				metadata: {
					name:      "airbyte-admin"
					namespace: context["namespace"]
				}
			}
		}]
		policies: [{
			name: "garbage-collect"
			type: "garbage-collect"
			properties: rules: [{
				selector: componentNames: [
					"airbyte-volume-configs",
					"airbyte-volume-db",
				]
				strategy: "never"
			}]
		}]
	}
	}
		parameter: {
		resources: {
			// +ui:description=预留
			// +ui:order=1
			requests: {
				// +ui:description=CPU
				// +ui:order=1
				// +pattern=^(\d+\.\d{1,3}?|[1-9]\d*m?)$
				// +err:options={"pattern":"请输入正确的cpu格式，如1, 1000m"}
				cpu: *"0.1" | string
				// +ui:description=内存
				// +ui:order=2
				// +pattern=^[1-9]\d*(Mi|Gi)$
				// +err:options={"pattern":"请输入正确的内存格式，如1024Mi, 1Gi"}
				memory: *"1024Mi" | string
			}
			// +ui:description=限制
			// +ui:order=2
			limits: {
				// +ui:description=CPU
				// +ui:order=1
				// +pattern=^(\d+\.\d{1,3}?|[1-9]\d*m?)$
				// +err:options={"pattern":"请输入正确的cpu格式，如1, 1000m"}
				cpu: *"1.0" | string
				// +ui:description=内存
				// +ui:order=2
				// +pattern=^[1-9]\d*(Mi|Gi)$
				// +err:options={"pattern":"请输入正确的内存格式，如1024Mi, 1Gi"}
				memory: *"1024Mi" | string
			}
		}
	}
}
