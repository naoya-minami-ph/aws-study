# AWS Study — Infrastructure Practice (CloudFormation + Terraform)

Hands-on practice project built after obtaining AWS Certified Solutions Architect – Associate (SAA-C03).
The same infrastructure was built twice — once with **CloudFormation**, once with **Terraform** — to compare
the two approaches to Infrastructure as Code.

## Architecture

- VPC (10.0.0.0/16) with 2 public subnets and 2 private subnets across AZ1a and AZ1c
- Internet Gateway + Route Tables
- Security Groups for ALB, EC2, and RDS
- EC2 instance (Amazon Linux 2023, t3.micro) running Nginx
- RDS MySQL (db.t4g.micro) in a private DB Subnet Group
- Application Load Balancer routing HTTP traffic to EC2
- AWS WAF (Managed Rule Set) attached to the ALB, with logging to CloudWatch Logs
- CloudWatch Alarms (EC2 CPU utilization, WAF blocked-request count) with SNS email notifications

## CloudFormation

Template: [`aws-study.26.yaml`](cloudformation/aws-study.26.yaml)

Deployed and verified via the AWS Console (stack CREATE_COMPLETE, SSH access to EC2, ALB routing to
Nginx, CloudWatch alarm and SNS notification, WAF log delivery). Screenshots available in [`images/`](images/).

## Terraform

Directory: [`terraform/`](terraform/)

Same infrastructure, rebuilt in Terraform (HCL) and split into files by resource type:

| File | Contents |
|---|---|
| `provider.tf` | AWS provider configuration |
| `variables.tf` | Variable definitions |
| `network.tf` | VPC, subnets, IGW, route tables, security groups |
| `ec2.tf` | EC2 instance |
| `rds.tf` | RDS |
| `alb.tf` | Application Load Balancer |
| `cloudwatch.tf` | SNS topic, CPU utilization alarm |
| `waf.tf` | WAF WebACL, logging, blocked-request alarm |
| `outputs.tf` | Outputs (ALB DNS name, etc.) |

### Setup

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# then edit terraform.tfvars with your own values (db_password, notification_email, my_ip, key_name)
terraform init
terraform plan
terraform apply
```

`terraform.tfvars` is excluded from version control (see `.gitignore`) since it contains sensitive values.

**Note on `my_ip`:** no default is set intentionally — specify your own IP address for SSH access.

**Note on `key_name`:** the default value is the original author's personal EC2 key pair name. Create your
own key pair in your AWS account and set `key_name` in `terraform.tfvars` accordingly.

## Operational Notes

**Port configuration:** EC2 runs Nginx with its default configuration, listening directly on port 80 (no
reverse proxy to a separate application such as Spring Boot). The ALB TargetGroup port (80) is intentionally
aligned with this actual application configuration.

## Certification

AWS Certified Solutions Architect – Associate (SAA-C03)
Verify: https://www.credly.com/badges/cf70d059-7c42-4f3a-bfd0-40b988722ab3/public_url