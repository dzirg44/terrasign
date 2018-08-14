[
  {
    "name": "${container_name}",
    "image": "${container_image}",
    "cpu": ${container_cpu},
    "memory": ${container_mem},
    "memoryReservation": ${container_mem_res},
    "command": [
      "--defaultentrypoints=http",
      "--entrypoints=Name:http Address::80",
      "--entrypoints=Name:web Address::8080",
      "--ecs",
      "--ecs.trace",
      "--ecs.exposedbydefault=false",
      "--ecs.region=${container_cluster_region}",
      "--ecs.clusters=${container_cluster_name}",
      "--ecs.watch",
      "--api",
      "--api.statistics",
      "--api.dashboard",
      "--api.entrypoint=web",
      "--ping",
      "--ping.entrypoint=http"
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${container_log_group}",
        "awslogs-region": "${container_log_region}"
      }
    },
    "portMappings": [
    {
      "containerPort": ${container_port_http},
      "hostPort": ${container_port_http}
    },
    {
      "hostPort": ${container_port_web},
      "containerPort": ${container_port_web},
      "protocol": "tcp"
    }]
  }
]
