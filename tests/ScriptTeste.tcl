#------------------------------------------------------- 
# This ns script has been created by the nam editor.
# If you edit it manually, the nam editor might not
# be able to open it properly in the future.
#
# EDITING BY HAND IS AT YOUR OWN RISK!
#------------------------------------------------------- 
# Create a new simulator object.
set ns [new Simulator]
# Create a nam trace datafile.
set namfile [open ScriptTeste.nam w]
$ns namtrace-all $namfile

# Create wired nodes.
set node(2) [$ns node]
## node(2) at 555.453125,588.281250
$node(2) set X_ 555.453125
$node(2) set Y_ 588.281250
$node(2) set Z_ 0.0
$node(2) color "black"

set node(1) [$ns node]
## node(1) at 487.046844,590.687500
$node(1) set X_ 487.046844
$node(1) set Y_ 590.687500
$node(1) set Z_ 0.0
$node(1) color "black"


# Create links between nodes.
$ns simplex-link $node(2) $node(1) 1.000000Mb 20.000000ms DropTail
$ns simplex-link-op $node(2) $node(1) queuePos 0.5
$ns simplex-link-op $node(2) $node(1) color black
$ns simplex-link-op $node(2) $node(1) orient 178.0deg
# Set Queue Properties for link 2->1
[[$ns link $node(2) $node(1)] queue] set limit_ 20

$ns simplex-link $node(1) $node(2) 1.000000Mb 20.000000ms DropTail
$ns simplex-link-op $node(1) $node(2) queuePos 0.5
$ns simplex-link-op $node(1) $node(2) color black
$ns simplex-link-op $node(1) $node(2) orient 358.0deg
# Set Queue Properties for link 1->2
[[$ns link $node(1) $node(2)] queue] set limit_ 20

# Add Link Loss Models

# Create agents.
set agent(2) [new Agent/TCP]
$ns attach-agent $node(2) $agent(2)
set agent(1) [new Agent/TCP]
$ns attach-agent $node(1) $agent(1)

# Connect agents.
# Run the simulation
proc finish {} {
	global ns namfile
	$ns flush-trace
	close $namfile
	exec nam -r 2000.000000us ScriptTeste.nam &	
	exit 0
}

$ns at 60.000000 "finish"
$ns run
