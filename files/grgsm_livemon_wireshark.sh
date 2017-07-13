#!/usr/bin/env bash

wireshark -k -f udp -Y gsmtap -i lo &
grgsm_livemon
