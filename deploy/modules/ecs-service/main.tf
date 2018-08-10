terraform {
    required_version = ">= 0.9.3"
}
resource "aws_ecs_cluster" "fastweather" {
    
    name = "fastweather"

}

resource "aws_ecs_task_definition" "fastweather" {
  family                = "fastweather"
  container_definitions = "${file("task-definitions/fastweather.json")}"

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}

resource "aws_ecs_service" "fastweather" {
  name            = "fastweather"
  cluster         = "${aws_ecs_cluster.fastweather.id}"
  task_definition = "${aws_ecs_task_definition.fastweather.arn}" //To-Define
  desired_count   = 3
  iam_role        = "${aws_iam_role.fastweather.arn}" //To-Define
  depends_on      = ["aws_iam_role_policy.foo"]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.foo.arn}"
    container_name   = "mongo"
    container_port   = 8080
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}