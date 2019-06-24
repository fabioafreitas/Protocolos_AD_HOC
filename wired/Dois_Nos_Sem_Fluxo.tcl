set nsim [new Simulator]
set nfile [open Dois_Nos_Sem_Fluxo.nam w]
$nsim namtrace-all $nfile

proc finish {} {
    global nsim nfile
    $nsim flush-trace
    close $nfile
    exec nam Dois_Nos_Sem_Fluxo.nam &
    exit 0
}
#### begin ####

#criando os nós
set n0 [$nsim node]
set n1 [$nsim node]

#conectando nós
$nsim duplex-link $n0 $n1 1Mb 10ms DropTail

#criando agente UDP, onde os pacotes irão surgir
#set udp0 [new Agent/UDP]
#$nsim attach-agent $n0 $udp0

#criando CBR que criará os pacotes e ligando-o ao agente UDP
#set cbr0 [new Application/Traffic/CBR]
#$cbr0 set packetSize_ 500
#$cbr0 set interval_ 0.005
#$cbr0 attach-agent $udp0

#criando sink node e atribuindo-o ao nó 1
#set null0 [new Agent/Null]
#$nsim attach-agent $n1 $null0 

# conectando agente udp e sink node
#$nsim connect $udp0 $null0

#$nsim at 0.5 "$cbr0 start"
#$nsim at 4.5 "$cbr0 stop"


####  end  ####
$nsim at 5.0 "finish"
$nsim run