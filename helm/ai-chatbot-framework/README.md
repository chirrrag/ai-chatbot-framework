# AI Chatbot Framework Helm Chart

This Helm chart deploys the AI Chatbot Framework on Kubernetes with support for different environments and ML workloads.

## Features

- **Parent chart with subcharts**: MongoDB (Bitnami) as dependency
- **Environment-specific configurations**: Dev, Staging, and Production
- **ML workload support**: Configurable resource requests/limits for ML workloads
- **Health checks**: Liveness, readiness, and startup probes
- **Horizontal Pod Autoscaler**: Automatic scaling based on CPU and memory
- **ConfigMaps and Secrets**: Secure configuration management
- **Ingress with TLS**: AWS Load Balancer Controller support with TLS termination
- **MongoDB options**: Bitnami MongoDB chart or DocumentDB connection

## Prerequisites

- Kubernetes 1.24+
- Helm 3.8+
- AWS Load Balancer Controller (for Ingress)
- (Optional) DocumentDB cluster or MongoDB

## Installation

### Add Bitnami Helm Repository

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### Install with Default Values

```bash
helm install ai-chatbot-framework ./helm/ai-chatbot-framework
```

### Install for Development

```bash
helm install ai-chatbot-framework ./helm/ai-chatbot-framework \
  -f ./helm/ai-chatbot-framework/values-dev.yaml
```

### Install for Staging

```bash
helm install ai-chatbot-framework ./helm/ai-chatbot-framework \
  -f ./helm/ai-chatbot-framework/values-staging.yaml
```

### Install for Production

```bash
helm install ai-chatbot-framework ./helm/ai-chatbot-framework \
  -f ./helm/ai-chatbot-framework/values-prod.yaml \
  --set documentdb.endpoint="your-docdb-endpoint" \
  --set documentdb.secretName="your-secret-name" \
  --set ingress.annotations."alb\.ingress\.kubernetes\.io/certificate-arn"="your-acm-arn"
```

## Configuration

### MongoDB vs DocumentDB

#### Using Bitnami MongoDB (Default)

```yaml
mongodb:
  enabled: true
  auth:
    rootPassword: "your-password"
    password: "your-password"
    database: ai_chatbot_framework
```

#### Using DocumentDB

```yaml
mongodb:
  enabled: false

documentdb:
  enabled: true
  endpoint: "docdb-cluster.cluster-xxxxx.us-east-1.docdb.amazonaws.com"
  port: 27017
  database: ai_chatbot_framework
  secretName: "documentdb-credentials"  # Reference to existing secret
```

### ML Workload Configuration

For ML workloads, configure backend to use ML node group:

```yaml
backend:
  nodeSelector:
    workload-type: ml
  tolerations:
    - key: workload-type
      value: ml
      effect: NoSchedule
  resources:
    requests:
      memory: "4Gi"
      cpu: "2000m"
    limits:
      memory: "8Gi"
      cpu: "4000m"
```

### Ingress Configuration

#### AWS Load Balancer Controller

```yaml
ingress:
  enabled: true
  className: "alb"
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
    alb.ingress.kubernetes.io/ssl-redirect: "443"
    alb.ingress.kubernetes.io/certificate-arn: "arn:aws:acm:..."
  hosts:
    - host: chatbot.example.com
      paths:
        - path: /
          pathType: Prefix
          service: frontend
        - path: /api
          pathType: Prefix
          service: backend
```

### Horizontal Pod Autoscaler

```yaml
backend:
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10
    targetCPUUtilizationPercentage: 70
    targetMemoryUtilizationPercentage: 80
    behavior:
      scaleDown:
        stabilizationWindowSeconds: 300
      scaleUp:
        stabilizationWindowSeconds: 0
```

### Secrets Management

#### Using External Secrets (Recommended for Production)

Reference existing secrets:

```yaml
secrets:
  create: false
  documentdb:
    name: "documentdb-credentials"  # Existing secret name
    usernameKey: username
    passwordKey: password
  app:
    name: "app-secrets"  # Existing secret name
    keys:
      - OPENAI_API_KEY
      - FACEBOOK_APP_SECRET
```

#### Creating Secrets from Values

