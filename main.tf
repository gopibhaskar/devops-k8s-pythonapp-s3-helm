module "qa" {
  source = "./modules/"
  s3_bucket_name = "qa-gopibhaskar-papanaboina-platform-challenge"
  namespace_name = "qa-ns"
  environment = "qa"
}
module "staging" {
  source = "./modules/"
  s3_bucket_name = "staging-gopibhaskar-papanaboina-platform-challenge"
  namespace_name = "staging-ns"
  environment = "staging"
}