#Variaveis dos nodes Wireless
set val(chan) Channel/WirelessChannel ; # channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model
set val(netif) Phy/WirelessPhy ;        # network interface type
set val(mac) Mac/802_11 ;               # MAC type
set val(ifq) Queue/DropTail/PriQueue ;  # interface queue type
set val(ll) LL ;                        # link layer type
set val(ant) Antenna/OmniAntenna ;      # antenna model
set val(ifqlen) 50 ;                    # max packet in ifq
set val(nn) 10 ;                        # number of mobilenodes
set val(rp) DSDV ;                      # routing protocol
set val(x) 500 ;                        # X dimension of topography
set val(y) 500 ;                        # Y dimension of topography
set val(stop) 50 ;                      # time of simulation end

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
        set xx [expr rand()*500]
        set yy [expr rand()*400]
        $n($i) set X_ $xx
        $n($i) set Y_ $yy
        $n($i) set Z_ 0.0
        $nsim initial_node_pos $n($i) 30
}

# reseta os nodes
for {set i 0} {$i < $val(nn) } { incr i } {
        $nsim at $val(stop) "$n($i) reset";
}

# dynamic destination setting procedure..
$ns at 0.0 "destination"
proc destination {} {
      global ns val node_
      set time 1.0
      set now [$ns now]
      for {set i 0} {$i<$val(nn)} {incr i} {
            set xx [expr rand()*500]
            set yy [expr rand()*400]
            $ns at $now "$node_($i) setdest $xx $yy 10.0"
      }
      $ns at [expr $now+$time] "destination"
}


########################## END ##################################
# Define um procedimento 'finish'
proc finish {} {
        global nsim nfile tfile
        $nsim flush-trace
        close $nfile
        close $tfile
        exec nam DSDV.nam &
}

#$nsim at $val(stop) "$nsim nam-end-wireless $val(stop)"
$nsim at $val(stop) "finish"
#$nsim at 30.01 "puts \"end simulation\" ; $nsim halt"


$nsim run
