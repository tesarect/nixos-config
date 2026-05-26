{ config, pkgs, ... }:

{ networking.extraHosts = ''
192.168.88.247 ntpserv.local

'';
}
