let
  grizz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKTLL5wSXhZy7KUG5JyNd4mRN4LkuNuxfF2+tqi3GZAN"; # github key
  clevo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKr/E+b1blPUrx20mHSfA65tdwJctB6T2FcxxUFgd+iT";
in
{
  "wpa_passwords.age".publicKeys = [ grizz clevo ];
}
