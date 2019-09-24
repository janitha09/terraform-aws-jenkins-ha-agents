bastion_sg_name = "launch-wizard-2"

# contact = "admin@foo.io"

domain_name = "foo.io."

# environment = "prod"

private_subnet_name = "non-prod-pe-intra-us-west-2b"

public_subnet_name = "non-prod-pe-intra-us-west-2a"

r53_record = "jenkins.foo.io"

region = "us-west-2"

ssl_certificate = "*.foo.io"

ssm_parameter = "/jenkins/foo"

vpc_name = "non-prod-pe"

admin_password = "admin"

  tags = {
    contact     = "Janitha"
    environment = "Janitha_Jenkins"
  }
