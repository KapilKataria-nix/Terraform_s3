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

resource "aws_s3_bucket_website_configuration" "example" {

    bucket = aws_s3_bucket.mybucket

    index_document {
      suffix = "index.html"
    }
  
}




