import ("strconv")

"airbyte": {
	annotations: {}
	labels: {}
	attributes: {
		"dynamicParameterMeta": [
      {
				"name": "dependencies.mysql.settingName",
				"type": "ContextSetting",
				"refType": "mysql",
				"refKey": "",
				"description": "mysql setting name",
				"required": true
			},
			{
				"name": "dependencies.mysql.secretName",
				"type": "ContextSecret",
				"refType": "mysql",
				"refKey": "",
				"description": "mysql secret name",
				"required": true
			},
		]
		apiResource: {
				definition: {
						apiVersion: "bdc.bdos.io/v1alpha1"
						kind:       "Application"
						type:       "bdos-airbyte-service"
					}
		}
	}
	description: "airbyte service xdefinition"
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
				"app":                "bdos-airbyte-service"
				"app.core.bdos/type": "system"
			}
			"annotations": {
				"app.core.bdos/catalog": "bdosInfra"
			}
		}
	spec: components: [{
		name: "bdos-airbyte-service"
		properties: {
			cpu: "1.0"
			env: [{
				name:  "SERVICE_NAME"
				value: "bdos_airbyte_service"
			}, {
				name:  "NAMESPACE"
				value: context["namespace"]
			}, {
				name:  "CLUSTER_NAME"
				value: "default"
			}, {
				name:  "MYSQL_DATABASE"
				value: "airbyte"
			}, {
				name: "MYSQL_HOST"
				valueFrom: configMapKeyRef: {
					name: parameter.dependencies.mysql.settingName
					key:  "MYSQL_HOST"
				}
			}, {
				name: "MYSQL_PORT"
				valueFrom: configMapKeyRef: {
					name: "mysql-setting"
					key:  "MYSQL_PORT"
				}
			}, {
				name:  "MYSQL_URL"
				value: "jdbc:mysql://$(MYSQL_HOST):$(MYSQL_PORT)/$(MYSQL_DATABASE)?useUnicode=true&characterEncoding=utf8&serverTimezone=GMT%2B8"
			}, {
				name: "MYSQL_PASSWORD"
				valueFrom: secretKeyRef: {
					name: "\(parameter.dependencies.mysql.secretName)"
					key:  "MYSQL_PASSWORD"
				}
			}, {
				name: "MYSQL_USER"
				valueFrom: secretKeyRef: {
					name: "\(parameter.dependencies.mysql.secretName)"
					key:  "MYSQL_USER"
				}
			}, {
				name:  "REDIS_URL"
				value: "linktime-redis-svc:16379"
			}, {
				name:  "USER_SERVICE"
				value: "http://bdos-user-service-svc:4100"
			}, {
				name:  "AIRBYTE_SERVICE"
				value: "http://airbyte-server-svc:8001"
			}, {
				name:  "AUDIT_SERVICE"
				value: "http://bdos-audit-service-svc:4800"
			}, {
				name:  "TIMEZONE"
				value: "Asia/Shanghai"
			}, {
				name: "BDOS_AUTH_ENABLED"
				valueFrom: configMapKeyRef: {
					name: "bdos-auth-cfg"
					key:  "BDOS_AUTH_ENABLED"
				}
			}, {
				name: "KEYCLOAK_CLIENT_ID"
				value: context["namespace"] + "-" + context["name"]
			}, {
				name: "KEYCLOAK_ENABLED"
				value: strconv.FormatBool(parameter.dependencies.keycloak.enabled)
			}, {
				name: "KEYCLOAK_REALM"
				valueFrom: configMapKeyRef: {
					name: "keycloak-context"
					key:  "default-realm"
				}
			}, {
				name: "KEYCLOAK_URL"
				value: context["keycloak_domain"] + "/auth"
			}, {
				name: "KEYCLOAK_SSL_REQUIRED"
				valueFrom: configMapKeyRef: {
					name: "bdos-auth-cfg"
					key:  "KEYCLOAK_SSL_REQUIRED"
				}
			}]
			image:           context["docker_registry"] + "/" + parameter.image
			imagePullPolicy: "IfNotPresent"
			mem:             "2048.0"
			name:            "bdos-airbyte-service"
			livenessProbe: {
				initialDelaySeconds: 30
				periodSeconds:       10
				failureThreshold:    3
				timeoutSeconds:      3
				successThreshold:    1
				httpGet: {
					port: 9097
					path: "/health"
				}
			}
			readinessProbe: {
				initialDelaySeconds: 30
				periodSeconds:       10
				failureThreshold:    3
				timeoutSeconds:      3
				successThreshold:    1
				httpGet: {
					port: 9097
					path: "/health"
				}
			}
			replicas: 1
			volumes: [{
				mountPath: "/bdos-airbyte-service/logs/"
				name:      "logs"
				type:      "emptyDir"
			}]
		}
		type: "bdosapp"
		traits: [{
			type: "bdos-logtail"
			properties: {
				name: "logs"
				path: "/var/log/\(context.namespace)-\(context.name)"
			}
		}, {
			type: "bdos-expose"
			properties: ports: [{
				containerPort: 9097
				protocol:      "TCP"
			}]
		}, {
			type: "bdos-monitor"
			properties: endpoints: [{
				port: 9097
			}]
		}]
	}]
	}
	
	parameter: {
		// +ui:description=docker仓库镜像版本
		// +ui:order=1
		image: *"bdos-airbyte-service:4.2.230910" | string
		// +ui:description=docker仓库资源规格
		// +ui:order=2
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
		// +ui:order=3
		// +ui:description=组件依赖
		// +ui:title=组件依赖
		dependencies: {
			// +ui:order=1
			// +ui:description=MySQL 配置
			mysql: {
					// +ui:order=1
					// +ui:description=数据库账号账号密码信息对应配置上下文
					// +err:options={"required":"请先安装Mysql"}
					secretName:  string
					// +ui:order=2
					// +ui:description=数据库连接信息对应配置上下文
					// +err:options={"required":"请先安装Mysql"}
					settingName: string
			}
			// +ui:order=2
			// +ui:description=Keycloak 配置
			keycloak: {
					// +ui:order=1
					// +ui:options={"disabled":true}
					// +ui:description=开启单点登录
				enabled: *true | bool
			}
		}
	}
}
