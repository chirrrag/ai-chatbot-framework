/*
// Group Creation and Policy Association are done outside
// Adding user to a group would be like below
// Each group will have a module ref and list of users

module "infra-terraform-users" {
 source = "./modules/iam-user-group-association"
 group = "terraform-users"
 users = ["jebu","rahul"]
}
*/

variable "users" {}
variable "group" {}

data "aws_iam_group" "iam_group" {
  name = var.group
}

resource "aws_iam_group_membership" "group_attachment" {
  users = var.users
  group = data.aws_iam_group.iam_group.name
}

