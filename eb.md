# Get up and running with AWS Elastic Beanstalk
## Prerequisites
1. An AWS account in which you have full EB permissions (ElasticLoadBalancingFullAccess, AWSElasticBeanstalkFullAccess, and iam:CreateServiceLinkedRole)
2. [AWS EB CLI (if you aren't using the AWS web console)](https://github.com/aws/aws-elastic-beanstalk-cli-setup)

### Set up EB user (skip if you already have an IAM User with the following Roles and Policy)
#### Create an IAM Group with the following Roles:
1. ElasticLoadBalancingFullAccess
2. AWSElasticBeanstalkFullAccess
3. Add an inline Policy for the service linked role:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iam:CreateServiceLinkedRole",
      "Resource": "arn:aws:iam::*:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing*",
      "Condition": {
        "StringLike": {
          "iam:AWSServiceName": "elasticloadbalancing.amazonaws.com"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:AttachRolePolicy",
        "iam:PutRolePolicy"
      ],
      "Resource": "arn:aws:iam::*:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing*"
    }
  ]
}
```
#### Create a user and add them to the group above

### Use the AWS EB CLI to create and activate the Environment
```bash
$ cd stelligent
# Initialize the folder, creating .elasticbeanstalk/ folder for configs
$ eb init --profile eb --platform "64bit Amazon Linux 2018.03 v2.10.1 running Ruby 2.6 (Puma)" stelligent
# Create an environment (this will also deploy the EB stack!)
$ eb create stelligent-$(ENVIRONMENT_SUCH_AS_DEV_OR_PROD) #For example, "eb create stelligent-dev"
# Make changes, add them to the git repo, etc., and then:
# Deploy the code to your environment
$ eb deploy
```

## Reference: AWS eb CLI instructions
> Install using latest instructions at https://docs.aws.amazon.com/cli/latest/userguide/installing.html

> Handy cheatsheet for the `eb` commands specifically: https://github.com/jacquesfu/aws-eb-cli-cheatsheet
