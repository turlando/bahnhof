{ ... }:

let
  password = "$6$gUwMN4iOlxUpdxOG$xb6fW602zgvJQntGYyYit1kMYJ15uhEhIJbC2rr8TqU2QqpDyfT5mA0EBhAuhlzCxoB3FXzaiAC1xZLv.I5J6/";
in
{
   security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults lecture="never"
    '';
  };

   users = {
     mutableUsers = false;
     users = {
       root = {
         hashedPassword = password;
       };
       tancredi = {
         isNormalUser = true;
         hashedPassword = password;
         extraGroups = [ "wheel" ];
       };
     };
   };
}
