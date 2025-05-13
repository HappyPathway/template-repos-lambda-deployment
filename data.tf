data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

# data "dns_a_record_set" "github" {
#   host = "github.e.it.census.gov"
# }