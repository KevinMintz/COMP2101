function MySystemInfo{
"`n"
"System Information"
$SystemInfo = Get-WmiObject Win32_ComputerSystem
$OperatingSystem = Get-WmiObject Win32_OperatingSystem 
new-object -typename psobject -property @{Domain=$SystemInfo.Domain
					  Manufacturer=$SystemInfo.Manufacturer
					  Model=$SystemInfo.Model
					  ComputerName=$SystemInfo.Name
					  "TotalPhysicalMemory(GB)"=$SystemInfo.TotalPhysicalMemory / 1gb -as [int]
					  OSName=$OperatingSystem.name	
					  OSVersion=$OperatingSystem.version
	}
}

function MyProcessorInfo{
"Processor Information"
"`n"
$processorinfo = get-wmiobject win32_processor
if($processorinfo.L1CacheSize -lt 1) {
$L1CacheSize = "data unavailable"
}
else{
$L1CacheSize = $processorinfo.L1CacheSize
}
new-object -typename psobject -property @{Speed=$processorinfo.CurrentClockSpeed 
					  NumberOfCores=$processorinfo.NumberOfCores 
                                          L1CacheSize=$L1CacheSize 
                                          L2CacheSize=$processorinfo.L2CacheSize 
                                          L3CacheSize=$processorinfo.L3CacheSize
	}
}

function MyRAMInfo {
"Physical Memory Information"
$totalcapacity = 0
get-wmiobject -class win32_physicalmemory |
foreach {
new-object -TypeName psobject -Property @{
Manufacturer = $_.manufacturer
"Speed(MHz)" = $_.speed
"Size(MB)" = $_.capacity/1mb
Bank = $_.banklabel
Slot = $_.devicelocator
}
$totalcapacity += $_.capacity/1mb
} |
ft -auto Manufacturer, "Size(MB)", "Speed(MHz)", Bank, Slot
"Total RAM: ${totalcapacity}MB "
}

function MyDiskInfo{
"`n"
"Disk Drive Information"
  $diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Location=$partition.deviceid
                                                               Drive=$logicaldisk.deviceid
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               }
           }
      }
  }
}
Function MyNetworkInfo {
"`n"
"Network Adapter Information"
ps-lab3
}
Function MyVideoCard {
"Video Card Information"
$VideoInfo = Get-WmiObject Win32_VideoController
new-object -typename psobject -property @{Description = $VideoInfo.Description
					  HorizontalResolution = $VideoInfo.CurrentHorizontalResolution
					  VerticalResoltion = $VideoInfo.CurrentVerticalResolution
	}
}
MySystemInfo
MyProcessorInfo
MyRAMInfo
MyDiskInfo
MyNetworkInfo
MyVideoCard


