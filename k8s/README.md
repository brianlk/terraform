# Deploy Ctrl platform infrastructure in Kubernetes

## 1. Prerequisites:

* Install AWS CLI on Linux host

* Configure the AWS CLI using ```aws configure```

* Install terraform  https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

* Install kubectl tool https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/


## 2. Deploy the EKS cluster
> ### Procedures

* Run ```git clone``` to clone the source code

* Modify the variables in the file terraform.tfvars

* Run ```AWS_PROFILE=Ctrl-infrastructure terraform workspace new test_prod_us-east-1``` to create a new workspace for each client

* Run ```./run-terraform.sh test_prod_us-east-1 -p ``` to create the plan

* Run ```./run-terraform.sh test_prod_us-east-1 -a``` to apply the plan

### Result

	Apply complete! Resources: 73 added, 0 changed, 0 destroyed.
	Outputs:
	result = "The kubeconfig is written to /root/.kube."

After the terraform finsihes, the K8s, RDS and MongoDB will be installed.


## 3. Setup IAM User to authenticate in EKS

AWS IAM user | K8s role binding | K8s cluster role binding | Permissions |
--- | --- | --- | --- |
brianl | developer | developer | [developer-role](deployments/add-user-role/add-developer-role.yaml) |

> ### As system administrator,

* Add a user with API permission in AWS console

* Assign 'DescribeCluster' policy to the user

		source venv/bin/activate
		cd create_user_scripts
		./add_aws_policy.py --username brianl

* Add the user into K8s configMap aws-auth and Role Binding

		./add_user_to_k8s.py --username brianl
		Username brianl is added into configMap aws-auth
		Username brianl is added into ClusterRoleBinding developer
		Username brianl is added into RoleBinding developer


> ### As user,

* Install AWS CLI https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

* Create API credentials in AWS console

* Configure the AWS CLI

		aws configure

* Install kubectl command https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

* Get kubeconfig from EKS

		aws eks update-kubeconfig --region region-code --name cluster-name

* Test kubectl command

		kubectl get nodes


## 4. Container Information

K8s Deployment | K8s service account | AWS role |
--- | --- | --- |
Rabbit MQ | ctrl-aws-access-sa | ${tenant}-${environment}-eks-ctrl-aws-access-role |
Ctrl-gateway | ctrl-aws-access-sa | ${tenant}-${environment}-eks-ctrl-aws-access-role  |
Pyauth | ctrl-aws-access-sa | ${tenant}-${environment}-eks-ctrl-aws-access-role |
Mqttserver | ctrl-aws-access-sa | ${tenant}-${environment}-eks-ctrl-aws-access-role |
Ctrl-management | ctrl-aws-access-sa | ${tenant}-${environment}-eks-ctrl-aws-access-role |
Mqtt-proxy | ctrl-aws-access-sa | ${tenant}-${environment}-eks-ctrl-aws-access-role |
Mqtt-broker | ctrl-aws-access-sa | ${tenant}-${environment}-eks-ctrl-aws-access-role |
Redis | ctrl-aws-access-sa |  ${tenant}-${environment}-eks-ctrl-aws-access-role |
Ctrl-portal | ctrl-aws-access-sa | ${tenant}-${environment}-eks-ctrl-aws-access-role |

Services | K8s Deployment/StatefulSet | Allow Internet traffic |
--- | --- | --- |
Rabbit MQ | ctrl-rabbitmq | N/A |
Ctrl gateway | ctrl-gateway | 0.0.0.0/0:80,443, ::/0:443 |
Pyauth | ctrl-pyauth | N/A |
Mqttserver | ctrl-mqttserver | N/A | 
Ctrl management | ctrl-management | N/A |
Mqtt-proxy |  ctrl-mqtt-proxy | 0.0.0.0/0:443,80,9883,1883,8883,3002 |
Mqtt-broker | ctrl-mqtt-broker | N/A |
Redis | ctrl-redis | N/A |
Ctrl-portal | ctrl-portal | 0.0.0.0/0:443,80, ::/0:443 |
Lorabridge | ctrl-lorabridge | N/A |


## 5. Add Deployments

* Add K8s Role and ClusterRole (Optional)

		kubectl apply -f deployments/add-user-role/add-developer-role.yaml

* Bind users to K8s Role (Optional)

		kubectl apply -f deployments/add-user-role/bind-user-role.yaml

* RabbitMQ cluster provisioning

		helm repo add bitnami https://charts.bitnami.com/bitnami
		helm install rabbitmq-cluster-operator bitnami/rabbitmq-cluster-operator -n ctrl-apps --create-namespace
		kubectl apply -f deployments/rabbitmq-cluster/rabbitmq-cluster.yaml
		kubectl -n ctrl-apps get secret INSTANCE-default-user -o jsonpath="{.data.username}" | base64 --decode
		kubectl -n ctrl-apps get secret INSTANCE-default-user -o jsonpath="{.data.password}" | base64 --decode

* Kubernetes dashboard

		kubectl --kubeconfig ctrl-hkstage-config apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
		kubectl -n kubernetes-dashboard rollout status deployment/kubernetes-dashboard
		kubectl -n kubernetes-dashboard patch svc kubernetes-dashboard -p='{"spec": {"type": "LoadBalancer"}}' --kubeconfig ctrl-hkstage-config
		kubectl --kubeconfig ctrl-hkstage-config get svc -n kubernetes-dashboard

ctrl-gateway, lorabridge, mqtt-proxy, mqttserver, mqtt-broker, pyauth, postgres, redis, rabbitmq, mongodb started successfully.
