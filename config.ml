open Mirage

(*let stack = direct_stackv4_with_default_ipv4 (netif "0")*)
(*let stack = generic_stackv4 tap0*)
(*let stack = direct_stackv4_with_dhcp default_console (netif "0")*)
(*let ip_config =
  let i = Ipaddr.V4.of_string_exn in
  {
    address =  i "192.168.252.3";
    netmask = i "255.255.255.0";
    gateways = [i "192.168.252.2"]
  }
  *)

let stack = generic_stackv4 default_console (netif "0")

let res = resolver_dns stack
let con = conduit_direct stack

let () =
  let packages = ["mirage-http"] in
  let libraries = ["mirage-http"] in
  register "hello" ~libraries [
    foreign "Unikernel.Main" (console @-> resolver @-> conduit @-> clock @-> job)
    $ default_console $ res $ con $ default_clock
  ]
