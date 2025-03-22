#--------------step by step flow-----------------
# 🟠 Scenario 2: Using Terraform to Request ACM

# 👤 You: "Hey AWS, I need an SSL certificate! i created a acm cerificate resource through terraform"
# ☁️ AWS: "Sure! Prove it by adding this DNS record."
# 👤 You: "Terraform, add this DNS record in Route 53."
# 🖥 Terraform: "Done! The record is there."
# 👤 You: "Hey AWS, you see it now, right?"
# ☁️ AWS: "Uh… I don’t check automatically in Terraform mode. 😶"[ if i create with console , aws automatically validates ]
# 👤 You: "Bro, what?!"
# 🖥 Terraform: "Chill, I’ll force AWS to check using aws_acm_certificate_validation!"
# 👤 You: "Ohhh, so I need to manually trigger the check in Terraform?"
# 🖥 Terraform: "Exactly!" ✅ 





# TO CREATE CERTIFICATE 
resource "aws_acm_certificate" "https" {
  domain_name       = "*.rohanandlife.site"
  validation_method = "DNS"

  tags = {
    Environment = "dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}


#TO ADD THE RECORD INTO OUR ROUTE53 RECORD ; acm also adds its own cname record to verify; total 2 records

resource "aws_route53_record" "certification_validation" {
  for_each = {
    for dvo in aws_acm_certificate.https.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60 #💡 Use a lower TTL (like 60s) for frequently changing records, and a higher TTL (like 86400s) for stable records! 🚀
  type            = each.value.type
  zone_id         = var.zone_id
}

# ಆ certificate ಅಲ್ಲಿ ಇರೋ ಎರಡು dns records ನ for_each ಮೂಲಕ ಒಂದೊಂದೇ route53 ಗೆ ಹಾಕುತ್ತೆ. 

# we need to trigger validation by writing the below block ; 
# -----> creating with aws console wont need this step; required only when creating with terraform
# -----> aws automatically validates when created with console

resource "aws_acm_certificate_validation" "expense" {
  certificate_arn         = aws_acm_certificate.https.arn
  validation_record_fqdns = [for record in aws_route53_record.certification_validation : record.fqdn]
}



