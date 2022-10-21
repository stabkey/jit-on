#Azureに接続
Connect-AzAccount -Identity 

#VMの情報取得（サブスクリプション内すべて）
$VMInfo = Get-AzVM

#Just in Time有効化（サブスクリプション内すべて）
Foreach($VMI in $VMInfo)
{
    $Location = $VMI.location
    $Name = $VMI.Name
    $RG = $VMI.ResourceGroupName
    $ID = $VMI.ID
    $JitPolicy = (@{
        id=$ID;
        ports=(@{
            number=22;
            protocol="*";
            allowedSourceAddressPrefix=@("*");
            maxRequestAccessDuration="PT3H"},
            @{
            number=3389;
            protocol="*";
            allowedSourceAddressPrefix=@("*");
            maxRequestAccessDuration="PT3H"})})
     $JitPolicyArr=@($JitPolicy)
     Set-AzJitNetworkAccessPolicy -Kind "Basic" -Location $Location -Name $Name -ResourceGroupName $RG -VirtualMachine $JitPolicyArr
     $ID
}
