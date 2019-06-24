set nsim [new Simulator]
set nfile [open FTP-TCP_CBR-UDP.nam w]
set tfile [open FTP-TCP_CBR-UDP.tr w]

$nsim namtrace-all $nfile
$nsim trace-all $tfile

$nsim color 1 Blue
$nsim color 2 Green

for {set i 0} {$i < 5} {incr i} {
    set n($i) [$nsim node]
}

$nsim duplex-link $n(0) $n(2) 2.5Mb 10ms DropTail
$nsim duplex-link $n(1) $n(2) 2.0Mb 10ms DropTail
$nsim duplex-link $n(3) $n(2) 1.5Mb 20ms DropTail
$nsim duplex-link $n(4) $n(2) 1.0Mb 20ms DropTail

$nsim duplex-link-op $n(0) $n(2) orient right-down
$nsim duplex-link-op $n(1) $n(2) orient right-up
$nsim duplex-link-op $n(2) $n(3) orient right-up
$nsim duplex-link-op $n(2) $n(4) orient right-down

### FTP - TCP - TCPSink ###
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
set ftp [new Application/FTP]

$nsim attach-agent $n(0) $tcp
$nsim attach-agent $n(3) $sink
$nsim connect $tcp $sink
$ftp attach-agent $tcp
$ftp set type_ FTP
$tcp set fid_ 1

### CBR - UDP - Null ###
set udp [new Agent/UDP]
set null [new Agent/Null]
set cbr [new Application/Traffic/CBR]

$nsim attach-agent $n(1) $udp
$nsim attach-agent $n(4) $null
$nsim connect $udp $null
$cbr attach-agent $udp
$cbr set rate_ 1mb
$udp set fid_ 2

# Agenda os eventos para os agentes CBR e FTP
$nsim at 0.1 "$cbr start"
$nsim at 1.0 "$ftp start"
$nsim at 4.0 "$ftp stop"
$nsim at 4.5 "$cbr stop"
$nsim at 5.0 "finish"

proc finish {} {
    global nsim nfile tfile
    $nsim flush-trace
    close $nfile
    close $tfile
    exec nam FTP-TCP_CBR-UDP.nam &
    exit 0
}

$nsim at 5.0 "finish"
$nsim run