#Variaveis dos nodes Wireless
set val(rp) DSR;                       # Protocolos de roteamento
set val(nn) 12 ;                        # Numero de nodes moveis
set val(speed) 1 ;                      # Velocidade dos nodes (m/s)
set val(x) 500 ;                        # Dimensao X da topologia
set val(y) 500 ;                        # Dimensao Y da topologia
set val(stop) 100 ;                     # Tempo de simulação
set val(chan) Channel/WirelessChannel ; # Tipo de canal
set val(prop) Propagation/TwoRayGround ;# Modelo de propagacao de radio
set val(netif) Phy/WirelessPhy ;        # Tipo de interface de rede
set val(mac) Mac/802_11 ;               # Tipo da camada MAC
set val(ifq) Queue/DropTail/PriQueue ;  # Tipo de interface de fila
set val(ll) LL ;                        # Tipo da camada de link LL
set val(ant) Antenna/OmniAntenna ;      # Modelo de antena
set val(ifqlen) 50 ;                    # Tamanho maximo de pacotes ifq
set val(intervaloCBR) 0.1 ;
set val(pacoteCBR) 512kb ;
set val(timeDirection) 10 ;

set nsim [new Simulator]
set nfile [open DSDV.nam w]
$nsim namtrace-all-wireless $nfile $val(x) $val(y)

set tfile [open DSDV.tr w]
$nsim trace-all $tfile

# define objeto de topografia
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

# configura os nodes
$nsim node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channelType $val(chan) \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace OFF \
-movementTrace ON
########################## BEGIN ##################################

#Cria e posiciona os nodes randomicamente
for {set i 0} {$i < $val(nn) } { incr i } {
        set n($i) [$nsim node]
        set xx [expr rand()*$val(x)]
        set yy [expr rand()*$val(y)]
        $n($i) set X_ $xx
        $n($i) set Y_ $yy
        $n($i) set Z_ 0.0
        #Defininindo posicao dos nodes no .nam
        $nsim initial_node_pos $n($i) 30
}

#Chamando procedimento para determinar o destino final dos nodes
$nsim at 0.0 "direcaoNodes"

#Criando mecanismos de comunicacao entre os nodes
$nsim color 1 Blue
for {set i 0} {$i < $val(nn) / 2} {incr i} {
        #define nodes e agentes destino e origem
        set origin [expr $i]
        set destiny [expr $val(nn) - $i - 1]
        
        #Criando agentes responsaveis por enviar e receber pacotes
        set cbr [new Application/Traffic/CBR]
        set udp [new Agent/UDP]
        set sink [new Agent/Null]

        #configurando roteamento entre os nodes
        $nsim attach-agent $n($origin) $udp
        $nsim attach-agent $n($destiny) $sink
        $nsim connect $udp $sink
        $cbr attach-agent $udp
        $cbr set packetSize_ $val(pacoteCBR)
        $cbr set interval_ $val(intervaloCBR)

        #Definindo cores para os nodes
        $n($origin) color green
        $nsim at 0.0 " $n($origin) color green"
        $n($destiny) color red
        $nsim at 0.0 " $n($destiny) color red"
        $udp set class_ 1

        $nsim at 0.1 "$cbr start"
        $nsim at [expr $val(stop) - 0.1] "$cbr stop"
}

# Indicando quando os nodes devem ser resetados
for {set i 0} {$i < $val(nn) } { incr i } {
        $nsim at $val(stop) "$n($i) reset";
}

########################## END ##################################
#Determina o destino randomico para cada node
#Muda a direcao dos nodes a cada 10 segundos
proc direcaoNodes {} {
        global nsim val n
        set time $val(timeDirection)
        set now [$nsim now]
        for {set i 0} {$i<$val(nn)} {incr i} {
                set xx [expr rand()*$val(x)]
                set yy [expr rand()*$val(y)]
                $nsim at $now "$n($i) setdest $xx $yy $val(speed)"
        }
        #Mudando a direcao recursivamente
        $nsim at [expr $now+$time] "direcaoNodes"
}

# Define um procedimento 'finish'
proc finish {} {
        global nsim nfile tfile
        $nsim flush-trace
        close $nfile
        close $tfile
}


$nsim at $val(stop) "$nsim nam-end-wireless $val(stop)"
$nsim at $val(stop) "finish"
$nsim at 100.01 "puts \"end simulation\" ; $nsim halt"

$nsim run
