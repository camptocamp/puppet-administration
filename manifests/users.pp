# @summary Creates users from a hash of user resources
# @param users Hash of user resources
class administration::users (
  String $users = undef,
) {
  create_resources (
    'administration::user',
    $users
  )
}
