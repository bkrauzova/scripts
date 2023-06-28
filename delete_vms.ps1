# script deletes specified vms
#
# ./delete_vms.ps1 [vm1] [vm2] [...]
#     ex.: ./delete.ps1 vm1 vm2 vm3
#
# ===================================================================================

function connect {
    write-host "Connecting to vc-ova...."
    Connect-VIServer -Server "10.130.54.11" -Force -UserName 'administrator@vsphere.local' -Password 'Heslo123'
}

# ===================================================================================

connect

$i = 1
while (args[$i]) {
    wtite-host "Pernamently deleting VM: $($args[$($i)])"
    Remove-VM -VM $args[$i] -DeletePernamently $true
    Start-Sleep -s 1
          
}

