### Task 1.1: Service Analysis & Infrastructure Selection

Analyze each service and recommend the optimal AWS infrastructure.

For each service, justify your choice between:
- **Compute**: Lambda, ECS Fargate, ECS EC2, EKS, App Runner
- **Database**: RDS, DynamoDB, MongoDB Atlas
- **Caching**: ElastiCache Redis/Memcached
- **Messaging**: SQS, SNS, EventBridge
- **Storage**: S3, EFS, EBS

**Deliverable:**:
- Service-by-service infrastructure recommendations
- Ensure to consider various architectures such as containers/serverless for the different services and the reasoning...
- Justification for each choice
- Cost considerations
- Scaling strategy


## Service by Service Infra Recomendation

### 1. Backend Service
ECS fargate with ALB.

**WHY?**
As the application is already containerised, which makes ECS a natural fit and we can eliminate server management by using Fargate instead of compute, which also helps in lower cost as fargate helps in scaling based on cpu/memory resources(no idle EC2)

- **AutoScaling**
  - Target: 70% CPU utilisation
  - min: 2, max: 2 tasks
  - scaleout: 2 tasks per step
  - scalein: 1 task per step

- **COST**
 - ALB: stargting from $16/month
 - Fargate: $0.04048/vCPU-hour, $0.004445/GB-hour
 - Monthly: 150-200$

 - **Scaling strategy**
   - Horizontal: Add/remove tasks based on CPU, memory, and request count metrics
   - Vertical: Adjust task CPU/memory if models grow larger
   - Multi-AZ deployment: Deploy across 3 AZs for high availability



### 2. Frontend Service
CloudFront + S3 (Static Hosting) or ECS Fargate

**WHY?**
cloudfront is best for static webpages along with S3 as a static website, and world wide website can be accessed with low latency. As cloudfront provides free SSL certificates.
WAF can be enabled for DDOS protection

** Alternate**
ECS fargate
similar configuration as of backend(1CPU, 2gi memory)
Cost: 50-100$ monthly

- **COST**
  - 5-20$ monthly 
  - much cheaper than running containers
- **SCALING**
  - automatic scaling will be handled by CDN, S3


### 3. Database
MongoDB Atlas on AWS

**WHY?**
DocumentDB is compatible but have versions configuration issue with mongo vesions
DocumentDB: managed svc. Handles backup, monitoring, maintenance with multi region support. Automated daily backup with point in time recovery.

- **CONFIGURATION**
 - M10 family(2CPU, 10GB ram)
 - 40GB disk space(with autoscaling enabled)
 - 3 node AZ with backup and retention enabled

- **SCALING**
  - upograde cluster as grows(vertical scaling). enable failover
  - horizontal: add shards for large dataset

- **COST**
   - ATLAS: 150-200$/month
   - storage: .25$/gb


### 4. MESSAGE & EVENT
SQS +  SNS + eventbridge

SQS for queuing task(can enable cron as well using eventbridge can run it for particular event and then send notification via SNS when task is successful)

- **Dead Letter Queue**: Configure for failed messages
- **SNS**
  - need pub/sub messaging (multiple subscribers)
  - notify multiple services of events

**Cost:**
- **SQS**: Free tier (1M requests/month), then $0.40/1M requests
- **EventBridge**: First 1M custom events/month free, then $1.00/1M events

