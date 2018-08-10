
output "security_group_id" {
    value = "${module.fastweather_service_sg.id}"
}
 
output "fastweather_elb_target_group_arn" {
    value = "${module.fastweather_elb_target_group.arn}"
}
