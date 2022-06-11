resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "jb-recipes-app-codepipeline-bucket"
}

resource "aws_codestarconnections_connection" "recipes_github_connection" {
  name          = "recipes_github_connection"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "recipes_app_codepipeline" {
  name     = "recipes_app_codepipeline"
  role_arn = aws_iam_role.recipes_codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      output_artifacts = ["source_output"]
      version          = "1"

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.recipes_github_connection.arn
        FullRepositoryId = "jamiebuckley/recipesapp"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "rails_recipe_app_codebuild"
      }
    }
  }
}