```yaml
secrets:
  create: true
  mongodb:
    name: ""  # Auto-generated
```

## Values Reference

### Global

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.environment` | Environment name | `prod` |
| `global.imageRegistry` | Global image registry | `""` |
| `global.imagePullSecrets` | Global image pull secrets | `[]` |

### Backend

| Parameter | Description | Default |
|-----------|-------------|---------|
| `backend.enabled` | Enable backend deployment | `true` |
| `backend.resources.requests` | Resource requests | `memory: 2Gi, cpu: 1000m` |
| `backend.resources.limits` | Resource limits | `memory: 4Gi, cpu: 2000m` |
| `backend.autoscaling.enabled` | Enable HPA | `true` |
| `backend.autoscaling.minReplicas` | Minimum replicas | `2` |
| `backend.autoscaling.maxReplicas` | Maximum replicas | `10` |
| `backend.livenessProbe` | Liveness probe config | See values.yaml |
| `backend.readinessProbe` | Readiness probe config | See values.yaml |
| `backend.startupProbe` | Startup probe config | See values.yaml |

### Frontend

| Parameter | Description | Default |
|-----------|-------------|---------|
| `frontend.enabled` | Enable frontend deployment | `true` |
| `frontend.resources.requests` | Resource requests | `memory: 128Mi, cpu: 100m` |
| `frontend.resources.limits` | Resource limits | `memory: 256Mi, cpu: 500m` |
| `frontend.autoscaling.enabled` | Enable HPA | `true` |
| `frontend.autoscaling.minReplicas` | Minimum replicas | `2` |
| `frontend.autoscaling.maxReplicas` | Maximum replicas | `5` |

### MongoDB

| Parameter | Description | Default |
|-----------|-------------|---------|
| `mongodb.enabled` | Enable Bitnami MongoDB | `true` |
| `mongodb.auth.enabled` | Enable authentication | `true` |
| `mongodb.auth.database` | Database name | `ai_chatbot_framework` |
| `mongodb.persistence.size` | Persistent volume size | `20Gi` |

### DocumentDB

| Parameter | Description | Default |
|-----------|-------------|---------|
| `documentdb.enabled` | Enable DocumentDB connection | `false` |
| `documentdb.endpoint` | DocumentDB endpoint | `""` |
| `documentdb.port` | DocumentDB port | `27017` |
| `documentdb.database` | Database name | `ai_chatbot_framework` |
| `documentdb.secretName` | Secret name for credentials | `""` |

### Ingress

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `true` |
| `ingress.className` | Ingress class name | `alb` |
| `ingress.annotations` | Ingress annotations | See values.yaml |
| `ingress.hosts` | Ingress hosts | See values.yaml |
| `ingress.tls` | TLS configuration | `[]` |

## Upgrading

```bash
helm upgrade ai-chatbot-framework ./helm/ai-chatbot-framework \
  -f ./helm/ai-chatbot-framework/values-prod.yaml
```

## Uninstalling

```bash
helm uninstall ai-chatbot-framework
```

## Troubleshooting

### Pods Not Starting

1. Check pod status:
```bash
kubectl get pods -l app.kubernetes.io/name=ai-chatbot-framework
```

2. Check pod logs:
```bash
kubectl logs -l component=backend
kubectl logs -l component=frontend
```

3. Check events:
```bash
kubectl describe pod <pod-name>
```

### MongoDB Connection Issues

1. Verify MongoDB secret:
```bash
kubectl get secret <secret-name> -o yaml
```

2. Test connection from pod:
```bash
kubectl exec -it <backend-pod> -- python -c "from app.database import client; print(client.server_info())"
```

### HPA Not Scaling

1. Check HPA status:
```bash
kubectl get hpa
kubectl describe hpa <hpa-name>
```

2. Check metrics:
```bash
kubectl top pods
```

### Ingress Not Working

1. Check ingress status:
```bash
kubectl get ingress
kubectl describe ingress <ingress-name>
```

2. Check AWS Load Balancer Controller logs:
```bash
kubectl logs -n kube-system deployment/aws-load-balancer-controller
```

## Support

For issues or questions, please refer to the main project documentation or create an issue in the repository.

