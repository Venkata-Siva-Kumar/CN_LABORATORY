
set ns [new Simulator]
$ns rtproto DV
$ns color 1 green

#Open the NS trace file
set tracefile [open out_dv.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out_dv.nam w]
$ns namtrace-all $namfile

set ft [open "dvr_th" "w"]
#===================================
#        Nodes Definition        
#===================================
#Create 7 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

#===================================
#        Links Definition        
#===================================
#Createlinks between nodes
$ns duplex-link $n0 $n1 1.5Mb 10ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 10ms DropTail
$ns duplex-link $n3 $n4 1.5Mb 10ms DropTail
$ns duplex-link $n4 $n5 1.5Mb 10ms DropTail
$ns duplex-link $n5 $n6 1.5Mb 10ms DropTail
$ns duplex-link $n6 $n0 1.5Mb 10ms DropTail



#===================================
#        Agents Definition        
#===================================
#Setup a TCP connection
set tcp0 [new Agent/TCP]
$tcp0 set class_ 1
$ns attach-agent $n0 $tcp0
set sink1 [new Agent/TCPSink]
$ns attach-agent $n3 $sink1
$ns connect $tcp0 $sink1

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0


proc record {} {
 global sink1 tracefile ft
 global ftp 
 set ns [Simulator instance]
 set time 0.1
 set now [$ns now]
 set bw0 [$sink1 set bytes_]
 puts $ft "now [expr $bw0/$time*8/1000000]"
 $sink1 set bytes_ 0
 $ns at [expr $now+$time] "record"
}



proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $namfile
    exec nam out_dv.nam &
    exec xgraph dvr_th &
    exit 0
}


$ns at 0.55 "record"
$ns at 0.5 "$n0 color \"Green\""
$ns at 0.5 "$n3 color \"Green\""
$ns at 0.5 "$ns trace-annotate \"Starting FTP from node0 to node 6\""
$ns at 0.5 "$n0 label-color green"
$ns at 0.5 "$n3 label-color green"
$ns at 0.5 "$ftp0 start"
$ns at 0.5 "$n1 label-color green"
$ns at 0.5 "$n2 label-color green"
$ns at 0.5 "$n4 label-color blue"
$ns at 0.5 "$n5 label-color blue"
$ns at 0.5 "$n6 label-color blue"
$ns rtmodel-at 2.0 down $n2 $n3
$ns at 0.5 "$n1 label-color blue"
$ns at 0.5 "$n2 label-color blue"
$ns at 0.5 "$n4 label-color green"
$ns at 0.5 "$n5 label-color green"
$ns at 0.5 "$n6 label-color green"
$ns rtmodel-at 3.0 up $n2 $n3
$ns at 3.0 "$ftp0 start"
$ns at 4.9 "$ftp0 stop"
$ns at 5.0 "finish"
$ns run
