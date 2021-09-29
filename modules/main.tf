resource "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"
  lifecycle_rule {
    id      = "file"
    enabled = true

    expiration {
      days = 1
    }
    noncurrent_version_expiration {
      days = 1
    }
  }
}
resource "null_resource" "kube_config"{

  provisioner "local-exec" {
    command = "kubectl config use-context ${var.clusterid}"
  }   
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    annotations = {
      name = "default-annotation"
    }

    labels = {
      environment = var.environment
    }

    name = var.namespace_name
  }
  depends_on = [null_resource.kube_config]

}
resource "null_resource" "kube_exec"{
  provisioner "local-exec" {
    command = "helm install ${var.environment}-python-app-s3 . -f ${var.environment}/values.yaml"
  }
  depends_on = [kubernetes_namespace.namespace]
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
	}
}
provider "kubernetes" {
  config_path = "~/.kube/config"

}
provider "aws" {
  region  = "us-west-2"
}

terraform {
  required_version = ">= 0.15"
}
variable s3_bucket_name{
   default = "qa-gopibhaskar-papanaboina-platform-challenge"
}
variable namespace_name{
   default = "qa-ns"
}

variable environment{
   default = "qa"
}

variable clusterid{
   default = "minikube"
}