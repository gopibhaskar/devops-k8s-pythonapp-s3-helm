module "qa" {
  source = "./modules/"
  s3_bucket_name = "qa-gopibhaskar-papanaboina-platform-challenge"
  namespace_name = "qa-ns"
  environment = "qa"
  clusterid = "minikube"
}
module "staging" {
  source = "./modules/"
  s3_bucket_name = "staging-gopibhaskar-papanaboina-platform-challenge"
  namespace_name = "staging-ns"
  environment = "staging"
  clusterid = "minikube"
}