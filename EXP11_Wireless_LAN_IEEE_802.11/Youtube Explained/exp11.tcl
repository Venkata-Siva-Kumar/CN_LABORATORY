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
set val(nn)     15                         ;# number of mobilenodes
set val(rp)     AODV                       ;# routing protocol
set val(x)      1100                      ;# X dimension of topography
set val(y)      1100                      ;# Y dimension of topography
set val(stop)   899.0                         ;# time of simulation end

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
set chan [new $val(chan)];#Create wireless channel

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
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    OFF \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace OFF

#===================================
#        Nodes Definition        
#===================================
#Create 15 nodes
set n0 [$ns node]
$n0 set X_ 917
$n0 set Y_ 112
$n0 set Z_ 0.0
$ns initial_node_pos $n0 20
set n1 [$ns node]
$n1 set X_ 915
$n1 set Y_ 119
$n1 set Z_ 0.0
$ns initial_node_pos $n1 20
set n2 [$ns node]
$n2 set X_ 912
$n2 set Y_ 115
$n2 set Z_ 0.0
$ns initial_node_pos $n2 20
set n3 [$ns node]
$n3 set X_ 930
$n3 set Y_ 139
$n3 set Z_ 0.0
$ns initial_node_pos $n3 20
set n4 [$ns node]
$n4 set X_ 918
$n4 set Y_ 111
$n4 set Z_ 0.0
$ns initial_node_pos $n4 20
set n5 [$ns node]
$n5 set X_ 918
$n5 set Y_ 112
$n5 set Z_ 0.0
$ns initial_node_pos $n5 20
set n6 [$ns node]
$n6 set X_ 913
$n6 set Y_ 118
$n6 set Z_ 0.0
$ns initial_node_pos $n6 20
set n7 [$ns node]
$n7 set X_ 916
$n7 set Y_ 140
$n7 set Z_ 0.0
$ns initial_node_pos $n7 20
set n8 [$ns node]
$n8 set X_ 933
$n8 set Y_ 121
$n8 set Z_ 0.0
$ns initial_node_pos $n8 20
set n9 [$ns node]
$n9 set X_ 922
$n9 set Y_ 121
$n9 set Z_ 0.0
$ns initial_node_pos $n9 20
set n10 [$ns node]
$n10 set X_ 927
$n10 set Y_ 125
$n10 set Z_ 0.0
$ns initial_node_pos $n10 20
set n11 [$ns node]
$n11 set X_ 924
$n11 set Y_ 131
$n11 set Z_ 0.0
$ns initial_node_pos $n11 20
set n12 [$ns node]
$n12 set X_ 926
$n12 set Y_ 117
$n12 set Z_ 0.0
$ns initial_node_pos $n12 20
set n13 [$ns node]
$n13 set X_ 919
$n13 set Y_ 121
$n13 set Z_ 0.0
$ns initial_node_pos $n13 20
set n14 [$ns node]
$n14 set X_ 934
$n14 set Y_ 115
$n14 set Z_ 0.0
$ns initial_node_pos $n14 20

#===================================
#        Generate movement          
#===================================
$ns at 20 " $n0 setdest 100 600 3000 " 
$ns at 1 " $n1 setdest 100 400 500 " 
$ns at 20 " $n2 setdest 700 500 3000 " 
$ns at 1 " $n3 setdest 200 400 500 " 
$ns at 30 " $n6 setdest 500 462 3000 " 
$ns at 1 " $n7 setdest 250 400 500 " 
$ns at 1 " $n10 setdest 300 400 500 " 
$ns at 1 " $n11 setdest 400 400 500 " 
$ns at 20 " $n13 setdest 407 952 3000 " 

#===================================
#        Agents Definition        
#===================================
#Setup a TCP connection
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink12 [new Agent/TCPSink]
$ns attach-agent $n3 $sink12
$ns connect $tcp0 $sink12

#Setup a TCP connection
set tcp1 [new Agent/TCP]
$ns attach-agent $n2 $tcp1
set sink10 [new Agent/TCPSink]
$ns attach-agent $n1 $sink10
$ns connect $tcp1 $sink10

#Setup a TCP connection
set tcp2 [new Agent/TCP]
$ns attach-agent $n4 $tcp2
set sink11 [new Agent/TCPSink]
$ns attach-agent $n1 $sink11
$ns connect $tcp2 $sink11

