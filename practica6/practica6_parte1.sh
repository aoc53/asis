#!/bin/bash

delim=':'
uptime_info=$(uptime | sed -E s/"([0-9]+),([0-9]+),?"/\1.\2/g | cut -d',' -f2,3);

memory_used_col=3;
memory_free_col=4;
mem_info=$(free -h | grep Mem: | sed -E s/"\s+"/"$delim"/g | cut -d"$delim" -f$memory_used_col,$memory_free_col)
swap_info=$(free -h | grep Swap: | sed -E s/"\s+"/"$delim"/g | cut -d"$delim" -f$memory_used_col)

disk_used_col=3;
disk_avail_col=4;
disk_info=$(df --total -h | grep -e "^total" | sed -E s/"\s+"/"$delim "/g | cut -d"$delim" -f$disk_used_col,$disk_avail_col);

connections=$(ss -n --no-header | wc -l)
open_ports=$(ss -l -n --no-header | wc -l)

total_processes=$(ps -o pid= | wc -l);

logger -p local0.info  "UptimeInfo: $uptime_info; UsedMem: $(echo $mem_info )AvailableMem:UsedSwap:UsedSpace:AvailableSpace:Connections:OpenPorts:TotalProcesses\n \
$uptime_info:$mem_info:$swap_info:$disk_info:$connections:$open_ports:$total_processes"
