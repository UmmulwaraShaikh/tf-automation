module "infra_services" { 
source = "../modules/services/infra_services"
test_vpc = "dev_tf_vpc"
vpc_cidr = "172.31.0.0/16"
subnet_public_cidrs = ["172.31.1.0/24","172.31.3.0/24"]
subnet_private_cidrs = ["172.31.2.0/24","172.31.4.0/24"]
instance_count = 1
instance_key_name = "ummu-key"
instance_type = "t2.micro"
vol_size = 8
bucket_name = "ummu-bucket-test"
cloud_env = "dev"
}
