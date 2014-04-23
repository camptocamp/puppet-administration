class administration::users (
  $users,
) {

  create_resources(
    'administration::user',
    $users
  )

}
