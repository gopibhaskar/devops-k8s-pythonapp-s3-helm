# devops-k8s-pythonapp-s3-helm
Creating Python flask app with S3 upload option and deploying it to Kubernetes

This is for creating the python application which sends files to multiple S3 buckets(i.e different environments like dev,qa,staging,prod..) and Also Option to Upload files to s3 by giving the filepath.The app pod restarts every 5minutes by using liveness(you can change/remove this to your needs)


**#Requirements:**
We need to have:

kubenertes

minikube(if you want to deploy it in localmachine)

helm

terraform >= 0.15.0(I tested with both 0.15.0 and latest(1.0.7)

python >= 3.x (if you want check app in your local)

git(to clone this repository :p )


**#Description of the deployment:**

Once you have installed all the required tools mentioned in requirements. You can clone this repository by using below command:
git clone -b main https://github.com/gopibhaskar/devops-k8s-pythonapp-s3-helm.git
Once the repository is cloned, it will create devops-k8s-pythonapp-s3-helm directory. Change directory to that.
Here I have used modules to create modules and namespace. If you want to modify namespace values and add new environments, you can keep on adding modules entries in main.tf under main directory.
Here module refers to environment (I created two environments: qa and staging).
To automate I have added helm stuff terraform resources itself.
In this, I used my own created small helm chart. 
For the values, I have differentiated with environments by creating environment folder and placing the values.yaml under environments folder. i.e.
qa/values.yaml , staging/values.yaml
If you want to change values for environment specific you can simply modify or to add new environment, you can add folder under root directory and add entries in main.tf (main directory).
I have used livenessprobe to restart my pod automatically. But we can also use CronJob like below:

apiVersion: batch/v1
kind: CronJob
metadata:
  name: python-s3push
  namespace: {{ .Values.namespace }}
spec:
  schedule: "*/5 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
      - name: python-s3
        image: python:latest
    ports:
    - containerPort: 5000
    env:
    - name: S3Bucket
      value: {{ .Values.bucket_name }}
    - name: Environment
      value: {{ .Values.environment }}
    - name: NAME
      value: "Kubernetes"
    command:
      - sh
      - "-c"
      - |
        /bin/bash <<'EOF'
        pip install boto3
        pip install flask
        cat /opt/app.py
        python /opt/app.py
        echo "Script completed"
        EOF
    livenessProbe:
      tcpSocket:
        port: 5000
      initialDelaySeconds: 30
      periodSeconds: 300
    livenessProbe:
      exec:
        command:
        - exit $(sleep 360;echo 1)
      failureThreshold: 1
      initialDelaySeconds: 60
      periodSeconds: 60
    volumeMounts:
    - name: python-app
      mountPath: /opt/app.py
      subPath: app.py
  volumes:
  - name: python-app
    configMap:
      name: python-app
      items:
        - key: app.py
          path: app.py


**#Deployment Steps:**

git clone -b main https://github.com/gopibhaskar/devops-k8s-pythonapp-s3-helm.git

cd devops-k8s-pythonapp-s3-helm

terraform init

terraform plan

terraform apply --auto-approve



#Validation Steps:

kubectl get all -n <namespace_name>

helm list

kubectl get svc -n <namespace_name>

Open the url in browser to check if the app is working fine or not. 
