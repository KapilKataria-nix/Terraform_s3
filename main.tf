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

#Uploading index file in a bucket
resource "aws_s3_bucket" "index" {
    bucket = aws_s3_bucket.mybucket.id
    key = "index.html"
    source = "index.html"
    acl = "public-read"
    content_type = "text/html"
  
}

#Uploading error file in a bucket
resource "aws_s3_bucket" "error" {
    bucket = aws_s3_bucket.mybucket.id
    key = "error.html"
    source = "error.html"
    acl = "public-read"  
}

#Uplaoding image folder
resource "aws_s3_bucket" "image" {
    for_each = fileset("images/","*")
    bucket = aws_s3_bucket.mybucket.id
    key = each.value
    source = "images/${each.value}"
    etag = filemd5("images/${each.value}")
  
}
