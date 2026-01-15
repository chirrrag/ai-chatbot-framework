Part 2: AWS Account Structure & Security
Task 2.1: Multi-Account Structure
This is the first application being deployed to AWS, so propose an AWS account structure with environments (i.e. sandbox, dev, prod) and appropriate security that I can run this application in production.

Requirements:

Separate accounts for i.e. Management, Security/Audit, Shared Services, Development, Sandbox, UAT, Production
Suggest AWS Control Tower or Organizations with SCPs
SSO for giving developer teams access to the Cloud and what types of permissions they would need
Any security services such as Centralised logging, GuardDuty, Config, CloudTrail, SecurityHub etc...
Deliverable: Give a detailed explanation of this.




1. [Multi-Account Structure](#multi-account-structure)
2. [AWS Organizations & Control Tower](#aws-organizations--control-tower)
3. [Service Control Policies (SCPs)](#service-control-policies-scps)
4. [IAM Identity Center (SSO)](#iam-identity-center-sso)
5. [Security Services](#security-services)
6. [Network Architecture](#network-architecture)
7. [Cost Management](#cost-management)
8. [Implementation Roadmap](#implementation-roadmap)




## Multi-Account Structure

ROOT Account(Main)
 |- Management Account

 | Security & audit AU
   |- Security Account
   |- Audit Account
 
 | Shared Service OU
   |- Shared svc accoutn

 | Workload OU
   |- Dev Acc
   |- sandbox
   |- UAT
   |- prod acc


## AWS Organizations & Control Tower

### Setup
   - consolidated billing
   - centralized policy managment using SCP
   - simplified acc creation
### configuration
   - enable services: trail, security hub, guardduty, SSM, control tower


### AWS Control Tower
Automated setup and governance of multi-account AWS environment

- **Landing Zone**: Pre-configured multi-account structure
- **Guardrails**: Preventive and detective controls
- **Account Factory** Automated account provisioning
- **Dashboard** Centralized view of compliance

**Mandatory Guardrails**
- Disallow root user API access
- Disallow deletion of CloudTrail logs
- Disallow deletion of Config configuration
- Require MFA for root user
- Require encryption for S3 buckets
- Require encryption for EBS volumes
- Disallow public read access to S3 buckets
- Disallow public write access to S3 buckets
- Detect root user login
- Detect CloudTrail logging disabled
- Detect Config configuration changes
- Detect S3 bucket policy changes
- Detect IAM policy changes
- Detect security group changes



# SCP
provies account level permissin boundries 


### OU level SCPs
**Security & Audit OU**:
- Allow only security and audit services
- Deny deletion of security resources

**Shared Services OU**:
- Allow shared infra
- Deny production workload deployment
- Require tagging standards

**Workloads OU - Development/Sandbox**:
- Allow all services (for experimentation)
- Deny deletion of CloudTrail/Config
- Require cost allocation tags
- Budget alerts mandatory

**Workloads OU - UAT**:
- Production-like restrictions
- Require encryption
- Require backup policies

**Workloads OU - Production**:
- Strictest controls
- Deny deletion of critical resources
- Require MFA for all operations
- Require encryption everywhere


## security services

#### 1. Guard Duty
threat detection, continuous monitoring
#### 2. cloud trail
#### 3. Inspector
vulnerability assessment
#### 4. AWS Ssystem manager
#### 5. AWS WAF
#### 6. AWS shield