
data "template_file" "buildspec" {
  template = file("../buildspec.yml")
  vars = {
    ECR_ARN = data.terraform_remote_state.k8s.outputs.ecr_repository
  }
}

resource "aws_codebuild_project" "rails_app_docker_build" {
  service_role   = aws_iam_role.recipes_codebuild_role.arn
  build_timeout  = 60
  name = "rails_recipe_app_codebuild"
  queued_timeout = 300

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-aarch64-standard:2.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "ARM_CONTAINER"

    environment_variable {
      name  = "ECR_ARN"
      type  = "PLAINTEXT"
      value = data.terraform_remote_state.k8s.outputs.ecr_repository
    }
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    buildspec           = data.template_file.buildspec.rendered
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
  }

  artifacts {
    encryption_disabled    = false
    name                   = "rails-build"
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }
}