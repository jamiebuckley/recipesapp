data "aws_iam_policy_document" "code-build-instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "code-pipeline-instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "recipes_codebuild_role" {
  name = "recipes_codebuild_role"
  assume_role_policy = data.aws_iam_policy_document.code-build-instance-assume-role-policy.json
}

resource "aws_iam_role_policy" "recipes_codebuild_policy" {
  name = "recipes_codebuild_policy"
  role = aws_iam_role.recipes_codebuild_role.id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow",
        Resource = [
          "*"
        ]
      },
      {
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObjectAcl",
          "s3:PutObject"
        ]
        Effect   = "Allow",
        Resource = [
          aws_s3_bucket.codepipeline_bucket.arn,
          "${aws_s3_bucket.codepipeline_bucket.arn}/*"
        ]
      },
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchCheckLayerAvailability"
        ]
        Effect = "Allow"
        Resource = [
          "*"
        ]
      }
    ]
  })
}



resource "aws_iam_role" "recipes_codepipeline_role" {
  name = "recipes_codepipeline_role"
  assume_role_policy = data.aws_iam_policy_document.code-pipeline-instance-assume-role-policy.json
}

resource "aws_iam_role_policy" "recipes_codepipeline_policy" {
  name = "recipes_codepipeline_policy"
  role = aws_iam_role.recipes_codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObjectAcl",
          "s3:PutObject"
        ]
        Effect   = "Allow",
        Resource: [
          aws_s3_bucket.codepipeline_bucket.arn,
          "${aws_s3_bucket.codepipeline_bucket.arn}/*"
        ]
      },
      {
        Action = [
          "codestar-connections:UseConnection"
        ],
        Effect = "Allow",
        Resource = [
          aws_codestarconnections_connection.recipes_github_connection.arn
        ]
      },
      {
        Action = [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds"
        ],
        Effect = "Allow",
        Resource = [
          "*"
        ]
      }
    ]
  })
}