#Setup a TCP connection
set tcp3 [new Agent/TCP]
$ns attach-agent $n5 $tcp3
set sink13 [new Agent/TCPSink]
$ns attach-agent $n3 $sink13
$ns connect $tcp3 $sink13

#Setup a TCP connection
set tcp4 [new Agent/TCP]
$ns attach-agent $n6 $tcp4
set sink16 [new Agent/TCPSink]
$ns attach-agent $n10 $sink16
$ns connect $tcp4 $sink16

#Setup a TCP connection
set tcp5 [new Agent/TCP]
$ns attach-agent $n8 $tcp5
set sink18 [new Agent/TCPSink]
$ns attach-agent $n11 $sink18
$ns connect $tcp5 $sink18

#Setup a TCP connection
set tcp6 [new Agent/TCP]
$ns attach-agent $n9 $tcp6
set sink14 [new Agent/TCPSink]
$ns attach-agent $n7 $sink14
$ns connect $tcp6 $sink14

#Setup a TCP connection
set tcp7 [new Agent/TCP]
$ns attach-agent $n12 $tcp7
set sink19 [new Agent/TCPSink]
$ns attach-agent $n11 $sink19
$ns connect $tcp7 $sink19

#Setup a TCP connection
set tcp8 [new Agent/TCP]
$ns attach-agent $n13 $tcp8
set sink15 [new Agent/TCPSink]
$ns attach-agent $n7 $sink15
$ns connect $tcp8 $sink15

#Setup a TCP connection
set tcp9 [new Agent/TCP]
$ns attach-agent $n14 $tcp9
set sink17 [new Agent/TCPSink]
$ns attach-agent $n10 $sink17
$ns connect $tcp9 $sink17


#===================================
#        Applications Definition        
#===================================
#Setup a CBR Application over TCP connection
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $tcp0
$cbr0 set packetSize_ 1000
$cbr0 set rate_ 1.0Mb
$cbr0 set random_ null
$ns at 1.0 "$cbr0 start"
$ns at 850.0 "$cbr0 stop"

#Setup a CBR Application over TCP connection
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $tcp3
$cbr1 set packetSize_ 1000
$cbr1 set rate_ 1.0Mb
$cbr1 set random_ null
$ns at 1.0 "$cbr1 start"
$ns at 850.0 "$cbr1 stop"

#Setup a CBR Application over TCP connection
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $tcp1
$cbr2 set packetSize_ 1000
$cbr2 set rate_ 1.0Mb
$cbr2 set random_ null
$ns at 20.0 "$cbr2 start"
$ns at 810.0 "$cbr2 stop"

#Setup a CBR Application over TCP connection
set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $tcp2
$cbr3 set packetSize_ 1000
$cbr3 set rate_ 1.0Mb
$cbr3 set random_ null
$ns at 20.0 "$cbr3 start"
$ns at 810.0 "$cbr3 stop"

#Setup a FTP Application over TCP connection
set ftp4 [new Application/FTP]
$ftp4 attach-agent $tcp4
$ns at 25.0 "$ftp4 start"
$ns at 860.0 "$ftp4 stop"

#Setup a FTP Application over TCP connection
set ftp5 [new Application/FTP]
$ftp5 attach-agent $tcp9
$ns at 25.0 "$ftp5 start"
$ns at 860.0 "$ftp5 stop"

#Setup a FTP Application over TCP connection
set ftp6 [new Application/FTP]
$ftp6 attach-agent $tcp5
$ns at 30.0 "$ftp6 start"
$ns at 870.0 "$ftp6 stop"

#Setup a FTP Application over TCP connection
set ftp7 [new Application/FTP]
$ftp7 attach-agent $tcp7
$ns at 30.0 "$ftp7 start"
$ns at 870.0 "$ftp7 stop"

#Setup a FTP Application over TCP connection
set ftp8 [new Application/FTP]
$ftp8 attach-agent $tcp6
$ns at 40.0 "$ftp8 start"
$ns at 810.0 "$ftp8 stop"

#Setup a FTP Application over TCP connection
set ftp9 [new Application/FTP]
$ftp9 attach-agent $tcp8
$ns at 40.0 "$ftp9 start"
$ns at 810.0 "$ftp9 stop"
$ns at 899 "finish"

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
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}

$ns run
