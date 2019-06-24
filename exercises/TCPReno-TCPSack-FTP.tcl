set nsim [new Simulator]
set nfile [open TCPReno-TCPSack-FTP.nam w]
set tfile [open TCPReno-TCPSack-FTP.tr w]

$nsim namtrace-all $nfile
$nsim trace-all $tfile

$nsim color 1 Green
$nsim color 2 Purple

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

### FTP - TCPSack - TCPSink ###
set tcpsack [new Agent/TCP/Sack1]
set sink1 [new Agent/TCPSink]
set ftp1 [new Application/FTP]

$nsim attach-agent $n(1) $tcpsack
$nsim attach-agent $n(4) $sink1
$nsim connect $tcpsack $sink1
$ftp1 attach-agent $tcpsack
$ftp1 set type_ FTP
$tcpsack set fid_ 1

### FTP - TCPReno - TCPSink ###
set tcpreno [new Agent/TCP/Reno]
set sink0 [new Agent/TCPSink]
set ftp0 [new Application/FTP]

$nsim attach-agent $n(0) $tcpreno
$nsim attach-agent $n(3) $sink0
$nsim connect $tcpreno $sink0
$ftp0 attach-agent $tcpreno
$ftp0 set type_ FTP
$tcpreno set fid_ 2

# Agenda os eventos para os agentes CBR e FTP
$nsim at 0.1 "$ftp0 start"
$nsim at 1.0 "$ftp1 start"
$nsim at 4.0 "$ftp1 stop"
$nsim at 4.5 "$ftp0 stop"
$nsim at 5.0 "finish"

proc finish {} {
    global nsim nfile tfile
    $nsim flush-trace
    close $nfile
    close $tfile
    exec nam TCPReno-TCPSack-FTP.nam &
    exit 0
}

$nsim at 5.0 "finish"
$nsim run