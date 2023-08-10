#Creating a bucket
resource "aws_s3_bucket" "mybucket" {
    bucket = var.bucket

}
#Making user tehe Owner
resource "aws_s3_bucket_ownership_controls" "example" {
    bucket = aws_s3_bucket.mybucket.id

    rule {
      object_ownership = "BucketOwnerPreferred"
    }
}

#Giving public access to the bucket
resource "aws_s3_bucket_public_access_block" "example" {

    bucket = aws_s3_bucket.mybucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
  
}

#Provides an S3 bucket ACL resource.

resource "aws_s3_bucket_acl" "example" {
    depends_on = [ 
        aws_s3_bucket_ownership_controls.example,
        aws_s3_bucket_public_access_block.example,
     ]

    bucket = aws_s3_bucket.mybucket.id
    acl = "public-read"
}

#Uploading index file in a bucket (Object)
resource "aws_s3_object" "index" {
    bucket = aws_s3_bucket.mybucket.id
    key = "index.html"
    source = "A:\\Devops\\Terraform-S3\\index.html"
    acl = "public-read"
    content_type = "text/html"
}

#Uploading error file in a bucket (Object)
resource "aws_s3_object" "error" {
    bucket = aws_s3_bucket.mybucket.id
    key = "error.html"
    source = "A:\\Devops\\Terraform-S3\\error.html"
    acl = "public-read"   
}

#Uplaoding image folder (Object)
resource "aws_s3_object" "image" {
    for_each = fileset("A:\\Devops\\Terraform-S3\\images\\","*")
    bucket = aws_s3_bucket.mybucket.id
    key = each.value
    source = "A:\\Devops\\Terraform-S3\\images\\${each.value}"
    etag = filemd5("A:\\Devops\\Terraform-S3\\images\\${each.value}")
    acl = "public-read"
}

#Uploading js folder (Object)
resource "aws_s3_object" "js" {
    bucket = aws_s3_bucket.mybucket.id
    key = "script.js"
    source = "A:\\Devops\\Terraform-S3\\script.js"
    acl = "public-read"
    content_type = "text/javascript"
   
}

#Uploading css folder (Object)
resource "aws_s3_object" "css" {
    bucket = aws_s3_bucket.mybucket.id
    key = "style.css"
    source = "A:\\Devops\\Terraform-S3\\style.css"
    acl = "public-read"
    content_type = "text/css"
}

#Website Hosting
resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.mybucket.id
    index_document {
      suffix = "index.html"

    }
    
    error_document {
      key  = "error.html"
    }

    depends_on = [ aws_s3_bucket_acl.example ]
}
