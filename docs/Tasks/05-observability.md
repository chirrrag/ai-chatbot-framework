# Part 5: Observability

### Prometheus and Grafana

**Prometheus** will serve as the primary metrics collection and storage system. It will be configured to:

- Pull metrics from various exporters and services at regular intervals (default: 15 seconds)
- Store time-series data in its built-in TSDB (Time Series Database)
- Provide a query language (PromQL) for metric analysis
- Serve metrics via HTTP API for visualization and alerting

**Grafana** will be used for visualization and dashboards:

- Connect to Prometheus as a data source
- Create comprehensive dashboards for:
  - Infrastructure metrics (CPU, memory, disk, network)
  - Application metrics (request rates, latency, error rates)
  - Kubernetes cluster metrics (pod status, resource usage)
  - Database metrics (connections, query performance)
- Store dashboard configurations in Git for version control
- Enable dashboard sharing and templating for different environments

The integration between Prometheus and Grafana allows for:
- Real-time visualization of metrics
- Historical data analysis and trending
- Custom alerting rules based on PromQL queries
- Annotations for deployment events and incidents

### Alert Routing

**High Priority Alerts** (Critical/Urgent):
- Sent to zenduty  pagerDuty for immediate incident management
- Examples:
  - Application down (5xx errors > threshold)
  - Database connection failures
  - High memory usage (> 90%)
  - Disk space critical (< 10%)
  - Pod crash loops
  - Service unavailable

**Low Priority Alerts** (Warning/Info):
- Sent to slack channels
- Examples:
  - High CPU usage (warning threshold)
  - Increased latency (non-critical)
  - Recurring non-critical errors
  - Resource usage approaching limits
  - Deployment notifications

### Alert Rules

Alert rules will be defined in Prometheus for:

Infras,application,dubernetes,database




### Prometheus Node Exporter

**Node Exporter**  will be deployed on each Kubernetes node to expose:



### Alertmanager

**Alertmanager** will be configured with:
- Multiple notification receivers (Zenduty, PagerDuty, Slack)
- Routing rules based on alert labels
- Silence and inhibition rules
- High availability setup (multiple replicas)

### Victoria Metrics

**Victoria Metrics
- Metrics that cannot be easily pulled by Prometheus
- High-cardinality metrics
- Long-term metric storage
- Alternative to Prometheus for specific use cases

## Application Performance Monitoring (APM)

### New Relic Integration

**New Relic** will be integrated for application-level monitoring:

- **Application Metrics**:
  - Request rates and throughput
  - Response times and latency (p50, p95, p99)
  - Error rates (4xx, 5xx)
  - Database query performance
  - External API call performance

### Freshping Integration


- **Uptime Monitoring**: Continuous health checks of the application endpoints
- **SSL Certificate Monitoring**: Alert on certificate expiration
- **DNS Monitoring**: Verify DNS resolution


## AWS CloudWatch Integration

### CloudWatch Logs

**CloudWatch Logs** will be enabled for:

- **EKS Cluster Logs**: API server, controller manager, scheduler logs
- **Application Logs**: Backend and frontend application logs


### CloudWatch Metrics

**CloudWatch Metrics** will collect:

- **EKS Metrics**: Cluster and node group metrics
- **EC2 Metrics**: Instance-level CPU, memory, network, disk
- **Application Load Balancer Metrics**: Request count, latency, error rates
- **S3 Metrics**: Request rates, data transfer

### CloudWatch Alarms

**CloudWatch Alarms** will be configured for critical alerts:

- **Database Alarms**:
  Freeable memory CPU utilization, Connection count, replication lag

- **EKS Alarms**:
   CPU,  memory, pod evict 

- **Application Alarms**:
ALB 5xx Errors, target health,responsetime, infra alarm


### Centralized Logging

All logs will be aggregated in a centralized location:

- **CloudWatch Logs**: Primary log aggregation for AWS services
- **Fluent Bit**: Log forwarder from Kubernetes pods to CloudWatch

