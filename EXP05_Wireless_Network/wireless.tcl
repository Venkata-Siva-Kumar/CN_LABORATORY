# This script is created by NSG2 beta1
# <http://wushoupong.googlepages.com/nsg>

#===================================
#     Simulation parameters setup
#===================================
set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     6                          ;# number of mobilenodes
set val(rp)     AODV                       ;# routing protocol
set val(x)      866                      ;# X dimension of topography
set val(y)      400                      ;# Y dimension of topography

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NS trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan1 [new $val(chan)];#Create wireless channel
set chan2 [new $val(chan)];#Create wireless channel
set chan3 [new $val(chan)];#Create wireless channel


#===================================
#     Mobile node parameter setup
#===================================
$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan1 \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace ON

#===================================
#        Nodes Definition        
#===================================
#Create 6 nodes
set n0 [$ns node]
$n0 set X_ 100
$n0 set Y_ 100
$n0 set Z_ 0.0
$ns initial_node_pos $n0 20
set n1 [$ns node]
$n1 set X_ 197
$n1 set Y_ 200
$n1 set Z_ 0.0
$ns initial_node_pos $n1 20
set n2 [$ns node]
$n2 set X_ 298
$n2 set Y_ 301
$n2 set Z_ 0.0
$ns initial_node_pos $n2 20
set n3 [$ns node]
$n3 set X_ 398
$n3 set Y_ 401
$n3 set Z_ 0.0
$ns initial_node_pos $n3 20
set n4 [$ns node]
$n4 set X_ 498
$n4 set Y_ 500
$n4 set Z_ 0.0
$ns initial_node_pos $n4 20
set n5 [$ns node]
$n5 set X_ 598
$n5 set Y_ 603
$n5 set Z_ 0.0
$ns initial_node_pos $n5 20

#===================================
#        Generate movement          
#===================================
$ns at 1 " $n0 setdest 50 50 20 " 
$ns at 1 " $n1 setdest 100 100 20 " 
$ns at 1 " $n2 setdest 150 150 20 " 
$ns at 1 " $n3 setdest 200 200 20 " 
$ns at 1 " $n4 setdest 250 250 20 " 
$ns at 1 " $n5 setdest 300 300 20 " 

#===================================
#        Agents Definition        
#===================================
#Setup a UDP connection
set udp0 [new Agent/UDP]
$ns attach-agent $n2 $udp0
set null2 [new Agent/Null]
$ns attach-agent $n3 $null2
$ns connect $udp0 $null2

#Setup a TCP connection
set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1
set sink3 [new Agent/TCPSink]
$ns attach-agent $n5 $sink3
$ns connect $tcp1 $sink3


#===================================
#        Applications Definition        
#===================================
#Setup a FTP Application over TCP connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp1
$ns at 1.0 "$ftp0 start"

#Setup a CBR Application over UDP connection
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp0
$ns at 2.0 "$cbr1 start"
$ns at 20.0 "finish"


#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam &
    exit 0
}

$ns run
