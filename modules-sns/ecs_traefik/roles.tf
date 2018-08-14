resource "aws_iam_role" "task" {
  name               = "${var.cluster_name_ecs_out}-task-ingress_traefik"
  assume_role_policy = "${data.aws_iam_policy_document.task_role.json}"
}

resource "aws_iam_role_policy_attachment" "task" {
  role       = "${aws_iam_role.task.name}"
  policy_arn = "${aws_iam_policy.task.arn}"
}

resource "aws_iam_policy" "task" {
  name        = "${var.cluster_name_ecs_out}-task-ingress_traefik"
  description = "Allow ECS task to call AWS APIs"
  policy      = "${data.aws_iam_policy_document.task_policy.json}"
}

data "aws_iam_policy_document" "task_role" {
  statement {
    sid     = "ECSTaskRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals = {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
// FOR autodiscovery
data "aws_iam_policy_document" "task_policy" {
  statement {
    sid    = "ECSTaskPolicyKMS"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
    ]

    resources = [
      "${var.kms_master_key_arn_vpc_out}",
    ]
  }

  statement {
    sid    = "ECSReadAccess"
    effect = "Allow"

    actions = [
      "ecs:ListClusters",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeClusters",
      "ecs:ListTasks",
      "ecs:DescribeTasks",
      "ecs:DescribeTaskDefinition",
      "ec2:DescribeInstances",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "ECSTaskPolicy"
    effect = "Allow"

    actions = [
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.cluster_name_ecs_out}-ingress_traefik-*",
    ]
  }
}
