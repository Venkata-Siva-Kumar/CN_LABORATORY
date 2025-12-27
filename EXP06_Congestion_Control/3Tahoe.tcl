set ns [new Simulator]
$ns color 3 green


set tracefile [open tahoe.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open tahoe.nam w]
$ns namtrace-all $namfile
set ft3 [open tahoe w]

#===================================
#        Nodes Definition        
#===================================
#Create 6 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#===================================
#        Links Definition        
#===================================
#Createlinks between nodes
$ns duplex-link $n3 $n0 0.1Mb 10ms RED
$ns duplex-link $n2 $n5 0.1Mb 10ms RED
$ns duplex-link $n0 $n1 0.1Mb 10ms DropTail
$ns duplex-link $n1 $n2 0.1Mb 10ms DropTail
$ns duplex-link $n3 $n4 0.1Mb 10ms DropTail
$ns duplex-link $n4 $n5 0.1Mb 10ms DropTail

#Give node position (for NAM)
$ns duplex-link-op $n3 $n0 orient right-up
$ns duplex-link-op $n2 $n5 orient left-down
$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n1 $n2 orient right-down
$ns duplex-link-op $n3 $n4 orient right-down
$ns duplex-link-op $n4 $n5 orient right-up

#===================================
#        Agents Definition        
#===================================
#Setup a TCP/Tahoe connection
set tcp0 [new Agent/TCP/Tahoe]
$ns attach-agent $n0 $tcp0
set sink1 [new Agent/TCPSink]
$ns attach-agent $n5 $sink1
$ns connect $tcp0 $sink1
set http1 [new Application/Traffic/Exponential]
$http1 attach-agent $tcp0




#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns  namfile ft3
    $ns flush-trace
    close $namfile
    close $ft3
    exec nam tahoe.nam &
    exec xgraph tahoe_sender_throughput &
    exit 0
}

proc record {} {
 global sink1  ft3
 global http1
 set ns [Simulator instance]
 set time 0.1
 set now [$ns now]
 set bw0 [$sink1 set bytes_]
 puts $ft3 "now [expr $bw0/$time*8/1000000]"
 $sink1 set bytes_ 0
 $ns at [expr $now+$time] "record"
}


$ns at 0.5 "record"
$ns at 0.5 "$ns trace-annotate \"Starting Http from 0 to 5\""
$ns at 0.5 "$n0 color  \"Green\""
$ns at 0.5 "$n5 color  \"Green\""
$ns at 1.0 "$http1 start"
$ns at 4.5 "$http1 stop"
$ns at 5.0 "finish"
$ns run
