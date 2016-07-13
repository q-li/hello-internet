open V1_LWT

let (>>=) = Lwt.bind

module Client = Cohttp_mirage.Client

module Main (C: CONSOLE) (RES: Resolver_lwt.S) (CON: Conduit_mirage.S) (CLO: V1.CLOCK) = struct

    module Logs_reporter = Mirage_logs.Make(Clock)

    let uri = Uri.of_string "http://www.google.com/"

    let start console resolver conduit _ =
      Logs.(set_level (Some Debug));
      Logs_reporter.(create () |> run) @@ fun () ->

      OS.Time.sleep 3.0 >>= fun () ->
      C.log_s console "i wake up >>>" >>= fun () ->

      let ctx = Client.ctx resolver conduit in
      Client.get ~ctx uri >>= fun (res, _) ->
      let headers = Cohttp.Response.headers res in
      let f (k, v) =
        let l = Printf.sprintf "%s: %s" k v in
        C.log_s console l in
      Lwt_list.iter_s f (Cohttp.Header.to_list headers)
end
