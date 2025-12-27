set ns [new Simulator]

#Open the NS trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile

set ft1 [open Sender1_throughput w]
set ft2 [open Sender2_throughput w]
set ft3 [open Sender3_throughput w]
set ft4 [open Total_throughput w]

set fb1 [open Bandwidth1 w]
set fb2 [open Bandwidth2 w]
set fb3 [open Bandwidth3 w]
set fb4 [open Total_Bandwidth w]


set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]

#===================================
#        Links Definition        
#===================================
#Createlinks between nodes
$ns duplex-link $n0 $n1 2.0Mb 10ms DropTail
$ns duplex-link $n1 $n2 2.0Mb 10ms DropTail
$ns duplex-link $n2 $n4 2.0Mb 10ms DropTail
$ns duplex-link $n7 $n8 2.0Mb 10ms DropTail
$ns duplex-link $n5 $n6 2.0Mb 10ms DropTail
$ns duplex-link $n0 $n3 2.0Mb 10ms RED
$ns duplex-link $n3 $n5 2.0Mb 10ms RED
$ns duplex-link $n4 $n6 2.0Mb 10ms RED
$ns duplex-link $n7 $n4 2.0Mb 10ms RED
$ns duplex-link $n8 $n9 2.0Mb 10ms RED

#Give node position (for NAM)
$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n2 $n4 orient right-down
$ns duplex-link-op $n7 $n8 orient right-up
$ns duplex-link-op $n5 $n6 orient right
$ns duplex-link-op $n0 $n3 orient right-down
$ns duplex-link-op $n3 $n5 orient right-down
$ns duplex-link-op $n4 $n6 orient right-down
$ns duplex-link-op $n7 $n4 orient left-down
$ns duplex-link-op $n8 $n9 orient right-down


$ns at 10.0 "finish"


proc ftp_traffic {n0 n9} {
 global ns null1 tcp1 ftp1
 set tcp1 [new Agent/TCP]
 set null1 [new Agent/TCPSink]
 $ns attach-agent $n0 $tcp1
 $ns attach-agent $n9 $null1
 $ns connect $tcp1 $null1
 set ftp1 [new Application/FTP]
 $ftp1 attach-agent $tcp1
 $ns at 0.5 "$ftp1 start"
 $ns at 1.5 "$ftp1 stop"
 }
 ftp_traffic $n2 $n5
 
proc http_traffic {n0 n3} {
 global ns null3 tcp3 http1
 set tcp3 [new Agent/TCP]
 set null3 [new Agent/TCPSink]
 $ns attach-agent $n0 $tcp3
 $ns attach-agent $n3 $null3
 $ns connect $tcp3 $null3
 set http1 [new Application/Traffic/Exponential]
 $http1 attach-agent $tcp3
 $ns at 1.5 "$http1 start"
 $ns at 2.5 "$http1 stop"
 }
 http_traffic $n0 $n9
 
proc smtp_traffic {n1 n7} {
 global ns null2 tcp2 smtp1
 set tcp2 [new Agent/TCP]
 set null2 [new Agent/TCPSink]
 $ns attach-agent $n1 $tcp2
 $ns attach-agent $n7 $null2
 $ns connect $tcp2 $null2
 set smtp1 [new Application/Traffic/Exponential]
 $smtp1 attach-agent $tcp2
 $ns at 2.5 "$smtp1 start"
 $ns at 3.5 "$smtp1 stop"
 }
 smtp_traffic $n3 $n8
 
$ns at 0.5 "record"

proc finish {} {
    global ns  namfile ft1 ft2 ft3 ft4 fb1 fb2 fb3 fb4
    $ns flush-trace
    
    close $namfile
    close $ft1
    close $ft2
    close $ft3
    close $ft4
    close $fb1
    close $fb3
    close $fb4
    
    #exec Sender1_throughput Sender2_throughput Sender3_throughput Total_troughput &
    #exec Bandwidth1 Bandwidth2 Bandwidth3 Total_Bandwidth & 
    exec nam out.nam &
    #exec awk -f analysis.awk out.tr
    exit 0
}

proc record {} {
 global null1 null2 null3 ft1 ft2 ft3 ft4 fb1 fb2 fb3 fb4
 global ftp1 http1 smtp1
 
 set ns [Simulator instance]
 set time 0.1
 set now [$ns now]
 set bw0 [$null1 set bytes_]
 set bw1 [$null2 set bytes_]
 set bw2 [$null3 set bytes_]
 
 set totbw [expr $bw0+$bw1+$bw2]
 
 puts $ft1 "$now [expr $bw0/$time*8/1000000]"
 puts $ft2 "$now [expr $bw1/$time*8/1000000]"
 puts $ft3 "$now [expr $bw2/$time*8/1000000]"
 puts $ft4 "$now [expr $totbw/$time*8/1000000]"
 
 puts $fb1 "$now [expr $bw0]"
 puts $fb2 "$now [expr $bw1]"
 puts $fb3 "$now [expr $bw2]"
 puts $fb4 "$now [expr $totbw]"
 
 $null1 set bytes_ 0
 $null2 set bytes_ 0
 $null3 set bytes_ 0
 
 $ns at [expr $now+$time] "record"
 }
 
 
 
$ns run
