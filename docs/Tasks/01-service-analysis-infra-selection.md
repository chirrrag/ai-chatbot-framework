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

