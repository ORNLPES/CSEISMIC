<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="15008000">
	<Property Name="SMProvider.SMVersion" Type="Int">201310</Property>
	<Item Name="My Computer" Type="My Computer">
		<Property Name="IOScan.Faults" Type="Str"></Property>
		<Property Name="IOScan.NetVarPeriod" Type="UInt">100</Property>
		<Property Name="IOScan.NetWatchdogEnabled" Type="Bool">false</Property>
		<Property Name="IOScan.Period" Type="UInt">10000</Property>
		<Property Name="IOScan.PowerupMode" Type="UInt">0</Property>
		<Property Name="IOScan.Priority" Type="UInt">9</Property>
		<Property Name="IOScan.ReportModeConflict" Type="Bool">true</Property>
		<Property Name="IOScan.StartEngineOnDeploy" Type="Bool">false</Property>
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="Dependencies" Type="Dependencies"/>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
	<Item Name="RT CompactRIO Target" Type="RT CompactRIO">
		<Property Name="alias.name" Type="Str">RT CompactRIO Target</Property>
		<Property Name="alias.value" Type="Str">192.168.48.250</Property>
		<Property Name="CCSymbols" Type="Str">TARGET_TYPE,RT;OS,Linux;CPU,ARM;DeviceCode,76D6;</Property>
		<Property Name="crio.ControllerPID" Type="Str">76D6</Property>
		<Property Name="host.ResponsivenessCheckEnabled" Type="Bool">true</Property>
		<Property Name="host.ResponsivenessCheckPingDelay" Type="UInt">5000</Property>
		<Property Name="host.ResponsivenessCheckPingTimeout" Type="UInt">1000</Property>
		<Property Name="host.TargetCPUID" Type="UInt">8</Property>
		<Property Name="host.TargetOSID" Type="UInt">8</Property>
		<Property Name="NI.SortType" Type="Int">3</Property>
		<Property Name="target.cleanupVisa" Type="Bool">false</Property>
		<Property Name="target.FPProtocolGlobals_ControlTimeLimit" Type="Int">300</Property>
		<Property Name="target.getDefault-&gt;WebServer.Port" Type="Int">80</Property>
		<Property Name="target.getDefault-&gt;WebServer.Timeout" Type="Int">60</Property>
		<Property Name="target.IOScan.Faults" Type="Str"></Property>
		<Property Name="target.IOScan.NetVarPeriod" Type="UInt">100</Property>
		<Property Name="target.IOScan.NetWatchdogEnabled" Type="Bool">false</Property>
		<Property Name="target.IOScan.Period" Type="UInt">10000</Property>
		<Property Name="target.IOScan.PowerupMode" Type="UInt">0</Property>
		<Property Name="target.IOScan.Priority" Type="UInt">0</Property>
		<Property Name="target.IOScan.ReportModeConflict" Type="Bool">true</Property>
		<Property Name="target.IsRemotePanelSupported" Type="Bool">true</Property>
		<Property Name="target.RTCPULoadMonitoringEnabled" Type="Bool">true</Property>
		<Property Name="target.RTDebugWebServerHTTPPort" Type="Int">8001</Property>
		<Property Name="target.RTTarget.ApplicationPath" Type="Path">/home/lvuser/natinst/bin/startup.rtexe</Property>
		<Property Name="target.RTTarget.EnableFileSharing" Type="Bool">true</Property>
		<Property Name="target.RTTarget.IPAccess" Type="Str">+*</Property>
		<Property Name="target.RTTarget.LaunchAppAtBoot" Type="Bool">true</Property>
		<Property Name="target.RTTarget.VIPath" Type="Path">/home/lvuser/natinst/bin</Property>
		<Property Name="target.server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="target.server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="target.server.tcp.access" Type="Str">+*</Property>
		<Property Name="target.server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="target.server.tcp.paranoid" Type="Bool">true</Property>
		<Property Name="target.server.tcp.port" Type="Int">3363</Property>
		<Property Name="target.server.tcp.serviceName" Type="Str">Main Application Instance/VI Server</Property>
		<Property Name="target.server.tcp.serviceName.default" Type="Str">Main Application Instance/VI Server</Property>
		<Property Name="target.server.vi.access" Type="Str">+*</Property>
		<Property Name="target.server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="target.server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="target.WebServer.Config" Type="Str">Listen 8000

NI.ServerName default
DocumentRoot "$LVSERVER_DOCROOT"
TypesConfig "$LVSERVER_CONFIGROOT/mime.types"
DirectoryIndex index.htm
WorkerLimit 10
InactivityTimeout 60

LoadModulePath "$LVSERVER_MODULEPATHS"
LoadModule LVAuth lvauthmodule
LoadModule LVRFP lvrfpmodule

#
# Pipeline Definition
#

SetConnector netConnector

AddHandler LVAuth
AddHandler LVRFP

AddHandler fileHandler ""

AddOutputFilter chunkFilter


</Property>
		<Property Name="target.WebServer.Enabled" Type="Bool">false</Property>
		<Property Name="target.WebServer.LogEnabled" Type="Bool">false</Property>
		<Property Name="target.WebServer.LogPath" Type="Path">/c/ni-rt/system/www/www.log</Property>
		<Property Name="target.WebServer.Port" Type="Int">80</Property>
		<Property Name="target.WebServer.RootPath" Type="Path">/c/ni-rt/system/www</Property>
		<Property Name="target.WebServer.TcpAccess" Type="Str">c+*</Property>
		<Property Name="target.WebServer.Timeout" Type="Int">60</Property>
		<Property Name="target.WebServer.ViAccess" Type="Str">+*</Property>
		<Property Name="target.webservices.SecurityAPIKey" Type="Str">PqVr/ifkAQh+lVrdPIykXlFvg12GhhQFR8H9cUhphgg=:pTe9HRlQuMfJxAG6QCGq7UvoUpJzAzWGKy5SbZ+roSU=</Property>
		<Property Name="target.webservices.ValidTimestampWindow" Type="Int">15</Property>
		<Item Name="Archive" Type="Folder">
			<Item Name="Rt_PCC_controller_v4.vi" Type="VI" URL="../RT/Rt_PCC_controller_v4.vi"/>
		</Item>
		<Item Name="Debugging" Type="Folder">
			<Item Name="RT_PCC_Control_v02b_clean.vi" Type="VI" URL="../RT/RT_PCC_Control_v02b_clean.vi"/>
		</Item>
		<Item Name="Rt_PCC_controller_v3.vi" Type="VI" URL="../RT/Rt_PCC_controller_v3.vi"/>
		<Item Name="Chassis" Type="cRIO Chassis">
			<Property Name="crio.ProgrammingMode" Type="Str">fpga</Property>
			<Property Name="crio.ResourceID" Type="Str">RIO0</Property>
			<Property Name="crio.Type" Type="Str">cRIO-9068</Property>
			<Item Name="FPGA Target" Type="FPGA Target">
				<Property Name="AutoRun" Type="Bool">false</Property>
				<Property Name="configString.guid" Type="Str">{0365254E-4C8E-498B-B908-42928D258F13}resource=/crio_Mod1/AI11;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{08196F43-DC9D-4ED8-9191-9D67550297D8}resource=/crio_Mod2/DO7;0;ReadMethodType=bool;WriteMethodType=bool{1314AFA1-DC9A-48F2-ACB6-4B35E642B7C1}resource=/Sleep;0;ReadMethodType=bool;WriteMethodType=bool{170C3CAD-048E-4EAC-BF9A-021EF3396AD7}resource=/System Reset;0;ReadMethodType=bool;WriteMethodType=bool{1ABC6A51-3C1D-4705-AD22-AB7C0A2BE3D6}resource=/crio_Mod2/DO16;0;ReadMethodType=bool;WriteMethodType=bool{274F8370-463C-4A3E-8228-15DD1C21E5B8}resource=/Chassis Temperature;0;ReadMethodType=i16{35EF4B31-373C-40D5-A4B2-B466149BB484}resource=/crio_Mod2/DO11;0;ReadMethodType=bool;WriteMethodType=bool{37E6C110-E9CE-426B-9A5A-241F03B6494A}resource=/crio_Mod2/DO17;0;ReadMethodType=bool;WriteMethodType=bool{3A6ECEBE-A39B-4502-B8D7-DB341552B293}resource=/crio_Mod2/DO14;0;ReadMethodType=bool;WriteMethodType=bool{3DDD6D76-68B9-4414-9FF9-5FB90995802B}resource=/crio_Mod2/DO10;0;ReadMethodType=bool;WriteMethodType=bool{4A0B0CE7-992D-4988-B0AF-4465498CE123}resource=/crio_Mod2/DO1;0;ReadMethodType=bool;WriteMethodType=bool{4BE00E55-86FF-4709-AFF0-8ADF6A77BEE9}resource=/crio_Mod1/AI4;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{4BF96FCD-B764-4D2F-A5A7-75A43AC2AB6A}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO2;0;ReadMethodType=bool;WriteMethodType=bool{52FBC27F-BEB9-4BC2-AA2E-0ED73651F977}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO5;0;ReadMethodType=bool;WriteMethodType=bool{6201F6E2-650E-4018-910B-F1CA297386B8}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 1,crio.Type=NI 9220,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]{6344EDBF-2AF5-4E10-BE45-693EC8C2C906}resource=/crio_Mod2/DO15;0;ReadMethodType=bool;WriteMethodType=bool{63CDB995-45FE-4322-8F86-E048B78F5DBB}resource=/crio_Mod2/DO8;0;ReadMethodType=bool;WriteMethodType=bool{698EA4EF-34A2-40D9-8EC6-8810A31E429C}resource=/crio_Mod1/AI2;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{6B2A6ABE-CA39-4F9D-9317-21C9EFEC1782}resource=/crio_Mod2/DO28;0;ReadMethodType=bool;WriteMethodType=bool{6C39B8C5-6749-4E6B-911D-62D70FB6C4FB}resource=/Scan Clock;0;ReadMethodType=bool{6CBD6814-C539-431C-8092-8479D226ECC5}resource=/crio_Mod1/AI12;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{716F0544-2C8F-4FF8-A71A-865BB5C37D94}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO1;0;ReadMethodType=bool;WriteMethodType=bool{77A59C42-9B3A-411B-9AA2-1972F8ACFAF2}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7;0;ReadMethodType=bool;WriteMethodType=bool{7AD23096-C692-4270-BCEB-7F458F7A4A2F}resource=/crio_Mod1/AI5;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{7B16127A-8AE0-49B6-84F1-E322752BFD8C}resource=/crio_Mod1/AI15;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{7C2AD387-F932-4484-B9FA-545ECC2950C4}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO4;0;ReadMethodType=bool;WriteMethodType=bool{7EFED6EA-0F1D-4DFA-93A3-BD09D2DDF918}ResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000.000000;MaxFreq=40000000.000000;VariableFreq=0;NomFreq=40000000.000000;PeakPeriodJitter=250.000000;MinDutyCycle=50.000000;MaxDutyCycle=50.000000;Accuracy=100.000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;{811229E5-B67B-4651-944C-CA70AC73BF42}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8{83E4C8DF-D408-44F2-958A-EA257EB2F570}resource=/crio_Mod2/DO27;0;ReadMethodType=bool;WriteMethodType=bool{85BA1C90-BFFD-4DFE-A9AA-7891536A1453}resource=/crio_Mod2/DO23;0;ReadMethodType=bool;WriteMethodType=bool{8824DAC7-6023-4E37-BDF3-23E95558AAFC}resource=/crio_Mod1/AI14;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{901C225A-95D6-4A9B-96BD-016CD37FF4ED}resource=/crio_Mod2/DO5;0;ReadMethodType=bool;WriteMethodType=bool{92380ACF-F38C-4995-8DAE-38C9926D7E10}resource=/crio_Mod2/DO31;0;ReadMethodType=bool;WriteMethodType=bool{93A82BFE-0054-4051-98D0-3503D2B83C72}resource=/crio_Mod2/DO30;0;ReadMethodType=bool;WriteMethodType=bool{95F3EB1D-F21C-4BB8-89B2-F2A07536B318}resource=/crio_Mod2/DO25;0;ReadMethodType=bool;WriteMethodType=bool{9A4D1652-4211-44D9-B4CE-5CBBC1407D9F}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO0;0;ReadMethodType=bool;WriteMethodType=bool{9A71538B-2C08-4B1C-BEF9-69F6DC185BB5}resource=/crio_Mod2/DO24;0;ReadMethodType=bool;WriteMethodType=bool{9F3D6220-1D66-47EE-8B3C-D4EF4DAE4414}resource=/crio_Mod2/DO2;0;ReadMethodType=bool;WriteMethodType=bool{A834D41F-A0AA-41C1-BFE9-3B668046F54A}resource=/crio_Mod1/AI7;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{A9777E0D-0A90-43E2-A1FF-AA851AB680B1}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 2,crio.Type=NI 9476,cRIOModule.DisableArbitration=false,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]{AC4354E2-98F0-4345-B08E-9C5C1CCED7E3}resource=/crio_Mod2/DO20;0;ReadMethodType=bool;WriteMethodType=bool{B67D2432-C080-44F8-839E-284AAAF92252}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO6;0;ReadMethodType=bool;WriteMethodType=bool{B7EC5AB1-5BC2-4BA7-9731-23BAC7844DDE}resource=/crio_Mod1/AI1;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{BAD30D11-D7EF-4797-9213-B7C1460AB9B7}resource=/crio_Mod2/DO31:24;0;ReadMethodType=u8;WriteMethodType=u8{BC59B3B0-3F9F-4C04-B5F1-80EA5BCDB5D0}resource=/crio_Mod2/DO3;0;ReadMethodType=bool;WriteMethodType=bool{C292F3BD-279C-47BD-B3BF-9F7C52886C9A}resource=/crio_Mod2/DO13;0;ReadMethodType=bool;WriteMethodType=bool{C3C2BDD4-4601-479E-A4F4-1D77D7AD5983}resource=/crio_Mod2/DO6;0;ReadMethodType=bool;WriteMethodType=bool{C97CBBB7-2C6B-4B1A-B49D-A9DC74011F04}resource=/crio_Mod2/DO31:0;0;ReadMethodType=u32;WriteMethodType=u32{CA776B02-3F3F-4138-BDF0-FA276CD6B960}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO3;0;ReadMethodType=bool;WriteMethodType=bool{CD2B0737-B8E0-4956-9560-79561FF8FF09}resource=/crio_Mod1/AI6;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{D0A25B87-875C-4F4B-84BD-813761CA8D4E}resource=/crio_Mod2/DO9;0;ReadMethodType=bool;WriteMethodType=bool{D28513FD-B101-4CBF-A0B7-E8E0B2F35695}resource=/crio_Mod2/DO21;0;ReadMethodType=bool;WriteMethodType=bool{D6FE3F6C-07A2-4F36-A493-D808DA1E6DFD}resource=/crio_Mod2/DO19;0;ReadMethodType=bool;WriteMethodType=bool{D727619D-329D-49DF-B1AF-7EAB96FAFDD3}resource=/crio_Mod2/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8{D8738338-8ED2-464D-8337-CE2A4E2D5517}resource=/crio_Mod1/AI13;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{D8C44379-9E6E-4065-B4CD-625EB3347471}resource=/crio_Mod1/AI10;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{DA159247-06B4-4D73-B8EE-843A843FE6F1}resource=/crio_Mod2/DO15:8;0;ReadMethodType=u8;WriteMethodType=u8{DA4177DC-3B5B-49E9-A4AE-1C7B71183FF1}resource=/crio_Mod2/DO23:16;0;ReadMethodType=u8;WriteMethodType=u8{DC5EF4F7-1B8D-43E8-A710-73286CD6314D}resource=/USER FPGA LED;0;ReadMethodType=u8;WriteMethodType=u8{E1A3B581-D77A-45EA-B9BC-1AD1138053E9}resource=/crio_Mod2/DO0;0;ReadMethodType=bool;WriteMethodType=bool{E1E74FD3-674F-435D-9F66-2DC68E280CCA}resource=/crio_Mod2/DO29;0;ReadMethodType=bool;WriteMethodType=bool{E97462DE-BEB9-4A13-8D59-45E091E7C37C}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 3,crio.Type=NI 9474,cRIOModule.DIO3_0InitialDir=0,cRIOModule.DIO7_4InitialDir=0,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.NumSyncRegs=11111111,cRIOModule.RsiAttributes=[crioConfig.End]{EA7F5BAD-2CFF-4AD4-BDD1-6F733F41CCE6}resource=/crio_Mod1/AI0;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{EE270B00-0B73-4E24-BE88-084322093660}resource=/crio_Mod1/AI8;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{EEF6D39F-5095-45D2-B9EC-E8BAC7A52F6F}resource=/crio_Mod2/DO4;0;ReadMethodType=bool;WriteMethodType=bool{EF265E61-4D2C-4BBA-B532-C70E087AA46A}resource=/crio_Mod2/DO18;0;ReadMethodType=bool;WriteMethodType=bool{EF6C5760-C11B-4E13-9C97-0AA5282EB598}resource=/crio_Mod2/DO12;0;ReadMethodType=bool;WriteMethodType=bool{FA96C7D7-3EED-42A4-9B84-083E0BBA5847}resource=/crio_Mod2/DO26;0;ReadMethodType=bool;WriteMethodType=bool{FBD5CC24-3BC6-4C66-9CE5-814332FFF494}resource=/crio_Mod2/DO22;0;ReadMethodType=bool;WriteMethodType=bool{FE25D7AC-BAA3-42E3-9A1C-D82D647083FC}resource=/crio_Mod1/AI3;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{FE487018-64CC-47D9-9B1D-CC6838576CF8}resource=/crio_Mod1/AI9;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlcRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGA/[rSeriesConfig.Begin][rSeriesConfig.End]</Property>
				<Property Name="configString.name" Type="Str">40 MHz Onboard ClockResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000.000000;MaxFreq=40000000.000000;VariableFreq=0;NomFreq=40000000.000000;PeakPeriodJitter=250.000000;MinDutyCycle=50.000000;MaxDutyCycle=50.000000;Accuracy=100.000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;Chassis Temperatureresource=/Chassis Temperature;0;ReadMethodType=i16cRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGA/[rSeriesConfig.Begin][rSeriesConfig.End]Mod1/AI0resource=/crio_Mod1/AI0;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI10resource=/crio_Mod1/AI10;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI11resource=/crio_Mod1/AI11;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI12resource=/crio_Mod1/AI12;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI13resource=/crio_Mod1/AI13;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI14resource=/crio_Mod1/AI14;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI15resource=/crio_Mod1/AI15;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI1resource=/crio_Mod1/AI1;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI2resource=/crio_Mod1/AI2;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI3resource=/crio_Mod1/AI3;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI4resource=/crio_Mod1/AI4;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI5resource=/crio_Mod1/AI5;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI6resource=/crio_Mod1/AI6;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI7resource=/crio_Mod1/AI7;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI8resource=/crio_Mod1/AI8;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI9resource=/crio_Mod1/AI9;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 1,crio.Type=NI 9220,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]Mod2/DO0resource=/crio_Mod2/DO0;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO10resource=/crio_Mod2/DO10;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO11resource=/crio_Mod2/DO11;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO12resource=/crio_Mod2/DO12;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO13resource=/crio_Mod2/DO13;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO14resource=/crio_Mod2/DO14;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO15:8resource=/crio_Mod2/DO15:8;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO15resource=/crio_Mod2/DO15;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO16resource=/crio_Mod2/DO16;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO17resource=/crio_Mod2/DO17;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO18resource=/crio_Mod2/DO18;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO19resource=/crio_Mod2/DO19;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO1resource=/crio_Mod2/DO1;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO20resource=/crio_Mod2/DO20;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO21resource=/crio_Mod2/DO21;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO22resource=/crio_Mod2/DO22;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO23:16resource=/crio_Mod2/DO23:16;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO23resource=/crio_Mod2/DO23;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO24resource=/crio_Mod2/DO24;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO25resource=/crio_Mod2/DO25;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO26resource=/crio_Mod2/DO26;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO27resource=/crio_Mod2/DO27;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO28resource=/crio_Mod2/DO28;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO29resource=/crio_Mod2/DO29;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO2resource=/crio_Mod2/DO2;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO30resource=/crio_Mod2/DO30;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO31:0resource=/crio_Mod2/DO31:0;0;ReadMethodType=u32;WriteMethodType=u32Mod2/DO31:24resource=/crio_Mod2/DO31:24;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO31resource=/crio_Mod2/DO31;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO3resource=/crio_Mod2/DO3;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO4resource=/crio_Mod2/DO4;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO5resource=/crio_Mod2/DO5;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO6resource=/crio_Mod2/DO6;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO7:0resource=/crio_Mod2/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO7resource=/crio_Mod2/DO7;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO8resource=/crio_Mod2/DO8;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO9resource=/crio_Mod2/DO9;0;ReadMethodType=bool;WriteMethodType=boolMod2[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 2,crio.Type=NI 9476,cRIOModule.DisableArbitration=false,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]Mod3/DO0ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO0;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO1ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO1;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO2ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO2;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO3ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO3;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO4ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO4;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO5ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO5;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO6ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO6;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO7:0ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8Mod3/DO7ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7;0;ReadMethodType=bool;WriteMethodType=boolMod3[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 3,crio.Type=NI 9474,cRIOModule.DIO3_0InitialDir=0,cRIOModule.DIO7_4InitialDir=0,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.NumSyncRegs=11111111,cRIOModule.RsiAttributes=[crioConfig.End]Scan Clockresource=/Scan Clock;0;ReadMethodType=boolSleepresource=/Sleep;0;ReadMethodType=bool;WriteMethodType=boolSystem Resetresource=/System Reset;0;ReadMethodType=bool;WriteMethodType=boolUSER FPGA LEDresource=/USER FPGA LED;0;ReadMethodType=u8;WriteMethodType=u8</Property>
				<Property Name="NI.LV.FPGA.CompileConfigString" Type="Str">cRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGA</Property>
				<Property Name="NI.LV.FPGA.Version" Type="Int">6</Property>
				<Property Name="niFpga_TopLevelVIID" Type="Path">//ornl/naoa/Projects/DECC-Testing/00_PROJECTS/CSEISMIC/LabVIEW/RTDS TESTING/RTDS PCC/FPGA/Switch_controller_fpga_9068_v4.vi</Property>
				<Property Name="Resource Name" Type="Str">RIO0</Property>
				<Property Name="Target Class" Type="Str">cRIO-9068</Property>
				<Property Name="Top-Level Timing Source" Type="Str">40 MHz Onboard Clock</Property>
				<Property Name="Top-Level Timing Source Is Default" Type="Bool">true</Property>
				<Item Name="Chassis I/O" Type="Folder">
					<Item Name="Chassis Temperature" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/Chassis Temperature</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{274F8370-463C-4A3E-8228-15DD1C21E5B8}</Property>
					</Item>
					<Item Name="Scan Clock" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/Scan Clock</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{6C39B8C5-6749-4E6B-911D-62D70FB6C4FB}</Property>
					</Item>
					<Item Name="Sleep" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/Sleep</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{1314AFA1-DC9A-48F2-ACB6-4B35E642B7C1}</Property>
					</Item>
					<Item Name="System Reset" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/System Reset</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{170C3CAD-048E-4EAC-BF9A-021EF3396AD7}</Property>
					</Item>
					<Item Name="USER FPGA LED" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/USER FPGA LED</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{DC5EF4F7-1B8D-43E8-A710-73286CD6314D}</Property>
					</Item>
				</Item>
				<Item Name="Mod1" Type="Folder">
					<Item Name="Mod1/AI0" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod1/AI0</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{EA7F5BAD-2CFF-4AD4-BDD1-6F733F41CCE6}</Property>
					</Item>
					<Item Name="Mod1/AI1" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod1/AI1</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{B7EC5AB1-5BC2-4BA7-9731-23BAC7844DDE}</Property>
					</Item>
					<Item Name="Mod1/AI2" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod1/AI2</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{698EA4EF-34A2-40D9-8EC6-8810A31E429C}</Property>
					</Item>
					<Item Name="Mod1/AI3" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod1/AI3</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{FE25D7AC-BAA3-42E3-9A1C-D82D647083FC}</Property>
					</Item>
					<Item Name="Mod1/AI4" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod1/AI4</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{4BE00E55-86FF-4709-AFF0-8ADF6A77BEE9}</Property>
					</Item>
					<Item Name="Mod1/AI5" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod1/AI5</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{7AD23096-C692-4270-BCEB-7F458F7A4A2F}</Property>
					</Item>
					<Item Name="Mod1/AI6" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod1/AI6</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{CD2B0737-B8E0-4956-9560-79561FF8FF09}</Property>
					</Item>
					<Item Name="Mod1/AI7" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod1/AI7</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{A834D41F-A0AA-41C1-BFE9-3B668046F54A}</Property>
					</Item>
					<Item Name="Mod1/AI8" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod1/AI8</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{EE270B00-0B73-4E24-BE88-084322093660}</Property>
					</Item>
					<Item Name="Mod1/AI9" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod1/AI9</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{FE487018-64CC-47D9-9B1D-CC6838576CF8}</Property>
					</Item>
					<Item Name="Mod1/AI10" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod1/AI10</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{D8C44379-9E6E-4065-B4CD-625EB3347471}</Property>
					</Item>
					<Item Name="Mod1/AI11" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod1/AI11</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{0365254E-4C8E-498B-B908-42928D258F13}</Property>
					</Item>
					<Item Name="Mod1/AI12" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod1/AI12</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{6CBD6814-C539-431C-8092-8479D226ECC5}</Property>
					</Item>
					<Item Name="Mod1/AI13" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod1/AI13</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{D8738338-8ED2-464D-8337-CE2A4E2D5517}</Property>
					</Item>
					<Item Name="Mod1/AI14" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod1/AI14</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{8824DAC7-6023-4E37-BDF3-23E95558AAFC}</Property>
					</Item>
					<Item Name="Mod1/AI15" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod1/AI15</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{7B16127A-8AE0-49B6-84F1-E322752BFD8C}</Property>
					</Item>
				</Item>
				<Item Name="Mod2" Type="Folder">
					<Item Name="Mod2/DO0" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO0</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{E1A3B581-D77A-45EA-B9BC-1AD1138053E9}</Property>
					</Item>
					<Item Name="Mod2/DO1" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO1</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{4A0B0CE7-992D-4988-B0AF-4465498CE123}</Property>
					</Item>
					<Item Name="Mod2/DO2" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO2</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{9F3D6220-1D66-47EE-8B3C-D4EF4DAE4414}</Property>
					</Item>
					<Item Name="Mod2/DO3" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO3</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{BC59B3B0-3F9F-4C04-B5F1-80EA5BCDB5D0}</Property>
					</Item>
					<Item Name="Mod2/DO4" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO4</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{EEF6D39F-5095-45D2-B9EC-E8BAC7A52F6F}</Property>
					</Item>
					<Item Name="Mod2/DO5" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO5</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{901C225A-95D6-4A9B-96BD-016CD37FF4ED}</Property>
					</Item>
					<Item Name="Mod2/DO6" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO6</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{C3C2BDD4-4601-479E-A4F4-1D77D7AD5983}</Property>
					</Item>
					<Item Name="Mod2/DO7" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO7</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{08196F43-DC9D-4ED8-9191-9D67550297D8}</Property>
					</Item>
					<Item Name="Mod2/DO7:0" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO7:0</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{D727619D-329D-49DF-B1AF-7EAB96FAFDD3}</Property>
					</Item>
					<Item Name="Mod2/DO8" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO8</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{63CDB995-45FE-4322-8F86-E048B78F5DBB}</Property>
					</Item>
					<Item Name="Mod2/DO9" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO9</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{D0A25B87-875C-4F4B-84BD-813761CA8D4E}</Property>
					</Item>
					<Item Name="Mod2/DO10" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO10</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{3DDD6D76-68B9-4414-9FF9-5FB90995802B}</Property>
					</Item>
					<Item Name="Mod2/DO11" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO11</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{35EF4B31-373C-40D5-A4B2-B466149BB484}</Property>
					</Item>
					<Item Name="Mod2/DO12" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO12</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{EF6C5760-C11B-4E13-9C97-0AA5282EB598}</Property>
					</Item>
					<Item Name="Mod2/DO13" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO13</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{C292F3BD-279C-47BD-B3BF-9F7C52886C9A}</Property>
					</Item>
					<Item Name="Mod2/DO14" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO14</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{3A6ECEBE-A39B-4502-B8D7-DB341552B293}</Property>
					</Item>
					<Item Name="Mod2/DO15" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO15</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{6344EDBF-2AF5-4E10-BE45-693EC8C2C906}</Property>
					</Item>
					<Item Name="Mod2/DO15:8" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO15:8</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{DA159247-06B4-4D73-B8EE-843A843FE6F1}</Property>
					</Item>
					<Item Name="Mod2/DO16" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO16</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{1ABC6A51-3C1D-4705-AD22-AB7C0A2BE3D6}</Property>
					</Item>
					<Item Name="Mod2/DO17" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO17</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{37E6C110-E9CE-426B-9A5A-241F03B6494A}</Property>
					</Item>
					<Item Name="Mod2/DO18" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO18</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{EF265E61-4D2C-4BBA-B532-C70E087AA46A}</Property>
					</Item>
					<Item Name="Mod2/DO19" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO19</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{D6FE3F6C-07A2-4F36-A493-D808DA1E6DFD}</Property>
					</Item>
					<Item Name="Mod2/DO20" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO20</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{AC4354E2-98F0-4345-B08E-9C5C1CCED7E3}</Property>
					</Item>
					<Item Name="Mod2/DO21" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO21</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{D28513FD-B101-4CBF-A0B7-E8E0B2F35695}</Property>
					</Item>
					<Item Name="Mod2/DO22" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO22</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{FBD5CC24-3BC6-4C66-9CE5-814332FFF494}</Property>
					</Item>
					<Item Name="Mod2/DO23" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO23</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{85BA1C90-BFFD-4DFE-A9AA-7891536A1453}</Property>
					</Item>
					<Item Name="Mod2/DO23:16" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO23:16</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{DA4177DC-3B5B-49E9-A4AE-1C7B71183FF1}</Property>
					</Item>
					<Item Name="Mod2/DO24" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO24</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{9A71538B-2C08-4B1C-BEF9-69F6DC185BB5}</Property>
					</Item>
					<Item Name="Mod2/DO25" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO25</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{95F3EB1D-F21C-4BB8-89B2-F2A07536B318}</Property>
					</Item>
					<Item Name="Mod2/DO26" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO26</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{FA96C7D7-3EED-42A4-9B84-083E0BBA5847}</Property>
					</Item>
					<Item Name="Mod2/DO27" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO27</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{83E4C8DF-D408-44F2-958A-EA257EB2F570}</Property>
					</Item>
					<Item Name="Mod2/DO28" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO28</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{6B2A6ABE-CA39-4F9D-9317-21C9EFEC1782}</Property>
					</Item>
					<Item Name="Mod2/DO29" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO29</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{E1E74FD3-674F-435D-9F66-2DC68E280CCA}</Property>
					</Item>
					<Item Name="Mod2/DO30" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO30</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{93A82BFE-0054-4051-98D0-3503D2B83C72}</Property>
					</Item>
					<Item Name="Mod2/DO31" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO31</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{92380ACF-F38C-4995-8DAE-38C9926D7E10}</Property>
					</Item>
					<Item Name="Mod2/DO31:0" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO31:0</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{C97CBBB7-2C6B-4B1A-B49D-A9DC74011F04}</Property>
					</Item>
					<Item Name="Mod2/DO31:24" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DO31:24</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{BAD30D11-D7EF-4797-9213-B7C1460AB9B7}</Property>
					</Item>
				</Item>
				<Item Name="Mod3" Type="Folder">
					<Item Name="Mod3/DO0" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="ArbitrationForOutputData">
   <Value>NeverArbitrate</Value>
   </Attribute>
   <Attribute name="resource">
   <Value>/crio_Mod3/DO0</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{9A4D1652-4211-44D9-B4CE-5CBBC1407D9F}</Property>
					</Item>
					<Item Name="Mod3/DO1" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="ArbitrationForOutputData">
   <Value>NeverArbitrate</Value>
   </Attribute>
   <Attribute name="resource">
   <Value>/crio_Mod3/DO1</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{716F0544-2C8F-4FF8-A71A-865BB5C37D94}</Property>
					</Item>
					<Item Name="Mod3/DO2" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="ArbitrationForOutputData">
   <Value>NeverArbitrate</Value>
   </Attribute>
   <Attribute name="resource">
   <Value>/crio_Mod3/DO2</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{4BF96FCD-B764-4D2F-A5A7-75A43AC2AB6A}</Property>
					</Item>
					<Item Name="Mod3/DO3" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="ArbitrationForOutputData">
   <Value>NeverArbitrate</Value>
   </Attribute>
   <Attribute name="resource">
   <Value>/crio_Mod3/DO3</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{CA776B02-3F3F-4138-BDF0-FA276CD6B960}</Property>
					</Item>
					<Item Name="Mod3/DO4" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="ArbitrationForOutputData">
   <Value>NeverArbitrate</Value>
   </Attribute>
   <Attribute name="resource">
   <Value>/crio_Mod3/DO4</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{7C2AD387-F932-4484-B9FA-545ECC2950C4}</Property>
					</Item>
					<Item Name="Mod3/DO5" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="ArbitrationForOutputData">
   <Value>NeverArbitrate</Value>
   </Attribute>
   <Attribute name="resource">
   <Value>/crio_Mod3/DO5</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{52FBC27F-BEB9-4BC2-AA2E-0ED73651F977}</Property>
					</Item>
					<Item Name="Mod3/DO6" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="ArbitrationForOutputData">
   <Value>NeverArbitrate</Value>
   </Attribute>
   <Attribute name="resource">
   <Value>/crio_Mod3/DO6</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{B67D2432-C080-44F8-839E-284AAAF92252}</Property>
					</Item>
					<Item Name="Mod3/DO7" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="ArbitrationForOutputData">
   <Value>NeverArbitrate</Value>
   </Attribute>
   <Attribute name="resource">
   <Value>/crio_Mod3/DO7</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{77A59C42-9B3A-411B-9AA2-1972F8ACFAF2}</Property>
					</Item>
					<Item Name="Mod3/DO7:0" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="ArbitrationForOutputData">
   <Value>NeverArbitrate</Value>
   </Attribute>
   <Attribute name="resource">
   <Value>/crio_Mod3/DO7:0</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{811229E5-B67B-4651-944C-CA70AC73BF42}</Property>
					</Item>
				</Item>
				<Item Name="Archive" Type="Folder">
					<Item Name="Switch_controller_fpga_9068_v4.vi" Type="VI" URL="../FPGA/Switch_controller_fpga_9068_v4.vi">
						<Property Name="BuildSpec" Type="Str">{458D2CF2-D29E-45AA-B82F-C6C74F767C22}</Property>
						<Property Name="configString.guid" Type="Str">{0365254E-4C8E-498B-B908-42928D258F13}resource=/crio_Mod1/AI11;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{08196F43-DC9D-4ED8-9191-9D67550297D8}resource=/crio_Mod2/DO7;0;ReadMethodType=bool;WriteMethodType=bool{1314AFA1-DC9A-48F2-ACB6-4B35E642B7C1}resource=/Sleep;0;ReadMethodType=bool;WriteMethodType=bool{170C3CAD-048E-4EAC-BF9A-021EF3396AD7}resource=/System Reset;0;ReadMethodType=bool;WriteMethodType=bool{1ABC6A51-3C1D-4705-AD22-AB7C0A2BE3D6}resource=/crio_Mod2/DO16;0;ReadMethodType=bool;WriteMethodType=bool{274F8370-463C-4A3E-8228-15DD1C21E5B8}resource=/Chassis Temperature;0;ReadMethodType=i16{35EF4B31-373C-40D5-A4B2-B466149BB484}resource=/crio_Mod2/DO11;0;ReadMethodType=bool;WriteMethodType=bool{37E6C110-E9CE-426B-9A5A-241F03B6494A}resource=/crio_Mod2/DO17;0;ReadMethodType=bool;WriteMethodType=bool{3A6ECEBE-A39B-4502-B8D7-DB341552B293}resource=/crio_Mod2/DO14;0;ReadMethodType=bool;WriteMethodType=bool{3DDD6D76-68B9-4414-9FF9-5FB90995802B}resource=/crio_Mod2/DO10;0;ReadMethodType=bool;WriteMethodType=bool{4A0B0CE7-992D-4988-B0AF-4465498CE123}resource=/crio_Mod2/DO1;0;ReadMethodType=bool;WriteMethodType=bool{4BE00E55-86FF-4709-AFF0-8ADF6A77BEE9}resource=/crio_Mod1/AI4;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{4BF96FCD-B764-4D2F-A5A7-75A43AC2AB6A}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO2;0;ReadMethodType=bool;WriteMethodType=bool{52FBC27F-BEB9-4BC2-AA2E-0ED73651F977}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO5;0;ReadMethodType=bool;WriteMethodType=bool{6201F6E2-650E-4018-910B-F1CA297386B8}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 1,crio.Type=NI 9220,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]{6344EDBF-2AF5-4E10-BE45-693EC8C2C906}resource=/crio_Mod2/DO15;0;ReadMethodType=bool;WriteMethodType=bool{63CDB995-45FE-4322-8F86-E048B78F5DBB}resource=/crio_Mod2/DO8;0;ReadMethodType=bool;WriteMethodType=bool{698EA4EF-34A2-40D9-8EC6-8810A31E429C}resource=/crio_Mod1/AI2;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{6B2A6ABE-CA39-4F9D-9317-21C9EFEC1782}resource=/crio_Mod2/DO28;0;ReadMethodType=bool;WriteMethodType=bool{6C39B8C5-6749-4E6B-911D-62D70FB6C4FB}resource=/Scan Clock;0;ReadMethodType=bool{6CBD6814-C539-431C-8092-8479D226ECC5}resource=/crio_Mod1/AI12;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{716F0544-2C8F-4FF8-A71A-865BB5C37D94}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO1;0;ReadMethodType=bool;WriteMethodType=bool{77A59C42-9B3A-411B-9AA2-1972F8ACFAF2}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7;0;ReadMethodType=bool;WriteMethodType=bool{7AD23096-C692-4270-BCEB-7F458F7A4A2F}resource=/crio_Mod1/AI5;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{7B16127A-8AE0-49B6-84F1-E322752BFD8C}resource=/crio_Mod1/AI15;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{7C2AD387-F932-4484-B9FA-545ECC2950C4}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO4;0;ReadMethodType=bool;WriteMethodType=bool{7EFED6EA-0F1D-4DFA-93A3-BD09D2DDF918}ResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000.000000;MaxFreq=40000000.000000;VariableFreq=0;NomFreq=40000000.000000;PeakPeriodJitter=250.000000;MinDutyCycle=50.000000;MaxDutyCycle=50.000000;Accuracy=100.000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;{811229E5-B67B-4651-944C-CA70AC73BF42}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8{83E4C8DF-D408-44F2-958A-EA257EB2F570}resource=/crio_Mod2/DO27;0;ReadMethodType=bool;WriteMethodType=bool{85BA1C90-BFFD-4DFE-A9AA-7891536A1453}resource=/crio_Mod2/DO23;0;ReadMethodType=bool;WriteMethodType=bool{8824DAC7-6023-4E37-BDF3-23E95558AAFC}resource=/crio_Mod1/AI14;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{901C225A-95D6-4A9B-96BD-016CD37FF4ED}resource=/crio_Mod2/DO5;0;ReadMethodType=bool;WriteMethodType=bool{92380ACF-F38C-4995-8DAE-38C9926D7E10}resource=/crio_Mod2/DO31;0;ReadMethodType=bool;WriteMethodType=bool{93A82BFE-0054-4051-98D0-3503D2B83C72}resource=/crio_Mod2/DO30;0;ReadMethodType=bool;WriteMethodType=bool{95F3EB1D-F21C-4BB8-89B2-F2A07536B318}resource=/crio_Mod2/DO25;0;ReadMethodType=bool;WriteMethodType=bool{9A4D1652-4211-44D9-B4CE-5CBBC1407D9F}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO0;0;ReadMethodType=bool;WriteMethodType=bool{9A71538B-2C08-4B1C-BEF9-69F6DC185BB5}resource=/crio_Mod2/DO24;0;ReadMethodType=bool;WriteMethodType=bool{9F3D6220-1D66-47EE-8B3C-D4EF4DAE4414}resource=/crio_Mod2/DO2;0;ReadMethodType=bool;WriteMethodType=bool{A834D41F-A0AA-41C1-BFE9-3B668046F54A}resource=/crio_Mod1/AI7;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{A9777E0D-0A90-43E2-A1FF-AA851AB680B1}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 2,crio.Type=NI 9476,cRIOModule.DisableArbitration=false,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]{AC4354E2-98F0-4345-B08E-9C5C1CCED7E3}resource=/crio_Mod2/DO20;0;ReadMethodType=bool;WriteMethodType=bool{B67D2432-C080-44F8-839E-284AAAF92252}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO6;0;ReadMethodType=bool;WriteMethodType=bool{B7EC5AB1-5BC2-4BA7-9731-23BAC7844DDE}resource=/crio_Mod1/AI1;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{BAD30D11-D7EF-4797-9213-B7C1460AB9B7}resource=/crio_Mod2/DO31:24;0;ReadMethodType=u8;WriteMethodType=u8{BC59B3B0-3F9F-4C04-B5F1-80EA5BCDB5D0}resource=/crio_Mod2/DO3;0;ReadMethodType=bool;WriteMethodType=bool{C292F3BD-279C-47BD-B3BF-9F7C52886C9A}resource=/crio_Mod2/DO13;0;ReadMethodType=bool;WriteMethodType=bool{C3C2BDD4-4601-479E-A4F4-1D77D7AD5983}resource=/crio_Mod2/DO6;0;ReadMethodType=bool;WriteMethodType=bool{C97CBBB7-2C6B-4B1A-B49D-A9DC74011F04}resource=/crio_Mod2/DO31:0;0;ReadMethodType=u32;WriteMethodType=u32{CA776B02-3F3F-4138-BDF0-FA276CD6B960}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO3;0;ReadMethodType=bool;WriteMethodType=bool{CD2B0737-B8E0-4956-9560-79561FF8FF09}resource=/crio_Mod1/AI6;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{D0A25B87-875C-4F4B-84BD-813761CA8D4E}resource=/crio_Mod2/DO9;0;ReadMethodType=bool;WriteMethodType=bool{D28513FD-B101-4CBF-A0B7-E8E0B2F35695}resource=/crio_Mod2/DO21;0;ReadMethodType=bool;WriteMethodType=bool{D6FE3F6C-07A2-4F36-A493-D808DA1E6DFD}resource=/crio_Mod2/DO19;0;ReadMethodType=bool;WriteMethodType=bool{D727619D-329D-49DF-B1AF-7EAB96FAFDD3}resource=/crio_Mod2/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8{D8738338-8ED2-464D-8337-CE2A4E2D5517}resource=/crio_Mod1/AI13;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{D8C44379-9E6E-4065-B4CD-625EB3347471}resource=/crio_Mod1/AI10;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{DA159247-06B4-4D73-B8EE-843A843FE6F1}resource=/crio_Mod2/DO15:8;0;ReadMethodType=u8;WriteMethodType=u8{DA4177DC-3B5B-49E9-A4AE-1C7B71183FF1}resource=/crio_Mod2/DO23:16;0;ReadMethodType=u8;WriteMethodType=u8{DC5EF4F7-1B8D-43E8-A710-73286CD6314D}resource=/USER FPGA LED;0;ReadMethodType=u8;WriteMethodType=u8{E1A3B581-D77A-45EA-B9BC-1AD1138053E9}resource=/crio_Mod2/DO0;0;ReadMethodType=bool;WriteMethodType=bool{E1E74FD3-674F-435D-9F66-2DC68E280CCA}resource=/crio_Mod2/DO29;0;ReadMethodType=bool;WriteMethodType=bool{E97462DE-BEB9-4A13-8D59-45E091E7C37C}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 3,crio.Type=NI 9474,cRIOModule.DIO3_0InitialDir=0,cRIOModule.DIO7_4InitialDir=0,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.NumSyncRegs=11111111,cRIOModule.RsiAttributes=[crioConfig.End]{EA7F5BAD-2CFF-4AD4-BDD1-6F733F41CCE6}resource=/crio_Mod1/AI0;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{EE270B00-0B73-4E24-BE88-084322093660}resource=/crio_Mod1/AI8;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{EEF6D39F-5095-45D2-B9EC-E8BAC7A52F6F}resource=/crio_Mod2/DO4;0;ReadMethodType=bool;WriteMethodType=bool{EF265E61-4D2C-4BBA-B532-C70E087AA46A}resource=/crio_Mod2/DO18;0;ReadMethodType=bool;WriteMethodType=bool{EF6C5760-C11B-4E13-9C97-0AA5282EB598}resource=/crio_Mod2/DO12;0;ReadMethodType=bool;WriteMethodType=bool{FA96C7D7-3EED-42A4-9B84-083E0BBA5847}resource=/crio_Mod2/DO26;0;ReadMethodType=bool;WriteMethodType=bool{FBD5CC24-3BC6-4C66-9CE5-814332FFF494}resource=/crio_Mod2/DO22;0;ReadMethodType=bool;WriteMethodType=bool{FE25D7AC-BAA3-42E3-9A1C-D82D647083FC}resource=/crio_Mod1/AI3;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{FE487018-64CC-47D9-9B1D-CC6838576CF8}resource=/crio_Mod1/AI9;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlcRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGA/[rSeriesConfig.Begin][rSeriesConfig.End]</Property>
						<Property Name="configString.name" Type="Str">40 MHz Onboard ClockResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000.000000;MaxFreq=40000000.000000;VariableFreq=0;NomFreq=40000000.000000;PeakPeriodJitter=250.000000;MinDutyCycle=50.000000;MaxDutyCycle=50.000000;Accuracy=100.000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;Chassis Temperatureresource=/Chassis Temperature;0;ReadMethodType=i16cRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGA/[rSeriesConfig.Begin][rSeriesConfig.End]Mod1/AI0resource=/crio_Mod1/AI0;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI10resource=/crio_Mod1/AI10;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI11resource=/crio_Mod1/AI11;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI12resource=/crio_Mod1/AI12;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI13resource=/crio_Mod1/AI13;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI14resource=/crio_Mod1/AI14;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI15resource=/crio_Mod1/AI15;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI1resource=/crio_Mod1/AI1;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI2resource=/crio_Mod1/AI2;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI3resource=/crio_Mod1/AI3;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI4resource=/crio_Mod1/AI4;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI5resource=/crio_Mod1/AI5;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI6resource=/crio_Mod1/AI6;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI7resource=/crio_Mod1/AI7;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI8resource=/crio_Mod1/AI8;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI9resource=/crio_Mod1/AI9;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 1,crio.Type=NI 9220,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]Mod2/DO0resource=/crio_Mod2/DO0;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO10resource=/crio_Mod2/DO10;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO11resource=/crio_Mod2/DO11;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO12resource=/crio_Mod2/DO12;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO13resource=/crio_Mod2/DO13;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO14resource=/crio_Mod2/DO14;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO15:8resource=/crio_Mod2/DO15:8;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO15resource=/crio_Mod2/DO15;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO16resource=/crio_Mod2/DO16;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO17resource=/crio_Mod2/DO17;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO18resource=/crio_Mod2/DO18;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO19resource=/crio_Mod2/DO19;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO1resource=/crio_Mod2/DO1;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO20resource=/crio_Mod2/DO20;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO21resource=/crio_Mod2/DO21;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO22resource=/crio_Mod2/DO22;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO23:16resource=/crio_Mod2/DO23:16;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO23resource=/crio_Mod2/DO23;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO24resource=/crio_Mod2/DO24;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO25resource=/crio_Mod2/DO25;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO26resource=/crio_Mod2/DO26;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO27resource=/crio_Mod2/DO27;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO28resource=/crio_Mod2/DO28;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO29resource=/crio_Mod2/DO29;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO2resource=/crio_Mod2/DO2;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO30resource=/crio_Mod2/DO30;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO31:0resource=/crio_Mod2/DO31:0;0;ReadMethodType=u32;WriteMethodType=u32Mod2/DO31:24resource=/crio_Mod2/DO31:24;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO31resource=/crio_Mod2/DO31;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO3resource=/crio_Mod2/DO3;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO4resource=/crio_Mod2/DO4;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO5resource=/crio_Mod2/DO5;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO6resource=/crio_Mod2/DO6;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO7:0resource=/crio_Mod2/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO7resource=/crio_Mod2/DO7;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO8resource=/crio_Mod2/DO8;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO9resource=/crio_Mod2/DO9;0;ReadMethodType=bool;WriteMethodType=boolMod2[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 2,crio.Type=NI 9476,cRIOModule.DisableArbitration=false,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]Mod3/DO0ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO0;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO1ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO1;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO2ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO2;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO3ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO3;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO4ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO4;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO5ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO5;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO6ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO6;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO7:0ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8Mod3/DO7ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7;0;ReadMethodType=bool;WriteMethodType=boolMod3[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 3,crio.Type=NI 9474,cRIOModule.DIO3_0InitialDir=0,cRIOModule.DIO7_4InitialDir=0,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.NumSyncRegs=11111111,cRIOModule.RsiAttributes=[crioConfig.End]Scan Clockresource=/Scan Clock;0;ReadMethodType=boolSleepresource=/Sleep;0;ReadMethodType=bool;WriteMethodType=boolSystem Resetresource=/System Reset;0;ReadMethodType=bool;WriteMethodType=boolUSER FPGA LEDresource=/USER FPGA LED;0;ReadMethodType=u8;WriteMethodType=u8</Property>
						<Property Name="NI.LV.FPGA.InterfaceBitfile" Type="Str">\\ornl\naoa\Projects\DECC-Testing\00_PROJECTS\CSEISMIC\LabVIEW\RTDS TESTING\RTDS PCC\FPGA Bitfiles\RTDSPCCControl_FPGATarget_Switchcontroller_v4.lvbitx</Property>
					</Item>
					<Item Name="Reactive Power Cluster.ctl" Type="VI" URL="../FPGA/Reactive Power Cluster.ctl">
						<Property Name="configString.guid" Type="Str">{0365254E-4C8E-498B-B908-42928D258F13}resource=/crio_Mod1/AI11;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{08196F43-DC9D-4ED8-9191-9D67550297D8}resource=/crio_Mod2/DO7;0;ReadMethodType=bool;WriteMethodType=bool{1314AFA1-DC9A-48F2-ACB6-4B35E642B7C1}resource=/Sleep;0;ReadMethodType=bool;WriteMethodType=bool{170C3CAD-048E-4EAC-BF9A-021EF3396AD7}resource=/System Reset;0;ReadMethodType=bool;WriteMethodType=bool{1ABC6A51-3C1D-4705-AD22-AB7C0A2BE3D6}resource=/crio_Mod2/DO16;0;ReadMethodType=bool;WriteMethodType=bool{274F8370-463C-4A3E-8228-15DD1C21E5B8}resource=/Chassis Temperature;0;ReadMethodType=i16{35EF4B31-373C-40D5-A4B2-B466149BB484}resource=/crio_Mod2/DO11;0;ReadMethodType=bool;WriteMethodType=bool{37E6C110-E9CE-426B-9A5A-241F03B6494A}resource=/crio_Mod2/DO17;0;ReadMethodType=bool;WriteMethodType=bool{3A6ECEBE-A39B-4502-B8D7-DB341552B293}resource=/crio_Mod2/DO14;0;ReadMethodType=bool;WriteMethodType=bool{3DDD6D76-68B9-4414-9FF9-5FB90995802B}resource=/crio_Mod2/DO10;0;ReadMethodType=bool;WriteMethodType=bool{4A0B0CE7-992D-4988-B0AF-4465498CE123}resource=/crio_Mod2/DO1;0;ReadMethodType=bool;WriteMethodType=bool{4BE00E55-86FF-4709-AFF0-8ADF6A77BEE9}resource=/crio_Mod1/AI4;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{4BF96FCD-B764-4D2F-A5A7-75A43AC2AB6A}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO2;0;ReadMethodType=bool;WriteMethodType=bool{52FBC27F-BEB9-4BC2-AA2E-0ED73651F977}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO5;0;ReadMethodType=bool;WriteMethodType=bool{6201F6E2-650E-4018-910B-F1CA297386B8}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 1,crio.Type=NI 9220,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]{6344EDBF-2AF5-4E10-BE45-693EC8C2C906}resource=/crio_Mod2/DO15;0;ReadMethodType=bool;WriteMethodType=bool{63CDB995-45FE-4322-8F86-E048B78F5DBB}resource=/crio_Mod2/DO8;0;ReadMethodType=bool;WriteMethodType=bool{698EA4EF-34A2-40D9-8EC6-8810A31E429C}resource=/crio_Mod1/AI2;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{6B2A6ABE-CA39-4F9D-9317-21C9EFEC1782}resource=/crio_Mod2/DO28;0;ReadMethodType=bool;WriteMethodType=bool{6C39B8C5-6749-4E6B-911D-62D70FB6C4FB}resource=/Scan Clock;0;ReadMethodType=bool{6CBD6814-C539-431C-8092-8479D226ECC5}resource=/crio_Mod1/AI12;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{716F0544-2C8F-4FF8-A71A-865BB5C37D94}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO1;0;ReadMethodType=bool;WriteMethodType=bool{77A59C42-9B3A-411B-9AA2-1972F8ACFAF2}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7;0;ReadMethodType=bool;WriteMethodType=bool{7AD23096-C692-4270-BCEB-7F458F7A4A2F}resource=/crio_Mod1/AI5;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{7B16127A-8AE0-49B6-84F1-E322752BFD8C}resource=/crio_Mod1/AI15;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{7C2AD387-F932-4484-B9FA-545ECC2950C4}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO4;0;ReadMethodType=bool;WriteMethodType=bool{7EFED6EA-0F1D-4DFA-93A3-BD09D2DDF918}ResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000.000000;MaxFreq=40000000.000000;VariableFreq=0;NomFreq=40000000.000000;PeakPeriodJitter=250.000000;MinDutyCycle=50.000000;MaxDutyCycle=50.000000;Accuracy=100.000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;{811229E5-B67B-4651-944C-CA70AC73BF42}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8{83E4C8DF-D408-44F2-958A-EA257EB2F570}resource=/crio_Mod2/DO27;0;ReadMethodType=bool;WriteMethodType=bool{85BA1C90-BFFD-4DFE-A9AA-7891536A1453}resource=/crio_Mod2/DO23;0;ReadMethodType=bool;WriteMethodType=bool{8824DAC7-6023-4E37-BDF3-23E95558AAFC}resource=/crio_Mod1/AI14;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{901C225A-95D6-4A9B-96BD-016CD37FF4ED}resource=/crio_Mod2/DO5;0;ReadMethodType=bool;WriteMethodType=bool{92380ACF-F38C-4995-8DAE-38C9926D7E10}resource=/crio_Mod2/DO31;0;ReadMethodType=bool;WriteMethodType=bool{93A82BFE-0054-4051-98D0-3503D2B83C72}resource=/crio_Mod2/DO30;0;ReadMethodType=bool;WriteMethodType=bool{95F3EB1D-F21C-4BB8-89B2-F2A07536B318}resource=/crio_Mod2/DO25;0;ReadMethodType=bool;WriteMethodType=bool{9A4D1652-4211-44D9-B4CE-5CBBC1407D9F}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO0;0;ReadMethodType=bool;WriteMethodType=bool{9A71538B-2C08-4B1C-BEF9-69F6DC185BB5}resource=/crio_Mod2/DO24;0;ReadMethodType=bool;WriteMethodType=bool{9F3D6220-1D66-47EE-8B3C-D4EF4DAE4414}resource=/crio_Mod2/DO2;0;ReadMethodType=bool;WriteMethodType=bool{A834D41F-A0AA-41C1-BFE9-3B668046F54A}resource=/crio_Mod1/AI7;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{A9777E0D-0A90-43E2-A1FF-AA851AB680B1}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 2,crio.Type=NI 9476,cRIOModule.DisableArbitration=false,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]{AC4354E2-98F0-4345-B08E-9C5C1CCED7E3}resource=/crio_Mod2/DO20;0;ReadMethodType=bool;WriteMethodType=bool{B67D2432-C080-44F8-839E-284AAAF92252}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO6;0;ReadMethodType=bool;WriteMethodType=bool{B7EC5AB1-5BC2-4BA7-9731-23BAC7844DDE}resource=/crio_Mod1/AI1;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{BAD30D11-D7EF-4797-9213-B7C1460AB9B7}resource=/crio_Mod2/DO31:24;0;ReadMethodType=u8;WriteMethodType=u8{BC59B3B0-3F9F-4C04-B5F1-80EA5BCDB5D0}resource=/crio_Mod2/DO3;0;ReadMethodType=bool;WriteMethodType=bool{C292F3BD-279C-47BD-B3BF-9F7C52886C9A}resource=/crio_Mod2/DO13;0;ReadMethodType=bool;WriteMethodType=bool{C3C2BDD4-4601-479E-A4F4-1D77D7AD5983}resource=/crio_Mod2/DO6;0;ReadMethodType=bool;WriteMethodType=bool{C97CBBB7-2C6B-4B1A-B49D-A9DC74011F04}resource=/crio_Mod2/DO31:0;0;ReadMethodType=u32;WriteMethodType=u32{CA776B02-3F3F-4138-BDF0-FA276CD6B960}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO3;0;ReadMethodType=bool;WriteMethodType=bool{CD2B0737-B8E0-4956-9560-79561FF8FF09}resource=/crio_Mod1/AI6;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{D0A25B87-875C-4F4B-84BD-813761CA8D4E}resource=/crio_Mod2/DO9;0;ReadMethodType=bool;WriteMethodType=bool{D28513FD-B101-4CBF-A0B7-E8E0B2F35695}resource=/crio_Mod2/DO21;0;ReadMethodType=bool;WriteMethodType=bool{D6FE3F6C-07A2-4F36-A493-D808DA1E6DFD}resource=/crio_Mod2/DO19;0;ReadMethodType=bool;WriteMethodType=bool{D727619D-329D-49DF-B1AF-7EAB96FAFDD3}resource=/crio_Mod2/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8{D8738338-8ED2-464D-8337-CE2A4E2D5517}resource=/crio_Mod1/AI13;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{D8C44379-9E6E-4065-B4CD-625EB3347471}resource=/crio_Mod1/AI10;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{DA159247-06B4-4D73-B8EE-843A843FE6F1}resource=/crio_Mod2/DO15:8;0;ReadMethodType=u8;WriteMethodType=u8{DA4177DC-3B5B-49E9-A4AE-1C7B71183FF1}resource=/crio_Mod2/DO23:16;0;ReadMethodType=u8;WriteMethodType=u8{DC5EF4F7-1B8D-43E8-A710-73286CD6314D}resource=/USER FPGA LED;0;ReadMethodType=u8;WriteMethodType=u8{E1A3B581-D77A-45EA-B9BC-1AD1138053E9}resource=/crio_Mod2/DO0;0;ReadMethodType=bool;WriteMethodType=bool{E1E74FD3-674F-435D-9F66-2DC68E280CCA}resource=/crio_Mod2/DO29;0;ReadMethodType=bool;WriteMethodType=bool{E97462DE-BEB9-4A13-8D59-45E091E7C37C}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 3,crio.Type=NI 9474,cRIOModule.DIO3_0InitialDir=0,cRIOModule.DIO7_4InitialDir=0,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.NumSyncRegs=11111111,cRIOModule.RsiAttributes=[crioConfig.End]{EA7F5BAD-2CFF-4AD4-BDD1-6F733F41CCE6}resource=/crio_Mod1/AI0;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{EE270B00-0B73-4E24-BE88-084322093660}resource=/crio_Mod1/AI8;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{EEF6D39F-5095-45D2-B9EC-E8BAC7A52F6F}resource=/crio_Mod2/DO4;0;ReadMethodType=bool;WriteMethodType=bool{EF265E61-4D2C-4BBA-B532-C70E087AA46A}resource=/crio_Mod2/DO18;0;ReadMethodType=bool;WriteMethodType=bool{EF6C5760-C11B-4E13-9C97-0AA5282EB598}resource=/crio_Mod2/DO12;0;ReadMethodType=bool;WriteMethodType=bool{FA96C7D7-3EED-42A4-9B84-083E0BBA5847}resource=/crio_Mod2/DO26;0;ReadMethodType=bool;WriteMethodType=bool{FBD5CC24-3BC6-4C66-9CE5-814332FFF494}resource=/crio_Mod2/DO22;0;ReadMethodType=bool;WriteMethodType=bool{FE25D7AC-BAA3-42E3-9A1C-D82D647083FC}resource=/crio_Mod1/AI3;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{FE487018-64CC-47D9-9B1D-CC6838576CF8}resource=/crio_Mod1/AI9;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlcRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGA/[rSeriesConfig.Begin][rSeriesConfig.End]</Property>
						<Property Name="configString.name" Type="Str">40 MHz Onboard ClockResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000.000000;MaxFreq=40000000.000000;VariableFreq=0;NomFreq=40000000.000000;PeakPeriodJitter=250.000000;MinDutyCycle=50.000000;MaxDutyCycle=50.000000;Accuracy=100.000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;Chassis Temperatureresource=/Chassis Temperature;0;ReadMethodType=i16cRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGA/[rSeriesConfig.Begin][rSeriesConfig.End]Mod1/AI0resource=/crio_Mod1/AI0;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI10resource=/crio_Mod1/AI10;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI11resource=/crio_Mod1/AI11;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI12resource=/crio_Mod1/AI12;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI13resource=/crio_Mod1/AI13;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI14resource=/crio_Mod1/AI14;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI15resource=/crio_Mod1/AI15;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI1resource=/crio_Mod1/AI1;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI2resource=/crio_Mod1/AI2;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI3resource=/crio_Mod1/AI3;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI4resource=/crio_Mod1/AI4;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI5resource=/crio_Mod1/AI5;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI6resource=/crio_Mod1/AI6;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI7resource=/crio_Mod1/AI7;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI8resource=/crio_Mod1/AI8;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI9resource=/crio_Mod1/AI9;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 1,crio.Type=NI 9220,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]Mod2/DO0resource=/crio_Mod2/DO0;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO10resource=/crio_Mod2/DO10;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO11resource=/crio_Mod2/DO11;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO12resource=/crio_Mod2/DO12;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO13resource=/crio_Mod2/DO13;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO14resource=/crio_Mod2/DO14;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO15:8resource=/crio_Mod2/DO15:8;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO15resource=/crio_Mod2/DO15;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO16resource=/crio_Mod2/DO16;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO17resource=/crio_Mod2/DO17;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO18resource=/crio_Mod2/DO18;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO19resource=/crio_Mod2/DO19;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO1resource=/crio_Mod2/DO1;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO20resource=/crio_Mod2/DO20;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO21resource=/crio_Mod2/DO21;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO22resource=/crio_Mod2/DO22;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO23:16resource=/crio_Mod2/DO23:16;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO23resource=/crio_Mod2/DO23;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO24resource=/crio_Mod2/DO24;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO25resource=/crio_Mod2/DO25;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO26resource=/crio_Mod2/DO26;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO27resource=/crio_Mod2/DO27;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO28resource=/crio_Mod2/DO28;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO29resource=/crio_Mod2/DO29;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO2resource=/crio_Mod2/DO2;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO30resource=/crio_Mod2/DO30;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO31:0resource=/crio_Mod2/DO31:0;0;ReadMethodType=u32;WriteMethodType=u32Mod2/DO31:24resource=/crio_Mod2/DO31:24;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO31resource=/crio_Mod2/DO31;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO3resource=/crio_Mod2/DO3;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO4resource=/crio_Mod2/DO4;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO5resource=/crio_Mod2/DO5;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO6resource=/crio_Mod2/DO6;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO7:0resource=/crio_Mod2/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO7resource=/crio_Mod2/DO7;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO8resource=/crio_Mod2/DO8;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO9resource=/crio_Mod2/DO9;0;ReadMethodType=bool;WriteMethodType=boolMod2[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 2,crio.Type=NI 9476,cRIOModule.DisableArbitration=false,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]Mod3/DO0ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO0;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO1ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO1;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO2ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO2;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO3ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO3;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO4ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO4;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO5ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO5;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO6ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO6;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO7:0ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8Mod3/DO7ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7;0;ReadMethodType=bool;WriteMethodType=boolMod3[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 3,crio.Type=NI 9474,cRIOModule.DIO3_0InitialDir=0,cRIOModule.DIO7_4InitialDir=0,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.NumSyncRegs=11111111,cRIOModule.RsiAttributes=[crioConfig.End]Scan Clockresource=/Scan Clock;0;ReadMethodType=boolSleepresource=/Sleep;0;ReadMethodType=bool;WriteMethodType=boolSystem Resetresource=/System Reset;0;ReadMethodType=bool;WriteMethodType=boolUSER FPGA LEDresource=/USER FPGA LED;0;ReadMethodType=u8;WriteMethodType=u8</Property>
					</Item>
					<Item Name="Switch_controller_fpga_9068_v5.vi" Type="VI" URL="../FPGA/Switch_controller_fpga_9068_v5.vi">
						<Property Name="configString.guid" Type="Str">{0365254E-4C8E-498B-B908-42928D258F13}resource=/crio_Mod1/AI11;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{08196F43-DC9D-4ED8-9191-9D67550297D8}resource=/crio_Mod2/DO7;0;ReadMethodType=bool;WriteMethodType=bool{1314AFA1-DC9A-48F2-ACB6-4B35E642B7C1}resource=/Sleep;0;ReadMethodType=bool;WriteMethodType=bool{170C3CAD-048E-4EAC-BF9A-021EF3396AD7}resource=/System Reset;0;ReadMethodType=bool;WriteMethodType=bool{1ABC6A51-3C1D-4705-AD22-AB7C0A2BE3D6}resource=/crio_Mod2/DO16;0;ReadMethodType=bool;WriteMethodType=bool{274F8370-463C-4A3E-8228-15DD1C21E5B8}resource=/Chassis Temperature;0;ReadMethodType=i16{35EF4B31-373C-40D5-A4B2-B466149BB484}resource=/crio_Mod2/DO11;0;ReadMethodType=bool;WriteMethodType=bool{37E6C110-E9CE-426B-9A5A-241F03B6494A}resource=/crio_Mod2/DO17;0;ReadMethodType=bool;WriteMethodType=bool{3A6ECEBE-A39B-4502-B8D7-DB341552B293}resource=/crio_Mod2/DO14;0;ReadMethodType=bool;WriteMethodType=bool{3DDD6D76-68B9-4414-9FF9-5FB90995802B}resource=/crio_Mod2/DO10;0;ReadMethodType=bool;WriteMethodType=bool{4A0B0CE7-992D-4988-B0AF-4465498CE123}resource=/crio_Mod2/DO1;0;ReadMethodType=bool;WriteMethodType=bool{4BE00E55-86FF-4709-AFF0-8ADF6A77BEE9}resource=/crio_Mod1/AI4;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{4BF96FCD-B764-4D2F-A5A7-75A43AC2AB6A}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO2;0;ReadMethodType=bool;WriteMethodType=bool{52FBC27F-BEB9-4BC2-AA2E-0ED73651F977}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO5;0;ReadMethodType=bool;WriteMethodType=bool{6201F6E2-650E-4018-910B-F1CA297386B8}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 1,crio.Type=NI 9220,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]{6344EDBF-2AF5-4E10-BE45-693EC8C2C906}resource=/crio_Mod2/DO15;0;ReadMethodType=bool;WriteMethodType=bool{63CDB995-45FE-4322-8F86-E048B78F5DBB}resource=/crio_Mod2/DO8;0;ReadMethodType=bool;WriteMethodType=bool{698EA4EF-34A2-40D9-8EC6-8810A31E429C}resource=/crio_Mod1/AI2;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{6B2A6ABE-CA39-4F9D-9317-21C9EFEC1782}resource=/crio_Mod2/DO28;0;ReadMethodType=bool;WriteMethodType=bool{6C39B8C5-6749-4E6B-911D-62D70FB6C4FB}resource=/Scan Clock;0;ReadMethodType=bool{6CBD6814-C539-431C-8092-8479D226ECC5}resource=/crio_Mod1/AI12;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{716F0544-2C8F-4FF8-A71A-865BB5C37D94}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO1;0;ReadMethodType=bool;WriteMethodType=bool{77A59C42-9B3A-411B-9AA2-1972F8ACFAF2}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7;0;ReadMethodType=bool;WriteMethodType=bool{7AD23096-C692-4270-BCEB-7F458F7A4A2F}resource=/crio_Mod1/AI5;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{7B16127A-8AE0-49B6-84F1-E322752BFD8C}resource=/crio_Mod1/AI15;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{7C2AD387-F932-4484-B9FA-545ECC2950C4}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO4;0;ReadMethodType=bool;WriteMethodType=bool{7EFED6EA-0F1D-4DFA-93A3-BD09D2DDF918}ResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000.000000;MaxFreq=40000000.000000;VariableFreq=0;NomFreq=40000000.000000;PeakPeriodJitter=250.000000;MinDutyCycle=50.000000;MaxDutyCycle=50.000000;Accuracy=100.000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;{811229E5-B67B-4651-944C-CA70AC73BF42}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8{83E4C8DF-D408-44F2-958A-EA257EB2F570}resource=/crio_Mod2/DO27;0;ReadMethodType=bool;WriteMethodType=bool{85BA1C90-BFFD-4DFE-A9AA-7891536A1453}resource=/crio_Mod2/DO23;0;ReadMethodType=bool;WriteMethodType=bool{8824DAC7-6023-4E37-BDF3-23E95558AAFC}resource=/crio_Mod1/AI14;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{901C225A-95D6-4A9B-96BD-016CD37FF4ED}resource=/crio_Mod2/DO5;0;ReadMethodType=bool;WriteMethodType=bool{92380ACF-F38C-4995-8DAE-38C9926D7E10}resource=/crio_Mod2/DO31;0;ReadMethodType=bool;WriteMethodType=bool{93A82BFE-0054-4051-98D0-3503D2B83C72}resource=/crio_Mod2/DO30;0;ReadMethodType=bool;WriteMethodType=bool{95F3EB1D-F21C-4BB8-89B2-F2A07536B318}resource=/crio_Mod2/DO25;0;ReadMethodType=bool;WriteMethodType=bool{9A4D1652-4211-44D9-B4CE-5CBBC1407D9F}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO0;0;ReadMethodType=bool;WriteMethodType=bool{9A71538B-2C08-4B1C-BEF9-69F6DC185BB5}resource=/crio_Mod2/DO24;0;ReadMethodType=bool;WriteMethodType=bool{9F3D6220-1D66-47EE-8B3C-D4EF4DAE4414}resource=/crio_Mod2/DO2;0;ReadMethodType=bool;WriteMethodType=bool{A834D41F-A0AA-41C1-BFE9-3B668046F54A}resource=/crio_Mod1/AI7;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{A9777E0D-0A90-43E2-A1FF-AA851AB680B1}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 2,crio.Type=NI 9476,cRIOModule.DisableArbitration=false,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]{AC4354E2-98F0-4345-B08E-9C5C1CCED7E3}resource=/crio_Mod2/DO20;0;ReadMethodType=bool;WriteMethodType=bool{B67D2432-C080-44F8-839E-284AAAF92252}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO6;0;ReadMethodType=bool;WriteMethodType=bool{B7EC5AB1-5BC2-4BA7-9731-23BAC7844DDE}resource=/crio_Mod1/AI1;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{BAD30D11-D7EF-4797-9213-B7C1460AB9B7}resource=/crio_Mod2/DO31:24;0;ReadMethodType=u8;WriteMethodType=u8{BC59B3B0-3F9F-4C04-B5F1-80EA5BCDB5D0}resource=/crio_Mod2/DO3;0;ReadMethodType=bool;WriteMethodType=bool{C292F3BD-279C-47BD-B3BF-9F7C52886C9A}resource=/crio_Mod2/DO13;0;ReadMethodType=bool;WriteMethodType=bool{C3C2BDD4-4601-479E-A4F4-1D77D7AD5983}resource=/crio_Mod2/DO6;0;ReadMethodType=bool;WriteMethodType=bool{C97CBBB7-2C6B-4B1A-B49D-A9DC74011F04}resource=/crio_Mod2/DO31:0;0;ReadMethodType=u32;WriteMethodType=u32{CA776B02-3F3F-4138-BDF0-FA276CD6B960}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO3;0;ReadMethodType=bool;WriteMethodType=bool{CD2B0737-B8E0-4956-9560-79561FF8FF09}resource=/crio_Mod1/AI6;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{D0A25B87-875C-4F4B-84BD-813761CA8D4E}resource=/crio_Mod2/DO9;0;ReadMethodType=bool;WriteMethodType=bool{D28513FD-B101-4CBF-A0B7-E8E0B2F35695}resource=/crio_Mod2/DO21;0;ReadMethodType=bool;WriteMethodType=bool{D6FE3F6C-07A2-4F36-A493-D808DA1E6DFD}resource=/crio_Mod2/DO19;0;ReadMethodType=bool;WriteMethodType=bool{D727619D-329D-49DF-B1AF-7EAB96FAFDD3}resource=/crio_Mod2/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8{D8738338-8ED2-464D-8337-CE2A4E2D5517}resource=/crio_Mod1/AI13;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{D8C44379-9E6E-4065-B4CD-625EB3347471}resource=/crio_Mod1/AI10;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{DA159247-06B4-4D73-B8EE-843A843FE6F1}resource=/crio_Mod2/DO15:8;0;ReadMethodType=u8;WriteMethodType=u8{DA4177DC-3B5B-49E9-A4AE-1C7B71183FF1}resource=/crio_Mod2/DO23:16;0;ReadMethodType=u8;WriteMethodType=u8{DC5EF4F7-1B8D-43E8-A710-73286CD6314D}resource=/USER FPGA LED;0;ReadMethodType=u8;WriteMethodType=u8{E1A3B581-D77A-45EA-B9BC-1AD1138053E9}resource=/crio_Mod2/DO0;0;ReadMethodType=bool;WriteMethodType=bool{E1E74FD3-674F-435D-9F66-2DC68E280CCA}resource=/crio_Mod2/DO29;0;ReadMethodType=bool;WriteMethodType=bool{E97462DE-BEB9-4A13-8D59-45E091E7C37C}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 3,crio.Type=NI 9474,cRIOModule.DIO3_0InitialDir=0,cRIOModule.DIO7_4InitialDir=0,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.NumSyncRegs=11111111,cRIOModule.RsiAttributes=[crioConfig.End]{EA7F5BAD-2CFF-4AD4-BDD1-6F733F41CCE6}resource=/crio_Mod1/AI0;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{EE270B00-0B73-4E24-BE88-084322093660}resource=/crio_Mod1/AI8;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{EEF6D39F-5095-45D2-B9EC-E8BAC7A52F6F}resource=/crio_Mod2/DO4;0;ReadMethodType=bool;WriteMethodType=bool{EF265E61-4D2C-4BBA-B532-C70E087AA46A}resource=/crio_Mod2/DO18;0;ReadMethodType=bool;WriteMethodType=bool{EF6C5760-C11B-4E13-9C97-0AA5282EB598}resource=/crio_Mod2/DO12;0;ReadMethodType=bool;WriteMethodType=bool{FA96C7D7-3EED-42A4-9B84-083E0BBA5847}resource=/crio_Mod2/DO26;0;ReadMethodType=bool;WriteMethodType=bool{FBD5CC24-3BC6-4C66-9CE5-814332FFF494}resource=/crio_Mod2/DO22;0;ReadMethodType=bool;WriteMethodType=bool{FE25D7AC-BAA3-42E3-9A1C-D82D647083FC}resource=/crio_Mod1/AI3;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{FE487018-64CC-47D9-9B1D-CC6838576CF8}resource=/crio_Mod1/AI9;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlcRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGA/[rSeriesConfig.Begin][rSeriesConfig.End]</Property>
						<Property Name="configString.name" Type="Str">40 MHz Onboard ClockResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000.000000;MaxFreq=40000000.000000;VariableFreq=0;NomFreq=40000000.000000;PeakPeriodJitter=250.000000;MinDutyCycle=50.000000;MaxDutyCycle=50.000000;Accuracy=100.000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;Chassis Temperatureresource=/Chassis Temperature;0;ReadMethodType=i16cRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGA/[rSeriesConfig.Begin][rSeriesConfig.End]Mod1/AI0resource=/crio_Mod1/AI0;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI10resource=/crio_Mod1/AI10;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI11resource=/crio_Mod1/AI11;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI12resource=/crio_Mod1/AI12;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI13resource=/crio_Mod1/AI13;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI14resource=/crio_Mod1/AI14;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI15resource=/crio_Mod1/AI15;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI1resource=/crio_Mod1/AI1;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI2resource=/crio_Mod1/AI2;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI3resource=/crio_Mod1/AI3;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI4resource=/crio_Mod1/AI4;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI5resource=/crio_Mod1/AI5;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI6resource=/crio_Mod1/AI6;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI7resource=/crio_Mod1/AI7;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI8resource=/crio_Mod1/AI8;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI9resource=/crio_Mod1/AI9;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 1,crio.Type=NI 9220,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]Mod2/DO0resource=/crio_Mod2/DO0;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO10resource=/crio_Mod2/DO10;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO11resource=/crio_Mod2/DO11;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO12resource=/crio_Mod2/DO12;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO13resource=/crio_Mod2/DO13;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO14resource=/crio_Mod2/DO14;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO15:8resource=/crio_Mod2/DO15:8;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO15resource=/crio_Mod2/DO15;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO16resource=/crio_Mod2/DO16;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO17resource=/crio_Mod2/DO17;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO18resource=/crio_Mod2/DO18;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO19resource=/crio_Mod2/DO19;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO1resource=/crio_Mod2/DO1;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO20resource=/crio_Mod2/DO20;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO21resource=/crio_Mod2/DO21;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO22resource=/crio_Mod2/DO22;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO23:16resource=/crio_Mod2/DO23:16;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO23resource=/crio_Mod2/DO23;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO24resource=/crio_Mod2/DO24;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO25resource=/crio_Mod2/DO25;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO26resource=/crio_Mod2/DO26;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO27resource=/crio_Mod2/DO27;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO28resource=/crio_Mod2/DO28;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO29resource=/crio_Mod2/DO29;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO2resource=/crio_Mod2/DO2;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO30resource=/crio_Mod2/DO30;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO31:0resource=/crio_Mod2/DO31:0;0;ReadMethodType=u32;WriteMethodType=u32Mod2/DO31:24resource=/crio_Mod2/DO31:24;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO31resource=/crio_Mod2/DO31;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO3resource=/crio_Mod2/DO3;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO4resource=/crio_Mod2/DO4;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO5resource=/crio_Mod2/DO5;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO6resource=/crio_Mod2/DO6;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO7:0resource=/crio_Mod2/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO7resource=/crio_Mod2/DO7;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO8resource=/crio_Mod2/DO8;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO9resource=/crio_Mod2/DO9;0;ReadMethodType=bool;WriteMethodType=boolMod2[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 2,crio.Type=NI 9476,cRIOModule.DisableArbitration=false,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]Mod3/DO0ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO0;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO1ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO1;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO2ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO2;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO3ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO3;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO4ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO4;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO5ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO5;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO6ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO6;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO7:0ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8Mod3/DO7ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7;0;ReadMethodType=bool;WriteMethodType=boolMod3[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 3,crio.Type=NI 9474,cRIOModule.DIO3_0InitialDir=0,cRIOModule.DIO7_4InitialDir=0,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.NumSyncRegs=11111111,cRIOModule.RsiAttributes=[crioConfig.End]Scan Clockresource=/Scan Clock;0;ReadMethodType=boolSleepresource=/Sleep;0;ReadMethodType=bool;WriteMethodType=boolSystem Resetresource=/System Reset;0;ReadMethodType=bool;WriteMethodType=boolUSER FPGA LEDresource=/USER FPGA LED;0;ReadMethodType=u8;WriteMethodType=u8</Property>
					</Item>
				</Item>
				<Item Name="Debugging" Type="Folder">
					<Item Name="FPGA_RTDS_PCC_v02b_clean.vi" Type="VI" URL="../FPGA/FPGA_RTDS_PCC_v02b_clean.vi">
						<Property Name="BuildSpec" Type="Str">{97565660-AF58-4718-AF81-C3F82785854A}</Property>
						<Property Name="configString.guid" Type="Str">{0365254E-4C8E-498B-B908-42928D258F13}resource=/crio_Mod1/AI11;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{08196F43-DC9D-4ED8-9191-9D67550297D8}resource=/crio_Mod2/DO7;0;ReadMethodType=bool;WriteMethodType=bool{1314AFA1-DC9A-48F2-ACB6-4B35E642B7C1}resource=/Sleep;0;ReadMethodType=bool;WriteMethodType=bool{170C3CAD-048E-4EAC-BF9A-021EF3396AD7}resource=/System Reset;0;ReadMethodType=bool;WriteMethodType=bool{1ABC6A51-3C1D-4705-AD22-AB7C0A2BE3D6}resource=/crio_Mod2/DO16;0;ReadMethodType=bool;WriteMethodType=bool{274F8370-463C-4A3E-8228-15DD1C21E5B8}resource=/Chassis Temperature;0;ReadMethodType=i16{35EF4B31-373C-40D5-A4B2-B466149BB484}resource=/crio_Mod2/DO11;0;ReadMethodType=bool;WriteMethodType=bool{37E6C110-E9CE-426B-9A5A-241F03B6494A}resource=/crio_Mod2/DO17;0;ReadMethodType=bool;WriteMethodType=bool{3A6ECEBE-A39B-4502-B8D7-DB341552B293}resource=/crio_Mod2/DO14;0;ReadMethodType=bool;WriteMethodType=bool{3DDD6D76-68B9-4414-9FF9-5FB90995802B}resource=/crio_Mod2/DO10;0;ReadMethodType=bool;WriteMethodType=bool{4A0B0CE7-992D-4988-B0AF-4465498CE123}resource=/crio_Mod2/DO1;0;ReadMethodType=bool;WriteMethodType=bool{4BE00E55-86FF-4709-AFF0-8ADF6A77BEE9}resource=/crio_Mod1/AI4;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{4BF96FCD-B764-4D2F-A5A7-75A43AC2AB6A}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO2;0;ReadMethodType=bool;WriteMethodType=bool{52FBC27F-BEB9-4BC2-AA2E-0ED73651F977}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO5;0;ReadMethodType=bool;WriteMethodType=bool{6201F6E2-650E-4018-910B-F1CA297386B8}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 1,crio.Type=NI 9220,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]{6344EDBF-2AF5-4E10-BE45-693EC8C2C906}resource=/crio_Mod2/DO15;0;ReadMethodType=bool;WriteMethodType=bool{63CDB995-45FE-4322-8F86-E048B78F5DBB}resource=/crio_Mod2/DO8;0;ReadMethodType=bool;WriteMethodType=bool{698EA4EF-34A2-40D9-8EC6-8810A31E429C}resource=/crio_Mod1/AI2;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{6B2A6ABE-CA39-4F9D-9317-21C9EFEC1782}resource=/crio_Mod2/DO28;0;ReadMethodType=bool;WriteMethodType=bool{6C39B8C5-6749-4E6B-911D-62D70FB6C4FB}resource=/Scan Clock;0;ReadMethodType=bool{6CBD6814-C539-431C-8092-8479D226ECC5}resource=/crio_Mod1/AI12;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{716F0544-2C8F-4FF8-A71A-865BB5C37D94}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO1;0;ReadMethodType=bool;WriteMethodType=bool{77A59C42-9B3A-411B-9AA2-1972F8ACFAF2}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7;0;ReadMethodType=bool;WriteMethodType=bool{7AD23096-C692-4270-BCEB-7F458F7A4A2F}resource=/crio_Mod1/AI5;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{7B16127A-8AE0-49B6-84F1-E322752BFD8C}resource=/crio_Mod1/AI15;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{7C2AD387-F932-4484-B9FA-545ECC2950C4}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO4;0;ReadMethodType=bool;WriteMethodType=bool{7EFED6EA-0F1D-4DFA-93A3-BD09D2DDF918}ResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000.000000;MaxFreq=40000000.000000;VariableFreq=0;NomFreq=40000000.000000;PeakPeriodJitter=250.000000;MinDutyCycle=50.000000;MaxDutyCycle=50.000000;Accuracy=100.000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;{811229E5-B67B-4651-944C-CA70AC73BF42}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8{83E4C8DF-D408-44F2-958A-EA257EB2F570}resource=/crio_Mod2/DO27;0;ReadMethodType=bool;WriteMethodType=bool{85BA1C90-BFFD-4DFE-A9AA-7891536A1453}resource=/crio_Mod2/DO23;0;ReadMethodType=bool;WriteMethodType=bool{8824DAC7-6023-4E37-BDF3-23E95558AAFC}resource=/crio_Mod1/AI14;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{901C225A-95D6-4A9B-96BD-016CD37FF4ED}resource=/crio_Mod2/DO5;0;ReadMethodType=bool;WriteMethodType=bool{92380ACF-F38C-4995-8DAE-38C9926D7E10}resource=/crio_Mod2/DO31;0;ReadMethodType=bool;WriteMethodType=bool{93A82BFE-0054-4051-98D0-3503D2B83C72}resource=/crio_Mod2/DO30;0;ReadMethodType=bool;WriteMethodType=bool{95F3EB1D-F21C-4BB8-89B2-F2A07536B318}resource=/crio_Mod2/DO25;0;ReadMethodType=bool;WriteMethodType=bool{9A4D1652-4211-44D9-B4CE-5CBBC1407D9F}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO0;0;ReadMethodType=bool;WriteMethodType=bool{9A71538B-2C08-4B1C-BEF9-69F6DC185BB5}resource=/crio_Mod2/DO24;0;ReadMethodType=bool;WriteMethodType=bool{9F3D6220-1D66-47EE-8B3C-D4EF4DAE4414}resource=/crio_Mod2/DO2;0;ReadMethodType=bool;WriteMethodType=bool{A834D41F-A0AA-41C1-BFE9-3B668046F54A}resource=/crio_Mod1/AI7;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{A9777E0D-0A90-43E2-A1FF-AA851AB680B1}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 2,crio.Type=NI 9476,cRIOModule.DisableArbitration=false,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]{AC4354E2-98F0-4345-B08E-9C5C1CCED7E3}resource=/crio_Mod2/DO20;0;ReadMethodType=bool;WriteMethodType=bool{B67D2432-C080-44F8-839E-284AAAF92252}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO6;0;ReadMethodType=bool;WriteMethodType=bool{B7EC5AB1-5BC2-4BA7-9731-23BAC7844DDE}resource=/crio_Mod1/AI1;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{BAD30D11-D7EF-4797-9213-B7C1460AB9B7}resource=/crio_Mod2/DO31:24;0;ReadMethodType=u8;WriteMethodType=u8{BC59B3B0-3F9F-4C04-B5F1-80EA5BCDB5D0}resource=/crio_Mod2/DO3;0;ReadMethodType=bool;WriteMethodType=bool{C292F3BD-279C-47BD-B3BF-9F7C52886C9A}resource=/crio_Mod2/DO13;0;ReadMethodType=bool;WriteMethodType=bool{C3C2BDD4-4601-479E-A4F4-1D77D7AD5983}resource=/crio_Mod2/DO6;0;ReadMethodType=bool;WriteMethodType=bool{C97CBBB7-2C6B-4B1A-B49D-A9DC74011F04}resource=/crio_Mod2/DO31:0;0;ReadMethodType=u32;WriteMethodType=u32{CA776B02-3F3F-4138-BDF0-FA276CD6B960}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO3;0;ReadMethodType=bool;WriteMethodType=bool{CD2B0737-B8E0-4956-9560-79561FF8FF09}resource=/crio_Mod1/AI6;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{D0A25B87-875C-4F4B-84BD-813761CA8D4E}resource=/crio_Mod2/DO9;0;ReadMethodType=bool;WriteMethodType=bool{D28513FD-B101-4CBF-A0B7-E8E0B2F35695}resource=/crio_Mod2/DO21;0;ReadMethodType=bool;WriteMethodType=bool{D6FE3F6C-07A2-4F36-A493-D808DA1E6DFD}resource=/crio_Mod2/DO19;0;ReadMethodType=bool;WriteMethodType=bool{D727619D-329D-49DF-B1AF-7EAB96FAFDD3}resource=/crio_Mod2/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8{D8738338-8ED2-464D-8337-CE2A4E2D5517}resource=/crio_Mod1/AI13;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{D8C44379-9E6E-4065-B4CD-625EB3347471}resource=/crio_Mod1/AI10;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{DA159247-06B4-4D73-B8EE-843A843FE6F1}resource=/crio_Mod2/DO15:8;0;ReadMethodType=u8;WriteMethodType=u8{DA4177DC-3B5B-49E9-A4AE-1C7B71183FF1}resource=/crio_Mod2/DO23:16;0;ReadMethodType=u8;WriteMethodType=u8{DC5EF4F7-1B8D-43E8-A710-73286CD6314D}resource=/USER FPGA LED;0;ReadMethodType=u8;WriteMethodType=u8{E1A3B581-D77A-45EA-B9BC-1AD1138053E9}resource=/crio_Mod2/DO0;0;ReadMethodType=bool;WriteMethodType=bool{E1E74FD3-674F-435D-9F66-2DC68E280CCA}resource=/crio_Mod2/DO29;0;ReadMethodType=bool;WriteMethodType=bool{E97462DE-BEB9-4A13-8D59-45E091E7C37C}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 3,crio.Type=NI 9474,cRIOModule.DIO3_0InitialDir=0,cRIOModule.DIO7_4InitialDir=0,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.NumSyncRegs=11111111,cRIOModule.RsiAttributes=[crioConfig.End]{EA7F5BAD-2CFF-4AD4-BDD1-6F733F41CCE6}resource=/crio_Mod1/AI0;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{EE270B00-0B73-4E24-BE88-084322093660}resource=/crio_Mod1/AI8;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{EEF6D39F-5095-45D2-B9EC-E8BAC7A52F6F}resource=/crio_Mod2/DO4;0;ReadMethodType=bool;WriteMethodType=bool{EF265E61-4D2C-4BBA-B532-C70E087AA46A}resource=/crio_Mod2/DO18;0;ReadMethodType=bool;WriteMethodType=bool{EF6C5760-C11B-4E13-9C97-0AA5282EB598}resource=/crio_Mod2/DO12;0;ReadMethodType=bool;WriteMethodType=bool{FA96C7D7-3EED-42A4-9B84-083E0BBA5847}resource=/crio_Mod2/DO26;0;ReadMethodType=bool;WriteMethodType=bool{FBD5CC24-3BC6-4C66-9CE5-814332FFF494}resource=/crio_Mod2/DO22;0;ReadMethodType=bool;WriteMethodType=bool{FE25D7AC-BAA3-42E3-9A1C-D82D647083FC}resource=/crio_Mod1/AI3;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{FE487018-64CC-47D9-9B1D-CC6838576CF8}resource=/crio_Mod1/AI9;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlcRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGA/[rSeriesConfig.Begin][rSeriesConfig.End]</Property>
						<Property Name="configString.name" Type="Str">40 MHz Onboard ClockResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000.000000;MaxFreq=40000000.000000;VariableFreq=0;NomFreq=40000000.000000;PeakPeriodJitter=250.000000;MinDutyCycle=50.000000;MaxDutyCycle=50.000000;Accuracy=100.000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;Chassis Temperatureresource=/Chassis Temperature;0;ReadMethodType=i16cRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGA/[rSeriesConfig.Begin][rSeriesConfig.End]Mod1/AI0resource=/crio_Mod1/AI0;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI10resource=/crio_Mod1/AI10;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI11resource=/crio_Mod1/AI11;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI12resource=/crio_Mod1/AI12;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI13resource=/crio_Mod1/AI13;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI14resource=/crio_Mod1/AI14;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI15resource=/crio_Mod1/AI15;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI1resource=/crio_Mod1/AI1;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI2resource=/crio_Mod1/AI2;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI3resource=/crio_Mod1/AI3;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI4resource=/crio_Mod1/AI4;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI5resource=/crio_Mod1/AI5;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI6resource=/crio_Mod1/AI6;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI7resource=/crio_Mod1/AI7;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI8resource=/crio_Mod1/AI8;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI9resource=/crio_Mod1/AI9;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 1,crio.Type=NI 9220,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]Mod2/DO0resource=/crio_Mod2/DO0;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO10resource=/crio_Mod2/DO10;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO11resource=/crio_Mod2/DO11;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO12resource=/crio_Mod2/DO12;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO13resource=/crio_Mod2/DO13;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO14resource=/crio_Mod2/DO14;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO15:8resource=/crio_Mod2/DO15:8;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO15resource=/crio_Mod2/DO15;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO16resource=/crio_Mod2/DO16;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO17resource=/crio_Mod2/DO17;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO18resource=/crio_Mod2/DO18;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO19resource=/crio_Mod2/DO19;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO1resource=/crio_Mod2/DO1;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO20resource=/crio_Mod2/DO20;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO21resource=/crio_Mod2/DO21;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO22resource=/crio_Mod2/DO22;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO23:16resource=/crio_Mod2/DO23:16;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO23resource=/crio_Mod2/DO23;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO24resource=/crio_Mod2/DO24;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO25resource=/crio_Mod2/DO25;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO26resource=/crio_Mod2/DO26;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO27resource=/crio_Mod2/DO27;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO28resource=/crio_Mod2/DO28;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO29resource=/crio_Mod2/DO29;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO2resource=/crio_Mod2/DO2;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO30resource=/crio_Mod2/DO30;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO31:0resource=/crio_Mod2/DO31:0;0;ReadMethodType=u32;WriteMethodType=u32Mod2/DO31:24resource=/crio_Mod2/DO31:24;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO31resource=/crio_Mod2/DO31;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO3resource=/crio_Mod2/DO3;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO4resource=/crio_Mod2/DO4;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO5resource=/crio_Mod2/DO5;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO6resource=/crio_Mod2/DO6;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO7:0resource=/crio_Mod2/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO7resource=/crio_Mod2/DO7;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO8resource=/crio_Mod2/DO8;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO9resource=/crio_Mod2/DO9;0;ReadMethodType=bool;WriteMethodType=boolMod2[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 2,crio.Type=NI 9476,cRIOModule.DisableArbitration=false,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]Mod3/DO0ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO0;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO1ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO1;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO2ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO2;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO3ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO3;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO4ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO4;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO5ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO5;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO6ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO6;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO7:0ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8Mod3/DO7ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7;0;ReadMethodType=bool;WriteMethodType=boolMod3[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 3,crio.Type=NI 9474,cRIOModule.DIO3_0InitialDir=0,cRIOModule.DIO7_4InitialDir=0,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.NumSyncRegs=11111111,cRIOModule.RsiAttributes=[crioConfig.End]Scan Clockresource=/Scan Clock;0;ReadMethodType=boolSleepresource=/Sleep;0;ReadMethodType=bool;WriteMethodType=boolSystem Resetresource=/System Reset;0;ReadMethodType=bool;WriteMethodType=boolUSER FPGA LEDresource=/USER FPGA LED;0;ReadMethodType=u8;WriteMethodType=u8</Property>
						<Property Name="NI.LV.FPGA.InterfaceBitfile" Type="Str">\\ornl\naoa\Projects\DECC-Testing\00_PROJECTS\CSEISMIC\LabVIEW\RTDS TESTING 2015 SP1\RTDS PCC\FPGA Bitfiles\RTDSPCCControl_FPGATarget_FPGARTDSPCCv02b.lvbitx</Property>
					</Item>
				</Item>
				<Item Name="Switch_controller_fpga_9068_v3.vi" Type="VI" URL="../FPGA/Switch_controller_fpga_9068_v3.vi">
					<Property Name="configString.guid" Type="Str">{0365254E-4C8E-498B-B908-42928D258F13}resource=/crio_Mod1/AI11;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{08196F43-DC9D-4ED8-9191-9D67550297D8}resource=/crio_Mod2/DO7;0;ReadMethodType=bool;WriteMethodType=bool{1314AFA1-DC9A-48F2-ACB6-4B35E642B7C1}resource=/Sleep;0;ReadMethodType=bool;WriteMethodType=bool{170C3CAD-048E-4EAC-BF9A-021EF3396AD7}resource=/System Reset;0;ReadMethodType=bool;WriteMethodType=bool{1ABC6A51-3C1D-4705-AD22-AB7C0A2BE3D6}resource=/crio_Mod2/DO16;0;ReadMethodType=bool;WriteMethodType=bool{274F8370-463C-4A3E-8228-15DD1C21E5B8}resource=/Chassis Temperature;0;ReadMethodType=i16{35EF4B31-373C-40D5-A4B2-B466149BB484}resource=/crio_Mod2/DO11;0;ReadMethodType=bool;WriteMethodType=bool{37E6C110-E9CE-426B-9A5A-241F03B6494A}resource=/crio_Mod2/DO17;0;ReadMethodType=bool;WriteMethodType=bool{3A6ECEBE-A39B-4502-B8D7-DB341552B293}resource=/crio_Mod2/DO14;0;ReadMethodType=bool;WriteMethodType=bool{3DDD6D76-68B9-4414-9FF9-5FB90995802B}resource=/crio_Mod2/DO10;0;ReadMethodType=bool;WriteMethodType=bool{4A0B0CE7-992D-4988-B0AF-4465498CE123}resource=/crio_Mod2/DO1;0;ReadMethodType=bool;WriteMethodType=bool{4BE00E55-86FF-4709-AFF0-8ADF6A77BEE9}resource=/crio_Mod1/AI4;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{4BF96FCD-B764-4D2F-A5A7-75A43AC2AB6A}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO2;0;ReadMethodType=bool;WriteMethodType=bool{52FBC27F-BEB9-4BC2-AA2E-0ED73651F977}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO5;0;ReadMethodType=bool;WriteMethodType=bool{6201F6E2-650E-4018-910B-F1CA297386B8}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 1,crio.Type=NI 9220,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]{6344EDBF-2AF5-4E10-BE45-693EC8C2C906}resource=/crio_Mod2/DO15;0;ReadMethodType=bool;WriteMethodType=bool{63CDB995-45FE-4322-8F86-E048B78F5DBB}resource=/crio_Mod2/DO8;0;ReadMethodType=bool;WriteMethodType=bool{698EA4EF-34A2-40D9-8EC6-8810A31E429C}resource=/crio_Mod1/AI2;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{6B2A6ABE-CA39-4F9D-9317-21C9EFEC1782}resource=/crio_Mod2/DO28;0;ReadMethodType=bool;WriteMethodType=bool{6C39B8C5-6749-4E6B-911D-62D70FB6C4FB}resource=/Scan Clock;0;ReadMethodType=bool{6CBD6814-C539-431C-8092-8479D226ECC5}resource=/crio_Mod1/AI12;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{716F0544-2C8F-4FF8-A71A-865BB5C37D94}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO1;0;ReadMethodType=bool;WriteMethodType=bool{77A59C42-9B3A-411B-9AA2-1972F8ACFAF2}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7;0;ReadMethodType=bool;WriteMethodType=bool{7AD23096-C692-4270-BCEB-7F458F7A4A2F}resource=/crio_Mod1/AI5;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{7B16127A-8AE0-49B6-84F1-E322752BFD8C}resource=/crio_Mod1/AI15;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{7C2AD387-F932-4484-B9FA-545ECC2950C4}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO4;0;ReadMethodType=bool;WriteMethodType=bool{7EFED6EA-0F1D-4DFA-93A3-BD09D2DDF918}ResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000.000000;MaxFreq=40000000.000000;VariableFreq=0;NomFreq=40000000.000000;PeakPeriodJitter=250.000000;MinDutyCycle=50.000000;MaxDutyCycle=50.000000;Accuracy=100.000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;{811229E5-B67B-4651-944C-CA70AC73BF42}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8{83E4C8DF-D408-44F2-958A-EA257EB2F570}resource=/crio_Mod2/DO27;0;ReadMethodType=bool;WriteMethodType=bool{85BA1C90-BFFD-4DFE-A9AA-7891536A1453}resource=/crio_Mod2/DO23;0;ReadMethodType=bool;WriteMethodType=bool{8824DAC7-6023-4E37-BDF3-23E95558AAFC}resource=/crio_Mod1/AI14;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{901C225A-95D6-4A9B-96BD-016CD37FF4ED}resource=/crio_Mod2/DO5;0;ReadMethodType=bool;WriteMethodType=bool{92380ACF-F38C-4995-8DAE-38C9926D7E10}resource=/crio_Mod2/DO31;0;ReadMethodType=bool;WriteMethodType=bool{93A82BFE-0054-4051-98D0-3503D2B83C72}resource=/crio_Mod2/DO30;0;ReadMethodType=bool;WriteMethodType=bool{95F3EB1D-F21C-4BB8-89B2-F2A07536B318}resource=/crio_Mod2/DO25;0;ReadMethodType=bool;WriteMethodType=bool{9A4D1652-4211-44D9-B4CE-5CBBC1407D9F}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO0;0;ReadMethodType=bool;WriteMethodType=bool{9A71538B-2C08-4B1C-BEF9-69F6DC185BB5}resource=/crio_Mod2/DO24;0;ReadMethodType=bool;WriteMethodType=bool{9F3D6220-1D66-47EE-8B3C-D4EF4DAE4414}resource=/crio_Mod2/DO2;0;ReadMethodType=bool;WriteMethodType=bool{A834D41F-A0AA-41C1-BFE9-3B668046F54A}resource=/crio_Mod1/AI7;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{A9777E0D-0A90-43E2-A1FF-AA851AB680B1}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 2,crio.Type=NI 9476,cRIOModule.DisableArbitration=false,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]{AC4354E2-98F0-4345-B08E-9C5C1CCED7E3}resource=/crio_Mod2/DO20;0;ReadMethodType=bool;WriteMethodType=bool{B67D2432-C080-44F8-839E-284AAAF92252}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO6;0;ReadMethodType=bool;WriteMethodType=bool{B7EC5AB1-5BC2-4BA7-9731-23BAC7844DDE}resource=/crio_Mod1/AI1;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{BAD30D11-D7EF-4797-9213-B7C1460AB9B7}resource=/crio_Mod2/DO31:24;0;ReadMethodType=u8;WriteMethodType=u8{BC59B3B0-3F9F-4C04-B5F1-80EA5BCDB5D0}resource=/crio_Mod2/DO3;0;ReadMethodType=bool;WriteMethodType=bool{C292F3BD-279C-47BD-B3BF-9F7C52886C9A}resource=/crio_Mod2/DO13;0;ReadMethodType=bool;WriteMethodType=bool{C3C2BDD4-4601-479E-A4F4-1D77D7AD5983}resource=/crio_Mod2/DO6;0;ReadMethodType=bool;WriteMethodType=bool{C97CBBB7-2C6B-4B1A-B49D-A9DC74011F04}resource=/crio_Mod2/DO31:0;0;ReadMethodType=u32;WriteMethodType=u32{CA776B02-3F3F-4138-BDF0-FA276CD6B960}ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO3;0;ReadMethodType=bool;WriteMethodType=bool{CD2B0737-B8E0-4956-9560-79561FF8FF09}resource=/crio_Mod1/AI6;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{D0A25B87-875C-4F4B-84BD-813761CA8D4E}resource=/crio_Mod2/DO9;0;ReadMethodType=bool;WriteMethodType=bool{D28513FD-B101-4CBF-A0B7-E8E0B2F35695}resource=/crio_Mod2/DO21;0;ReadMethodType=bool;WriteMethodType=bool{D6FE3F6C-07A2-4F36-A493-D808DA1E6DFD}resource=/crio_Mod2/DO19;0;ReadMethodType=bool;WriteMethodType=bool{D727619D-329D-49DF-B1AF-7EAB96FAFDD3}resource=/crio_Mod2/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8{D8738338-8ED2-464D-8337-CE2A4E2D5517}resource=/crio_Mod1/AI13;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{D8C44379-9E6E-4065-B4CD-625EB3347471}resource=/crio_Mod1/AI10;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{DA159247-06B4-4D73-B8EE-843A843FE6F1}resource=/crio_Mod2/DO15:8;0;ReadMethodType=u8;WriteMethodType=u8{DA4177DC-3B5B-49E9-A4AE-1C7B71183FF1}resource=/crio_Mod2/DO23:16;0;ReadMethodType=u8;WriteMethodType=u8{DC5EF4F7-1B8D-43E8-A710-73286CD6314D}resource=/USER FPGA LED;0;ReadMethodType=u8;WriteMethodType=u8{E1A3B581-D77A-45EA-B9BC-1AD1138053E9}resource=/crio_Mod2/DO0;0;ReadMethodType=bool;WriteMethodType=bool{E1E74FD3-674F-435D-9F66-2DC68E280CCA}resource=/crio_Mod2/DO29;0;ReadMethodType=bool;WriteMethodType=bool{E97462DE-BEB9-4A13-8D59-45E091E7C37C}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 3,crio.Type=NI 9474,cRIOModule.DIO3_0InitialDir=0,cRIOModule.DIO7_4InitialDir=0,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.NumSyncRegs=11111111,cRIOModule.RsiAttributes=[crioConfig.End]{EA7F5BAD-2CFF-4AD4-BDD1-6F733F41CCE6}resource=/crio_Mod1/AI0;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{EE270B00-0B73-4E24-BE88-084322093660}resource=/crio_Mod1/AI8;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{EEF6D39F-5095-45D2-B9EC-E8BAC7A52F6F}resource=/crio_Mod2/DO4;0;ReadMethodType=bool;WriteMethodType=bool{EF265E61-4D2C-4BBA-B532-C70E087AA46A}resource=/crio_Mod2/DO18;0;ReadMethodType=bool;WriteMethodType=bool{EF6C5760-C11B-4E13-9C97-0AA5282EB598}resource=/crio_Mod2/DO12;0;ReadMethodType=bool;WriteMethodType=bool{FA96C7D7-3EED-42A4-9B84-083E0BBA5847}resource=/crio_Mod2/DO26;0;ReadMethodType=bool;WriteMethodType=bool{FBD5CC24-3BC6-4C66-9CE5-814332FFF494}resource=/crio_Mod2/DO22;0;ReadMethodType=bool;WriteMethodType=bool{FE25D7AC-BAA3-42E3-9A1C-D82D647083FC}resource=/crio_Mod1/AI3;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctl{FE487018-64CC-47D9-9B1D-CC6838576CF8}resource=/crio_Mod1/AI9;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlcRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGA/[rSeriesConfig.Begin][rSeriesConfig.End]</Property>
					<Property Name="configString.name" Type="Str">40 MHz Onboard ClockResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000.000000;MaxFreq=40000000.000000;VariableFreq=0;NomFreq=40000000.000000;PeakPeriodJitter=250.000000;MinDutyCycle=50.000000;MaxDutyCycle=50.000000;Accuracy=100.000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;Chassis Temperatureresource=/Chassis Temperature;0;ReadMethodType=i16cRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGA/[rSeriesConfig.Begin][rSeriesConfig.End]Mod1/AI0resource=/crio_Mod1/AI0;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI10resource=/crio_Mod1/AI10;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI11resource=/crio_Mod1/AI11;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI12resource=/crio_Mod1/AI12;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI13resource=/crio_Mod1/AI13;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI14resource=/crio_Mod1/AI14;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI15resource=/crio_Mod1/AI15;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI1resource=/crio_Mod1/AI1;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI2resource=/crio_Mod1/AI2;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI3resource=/crio_Mod1/AI3;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI4resource=/crio_Mod1/AI4;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI5resource=/crio_Mod1/AI5;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI6resource=/crio_Mod1/AI6;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI7resource=/crio_Mod1/AI7;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI8resource=/crio_Mod1/AI8;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1/AI9resource=/crio_Mod1/AI9;0;ReadMethodType=vi.lib\LabVIEW Targets\FPGA\cRIO\shared\nicrio_FXP_Controls\nicrio_FXP_S_24_5.ctlMod1[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 1,crio.Type=NI 9220,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]Mod2/DO0resource=/crio_Mod2/DO0;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO10resource=/crio_Mod2/DO10;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO11resource=/crio_Mod2/DO11;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO12resource=/crio_Mod2/DO12;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO13resource=/crio_Mod2/DO13;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO14resource=/crio_Mod2/DO14;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO15:8resource=/crio_Mod2/DO15:8;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO15resource=/crio_Mod2/DO15;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO16resource=/crio_Mod2/DO16;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO17resource=/crio_Mod2/DO17;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO18resource=/crio_Mod2/DO18;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO19resource=/crio_Mod2/DO19;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO1resource=/crio_Mod2/DO1;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO20resource=/crio_Mod2/DO20;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO21resource=/crio_Mod2/DO21;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO22resource=/crio_Mod2/DO22;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO23:16resource=/crio_Mod2/DO23:16;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO23resource=/crio_Mod2/DO23;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO24resource=/crio_Mod2/DO24;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO25resource=/crio_Mod2/DO25;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO26resource=/crio_Mod2/DO26;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO27resource=/crio_Mod2/DO27;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO28resource=/crio_Mod2/DO28;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO29resource=/crio_Mod2/DO29;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO2resource=/crio_Mod2/DO2;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO30resource=/crio_Mod2/DO30;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO31:0resource=/crio_Mod2/DO31:0;0;ReadMethodType=u32;WriteMethodType=u32Mod2/DO31:24resource=/crio_Mod2/DO31:24;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO31resource=/crio_Mod2/DO31;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO3resource=/crio_Mod2/DO3;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO4resource=/crio_Mod2/DO4;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO5resource=/crio_Mod2/DO5;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO6resource=/crio_Mod2/DO6;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO7:0resource=/crio_Mod2/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DO7resource=/crio_Mod2/DO7;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO8resource=/crio_Mod2/DO8;0;ReadMethodType=bool;WriteMethodType=boolMod2/DO9resource=/crio_Mod2/DO9;0;ReadMethodType=bool;WriteMethodType=boolMod2[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 2,crio.Type=NI 9476,cRIOModule.DisableArbitration=false,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.RsiAttributes=[crioConfig.End]Mod3/DO0ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO0;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO1ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO1;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO2ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO2;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO3ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO3;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO4ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO4;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO5ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO5;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO6ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO6;0;ReadMethodType=bool;WriteMethodType=boolMod3/DO7:0ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7:0;0;ReadMethodType=u8;WriteMethodType=u8Mod3/DO7ArbitrationForOutputData=NeverArbitrate;resource=/crio_Mod3/DO7;0;ReadMethodType=bool;WriteMethodType=boolMod3[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 3,crio.Type=NI 9474,cRIOModule.DIO3_0InitialDir=0,cRIOModule.DIO7_4InitialDir=0,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.NumSyncRegs=11111111,cRIOModule.RsiAttributes=[crioConfig.End]Scan Clockresource=/Scan Clock;0;ReadMethodType=boolSleepresource=/Sleep;0;ReadMethodType=bool;WriteMethodType=boolSystem Resetresource=/System Reset;0;ReadMethodType=bool;WriteMethodType=boolUSER FPGA LEDresource=/USER FPGA LED;0;ReadMethodType=u8;WriteMethodType=u8</Property>
					<Property Name="NI.LV.FPGA.InterfaceBitfile" Type="Str">\\ornl\naoa\Projects\DECC-Testing\00_PROJECTS\CSEISMIC\LabVIEW\RTDS TESTING 2015 SP1\RTDS PCC\FPGA Bitfiles\RTDS_PCC_Control_Switch_controller_fpga_9068_v3.lvbitx</Property>
				</Item>
				<Item Name="40 MHz Onboard Clock" Type="FPGA Base Clock">
					<Property Name="FPGA.PersistentID" Type="Str">{7EFED6EA-0F1D-4DFA-93A3-BD09D2DDF918}</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig" Type="Str">ResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000.000000;MaxFreq=40000000.000000;VariableFreq=0;NomFreq=40000000.000000;PeakPeriodJitter=250.000000;MinDutyCycle=50.000000;MaxDutyCycle=50.000000;Accuracy=100.000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.Accuracy" Type="Dbl">100</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.ClockSignalName" Type="Str">Clk40</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.MaxDutyCycle" Type="Dbl">50</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.MaxFrequency" Type="Dbl">40000000</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.MinDutyCycle" Type="Dbl">50</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.MinFrequency" Type="Dbl">40000000</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.NominalFrequency" Type="Dbl">40000000</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.PeakPeriodJitter" Type="Dbl">250</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.ResourceName" Type="Str">40 MHz Onboard Clock</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.SupportAndRequireRuntimeEnableDisable" Type="Bool">false</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.TopSignalConnect" Type="Str">Clk40</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.VariableFrequency" Type="Bool">false</Property>
					<Property Name="NI.LV.FPGA.Valid" Type="Bool">true</Property>
					<Property Name="NI.LV.FPGA.Version" Type="Int">5</Property>
				</Item>
				<Item Name="IP Builder" Type="IP Builder Target">
					<Item Name="Dependencies" Type="Dependencies"/>
					<Item Name="Build Specifications" Type="Build"/>
				</Item>
				<Item Name="Mod1" Type="RIO C Series Module">
					<Property Name="crio.Calibration" Type="Str">1</Property>
					<Property Name="crio.Location" Type="Str">Slot 1</Property>
					<Property Name="crio.RequiresValidation" Type="Bool">false</Property>
					<Property Name="crio.SDcounterSlaveChannelMask" Type="Str">0</Property>
					<Property Name="crio.SDCounterSlaveMasterSlot" Type="Str">0</Property>
					<Property Name="crio.SDInputFilter" Type="Str">128</Property>
					<Property Name="crio.SupportsDynamicRes" Type="Bool">false</Property>
					<Property Name="crio.Type" Type="Str">NI 9220</Property>
					<Property Name="cRIOModule.DigitalIOMode" Type="Str">0</Property>
					<Property Name="cRIOModule.EnableSpecialtyDigital" Type="Str">false</Property>
					<Property Name="FPGA.PersistentID" Type="Str">{6201F6E2-650E-4018-910B-F1CA297386B8}</Property>
				</Item>
				<Item Name="Mod2" Type="RIO C Series Module">
					<Property Name="crio.Calibration" Type="Str">1</Property>
					<Property Name="crio.Location" Type="Str">Slot 2</Property>
					<Property Name="crio.RequiresValidation" Type="Bool">false</Property>
					<Property Name="crio.SDcounterSlaveChannelMask" Type="Str">0</Property>
					<Property Name="crio.SDCounterSlaveMasterSlot" Type="Str">0</Property>
					<Property Name="crio.SDInputFilter" Type="Str">128</Property>
					<Property Name="crio.SupportsDynamicRes" Type="Bool">false</Property>
					<Property Name="crio.Type" Type="Str">NI 9476</Property>
					<Property Name="cRIOModule.DigitalIOMode" Type="Str">0</Property>
					<Property Name="cRIOModule.DisableArbitration" Type="Str">false</Property>
					<Property Name="cRIOModule.EnableSpecialtyDigital" Type="Str">false</Property>
					<Property Name="FPGA.PersistentID" Type="Str">{A9777E0D-0A90-43E2-A1FF-AA851AB680B1}</Property>
				</Item>
				<Item Name="Mod3" Type="RIO C Series Module">
					<Property Name="crio.Calibration" Type="Str">1</Property>
					<Property Name="crio.Location" Type="Str">Slot 3</Property>
					<Property Name="crio.RequiresValidation" Type="Bool">false</Property>
					<Property Name="crio.SDcounterSlaveChannelMask" Type="Str">0</Property>
					<Property Name="crio.SDCounterSlaveMasterSlot" Type="Str">0</Property>
					<Property Name="crio.SDInputFilter" Type="Str">128</Property>
					<Property Name="crio.SDPWMPeriod0" Type="Str">0</Property>
					<Property Name="crio.SDPWMPeriod1" Type="Str">0</Property>
					<Property Name="crio.SDPWMPeriod2" Type="Str">0</Property>
					<Property Name="crio.SDPWMPeriod3" Type="Str">0</Property>
					<Property Name="crio.SDPWMPeriod4" Type="Str">0</Property>
					<Property Name="crio.SDPWMPeriod5" Type="Str">0</Property>
					<Property Name="crio.SDPWMPeriod6" Type="Str">0</Property>
					<Property Name="crio.SDPWMPeriod7" Type="Str">0</Property>
					<Property Name="crio.SupportsDynamicRes" Type="Bool">false</Property>
					<Property Name="crio.Type" Type="Str">NI 9474</Property>
					<Property Name="cRIOModule.DigitalIOMode" Type="Str">0</Property>
					<Property Name="cRIOModule.DIO3_0InitialDir" Type="Str">0</Property>
					<Property Name="cRIOModule.DIO7_4InitialDir" Type="Str">0</Property>
					<Property Name="cRIOModule.EnableSpecialtyDigital" Type="Str">false</Property>
					<Property Name="cRIOModule.NumSyncRegs" Type="Str">11111111</Property>
					<Property Name="FPGA.PersistentID" Type="Str">{E97462DE-BEB9-4A13-8D59-45E091E7C37C}</Property>
				</Item>
				<Item Name="Dependencies" Type="Dependencies">
					<Item Name="vi.lib" Type="Folder">
						<Item Name="FxpSim.dll" Type="Document" URL="/&lt;vilib&gt;/rvi/FXPMathLib/sim/FxpSim.dll"/>
						<Item Name="LVFixedPointOverflowPolicyTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/fxp/LVFixedPointOverflowPolicyTypeDef.ctl"/>
						<Item Name="lvSimController.dll" Type="Document" URL="/&lt;vilib&gt;/rvi/Simulation/lvSimController.dll"/>
						<Item Name="Clear Errors.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Clear Errors.vi"/>
					</Item>
				</Item>
				<Item Name="Build Specifications" Type="Build">
					<Item Name="FPGA_RTDS_PCC_v02b_clean" Type="{F4C5E96F-7410-48A5-BB87-3559BC9B167F}">
						<Property Name="AllowEnableRemoval" Type="Bool">false</Property>
						<Property Name="BuildSpecDecription" Type="Str"></Property>
						<Property Name="BuildSpecName" Type="Str">FPGA_RTDS_PCC_v02b_clean</Property>
						<Property Name="Comp.BitfileName" Type="Str">RTDSPCCControl_FPGA_RTDS_PCC_v02b_clean.lvbitx</Property>
						<Property Name="Comp.CustomXilinxParameters" Type="Str"></Property>
						<Property Name="Comp.MaxFanout" Type="Int">-1</Property>
						<Property Name="Comp.RandomSeed" Type="Bool">false</Property>
						<Property Name="Comp.Version.Build" Type="Int">3</Property>
						<Property Name="Comp.Version.Fix" Type="Int">0</Property>
						<Property Name="Comp.Version.Major" Type="Int">1</Property>
						<Property Name="Comp.Version.Minor" Type="Int">0</Property>
						<Property Name="Comp.VersionAutoIncrement" Type="Bool">true</Property>
						<Property Name="Comp.Vivado.EnableMultiThreading" Type="Bool">true</Property>
						<Property Name="Comp.Vivado.OptDirective" Type="Str"></Property>
						<Property Name="Comp.Vivado.PhysOptDirective" Type="Str"></Property>
						<Property Name="Comp.Vivado.PlaceDirective" Type="Str"></Property>
						<Property Name="Comp.Vivado.RouteDirective" Type="Str"></Property>
						<Property Name="Comp.Vivado.RunPowerOpt" Type="Bool">false</Property>
						<Property Name="Comp.Vivado.Strategy" Type="Str">Default</Property>
						<Property Name="Comp.Xilinx.DesignStrategy" Type="Str">balanced</Property>
						<Property Name="Comp.Xilinx.MapEffort" Type="Str">default(noTiming)</Property>
						<Property Name="Comp.Xilinx.ParEffort" Type="Str">standard</Property>
						<Property Name="Comp.Xilinx.SynthEffort" Type="Str">normal</Property>
						<Property Name="Comp.Xilinx.SynthGoal" Type="Str">speed</Property>
						<Property Name="Comp.Xilinx.UseRecommended" Type="Bool">true</Property>
						<Property Name="DefaultBuildSpec" Type="Bool">true</Property>
						<Property Name="DestinationDirectory" Type="Path">FPGA Bitfiles</Property>
						<Property Name="NI.LV.FPGA.LastCompiledBitfilePath" Type="Path">//ornl/naoa/Projects/DECC-Testing/00_PROJECTS/CSEISMIC/LabVIEW/RTDS TESTING 2015 SP1/RTDS PCC/FPGA Bitfiles/RTDSPCCControl_FPGATarget_FPGARTDSPCCv02b.lvbitx</Property>
						<Property Name="NI.LV.FPGA.LastCompiledBitfilePathRelativeToProject" Type="Path">FPGA Bitfiles/RTDSPCCControl_FPGATarget_FPGARTDSPCCv02b.lvbitx</Property>
						<Property Name="ProjectPath" Type="Path">//ornl/naoa/Projects/DECC-Testing/00_PROJECTS/CSEISMIC/LabVIEW/RTDS TESTING 2015 SP1/RTDS PCC/RTDS_PCC_Control.lvproj</Property>
						<Property Name="RelativePath" Type="Bool">true</Property>
						<Property Name="RunWhenLoaded" Type="Bool">true</Property>
						<Property Name="SupportDownload" Type="Bool">true</Property>
						<Property Name="SupportResourceEstimation" Type="Bool">false</Property>
						<Property Name="TargetName" Type="Str">FPGA Target</Property>
						<Property Name="TopLevelVI" Type="Ref">/RT CompactRIO Target/Chassis/FPGA Target/Debugging/FPGA_RTDS_PCC_v02b_clean.vi</Property>
					</Item>
					<Item Name="Switch_controller_fpga_9068_v3" Type="{F4C5E96F-7410-48A5-BB87-3559BC9B167F}">
						<Property Name="AllowEnableRemoval" Type="Bool">false</Property>
						<Property Name="BuildSpecDecription" Type="Str"></Property>
						<Property Name="BuildSpecName" Type="Str">Switch_controller_fpga_9068_v3</Property>
						<Property Name="Comp.BitfileName" Type="Str">RTDS_PCC_Control_Switch_controller_fpga_9068_v3.lvbitx</Property>
						<Property Name="Comp.CustomXilinxParameters" Type="Str"></Property>
						<Property Name="Comp.MaxFanout" Type="Int">-1</Property>
						<Property Name="Comp.RandomSeed" Type="Bool">false</Property>
						<Property Name="Comp.Version.Build" Type="Int">0</Property>
						<Property Name="Comp.Version.Fix" Type="Int">0</Property>
						<Property Name="Comp.Version.Major" Type="Int">1</Property>
						<Property Name="Comp.Version.Minor" Type="Int">0</Property>
						<Property Name="Comp.VersionAutoIncrement" Type="Bool">false</Property>
						<Property Name="Comp.Vivado.EnableMultiThreading" Type="Bool">true</Property>
						<Property Name="Comp.Vivado.OptDirective" Type="Str"></Property>
						<Property Name="Comp.Vivado.PhysOptDirective" Type="Str"></Property>
						<Property Name="Comp.Vivado.PlaceDirective" Type="Str"></Property>
						<Property Name="Comp.Vivado.RouteDirective" Type="Str"></Property>
						<Property Name="Comp.Vivado.RunPowerOpt" Type="Bool">false</Property>
						<Property Name="Comp.Vivado.Strategy" Type="Str">Default</Property>
						<Property Name="Comp.Xilinx.DesignStrategy" Type="Str">balanced</Property>
						<Property Name="Comp.Xilinx.MapEffort" Type="Str">default(noTiming)</Property>
						<Property Name="Comp.Xilinx.ParEffort" Type="Str">standard</Property>
						<Property Name="Comp.Xilinx.SynthEffort" Type="Str">normal</Property>
						<Property Name="Comp.Xilinx.SynthGoal" Type="Str">speed</Property>
						<Property Name="Comp.Xilinx.UseRecommended" Type="Bool">true</Property>
						<Property Name="DefaultBuildSpec" Type="Bool">false</Property>
						<Property Name="DestinationDirectory" Type="Path">FPGA Bitfiles</Property>
						<Property Name="NI.LV.FPGA.LastCompiledBitfilePath" Type="Path">//ornl/naoa/Projects/DECC-Testing/00_PROJECTS/CSEISMIC/LabVIEW/RTDS TESTING 2015 SP1/RTDS PCC/FPGA Bitfiles/RTDS_PCC_Control_Switch_controller_fpga_9068_v3.lvbitx</Property>
						<Property Name="NI.LV.FPGA.LastCompiledBitfilePathRelativeToProject" Type="Path">FPGA Bitfiles/RTDS_PCC_Control_Switch_controller_fpga_9068_v3.lvbitx</Property>
						<Property Name="ProjectPath" Type="Path">//ornl/naoa/Projects/DECC-Testing/00_PROJECTS/CSEISMIC/LabVIEW/RTDS TESTING 2015 SP1/RTDS PCC/RTDS_PCC_Control.lvproj</Property>
						<Property Name="RelativePath" Type="Bool">true</Property>
						<Property Name="RunWhenLoaded" Type="Bool">false</Property>
						<Property Name="SupportDownload" Type="Bool">true</Property>
						<Property Name="SupportResourceEstimation" Type="Bool">false</Property>
						<Property Name="TargetName" Type="Str">FPGA Target</Property>
						<Property Name="TopLevelVI" Type="Ref">/RT CompactRIO Target/Chassis/FPGA Target/Switch_controller_fpga_9068_v3.vi</Property>
					</Item>
				</Item>
			</Item>
		</Item>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="vi.lib" Type="Folder">
				<Item Name="Modbus Slave.lvclass" Type="LVClass" URL="/&lt;vilib&gt;/Modbus/slave/Modbus Slave.lvclass"/>
				<Item Name="SubVIs.lvlib" Type="Library" URL="/&lt;vilib&gt;/Modbus/subvis/SubVIs.lvlib"/>
				<Item Name="Error Cluster From Error Code.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Cluster From Error Code.vi"/>
				<Item Name="Clear Errors.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Clear Errors.vi"/>
				<Item Name="Simple Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Simple Error Handler.vi"/>
				<Item Name="DialogType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogType.ctl"/>
				<Item Name="General Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/General Error Handler.vi"/>
				<Item Name="General Error Handler Core CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/General Error Handler Core CORE.vi"/>
				<Item Name="DialogTypeEnum.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogTypeEnum.ctl"/>
				<Item Name="whitespace.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/whitespace.ctl"/>
				<Item Name="Check Special Tags.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Check Special Tags.vi"/>
				<Item Name="TagReturnType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/TagReturnType.ctl"/>
				<Item Name="GetRTHostConnectedProp.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/GetRTHostConnectedProp.vi"/>
				<Item Name="Error Code Database.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Code Database.vi"/>
				<Item Name="Trim Whitespace.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Trim Whitespace.vi"/>
				<Item Name="Format Message String.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Format Message String.vi"/>
				<Item Name="Find Tag.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Find Tag.vi"/>
				<Item Name="Search and Replace Pattern.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Search and Replace Pattern.vi"/>
				<Item Name="Set Bold Text.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set Bold Text.vi"/>
				<Item Name="Not Found Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Not Found Dialog.vi"/>
				<Item Name="Three Button Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog.vi"/>
				<Item Name="Three Button Dialog CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog CORE.vi"/>
				<Item Name="LVRectTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVRectTypeDef.ctl"/>
				<Item Name="Longest Line Length in Pixels.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Longest Line Length in Pixels.vi"/>
				<Item Name="Convert property node font to graphics font.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Convert property node font to graphics font.vi"/>
				<Item Name="Get Text Rect.vi" Type="VI" URL="/&lt;vilib&gt;/picture/picture.llb/Get Text Rect.vi"/>
				<Item Name="Get String Text Bounds.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Get String Text Bounds.vi"/>
				<Item Name="LVBoundsTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVBoundsTypeDef.ctl"/>
				<Item Name="BuildHelpPath.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/BuildHelpPath.vi"/>
				<Item Name="GetHelpDir.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/GetHelpDir.vi"/>
				<Item Name="Details Display Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Details Display Dialog.vi"/>
				<Item Name="ErrWarn.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/ErrWarn.ctl"/>
				<Item Name="eventvkey.ctl" Type="VI" URL="/&lt;vilib&gt;/event_ctls.llb/eventvkey.ctl"/>
				<Item Name="Set String Value.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set String Value.vi"/>
				<Item Name="NI_PtbyPt.lvlib" Type="Library" URL="/&lt;vilib&gt;/ptbypt/NI_PtbyPt.lvlib"/>
			</Item>
			<Item Name="NiFpgaLv.dll" Type="Document" URL="NiFpgaLv.dll">
				<Property Name="NI.PreserveRelativePath" Type="Bool">true</Property>
			</Item>
			<Item Name="PCC case typedef.ctl" Type="VI" URL="../subVIs/PCC case typedef.ctl"/>
			<Item Name="RTDSPCCControl_FPGATarget_Switchcontroller_v4.lvbitx" Type="Document" URL="../FPGA Bitfiles/RTDSPCCControl_FPGATarget_Switchcontroller_v4.lvbitx"/>
			<Item Name="Data_Queue_Command.ctl" Type="VI" URL="../subVIs/Data_Queue_Command.ctl"/>
			<Item Name="FGV_Grid_Frequency.vi" Type="VI" URL="../subVIs/FGV_Grid_Frequency.vi"/>
			<Item Name="FGV_MG_Frequency.vi" Type="VI" URL="../subVIs/FGV_MG_Frequency.vi"/>
			<Item Name="FGV_Current_PCC.vi" Type="VI" URL="../subVIs/FGV_Current_PCC.vi"/>
			<Item Name="FGV_Grid_Voltage_PCC.vi" Type="VI" URL="../subVIs/FGV_Grid_Voltage_PCC.vi"/>
			<Item Name="FGV_MG_Voltage_PCC.vi" Type="VI" URL="../subVIs/FGV_MG_Voltage_PCC.vi"/>
			<Item Name="FGV_S_P_Q_PCC.vi" Type="VI" URL="../subVIs/FGV_S_P_Q_PCC.vi"/>
			<Item Name="RTDSPCCControl_FPGA_RTDS_PCC_v02b_clean.lvbitx" Type="Document" URL="../FPGA Bitfiles/RTDSPCCControl_FPGA_RTDS_PCC_v02b_clean.lvbitx"/>
			<Item Name="Modbus Data Conversion.lvlib" Type="Library" URL="../../../2015 SP1 Support Files/Project Dependencies/Common/Modbus Data Conversion.llb/Modbus Data Conversion.lvlib"/>
		</Item>
		<Item Name="Build Specifications" Type="Build">
			<Item Name="RT_PCC_Control_v02b_clean" Type="{69A947D5-514E-4E75-818E-69657C0547D8}">
				<Property Name="App_copyErrors" Type="Bool">true</Property>
				<Property Name="App_INI_aliasGUID" Type="Str">{C5BA9344-11FF-44A2-9BE1-FC1C89949B09}</Property>
				<Property Name="App_INI_GUID" Type="Str">{0592B5E1-1708-4193-BE63-262EE3B1F372}</Property>
				<Property Name="App_serverConfig.httpPort" Type="Int">8002</Property>
				<Property Name="App_winsec.description" Type="Str">http://www.ORNL.com</Property>
				<Property Name="Bld_autoIncrement" Type="Bool">true</Property>
				<Property Name="Bld_buildCacheID" Type="Str">{68CEA9BF-1B18-4EB8-8199-3950BFB0F492}</Property>
				<Property Name="Bld_buildSpecName" Type="Str">RT_PCC_Control_v02b_clean</Property>
				<Property Name="Bld_compilerOptLevel" Type="Int">0</Property>
				<Property Name="Bld_excludeInlineSubVIs" Type="Bool">true</Property>
				<Property Name="Bld_excludeLibraryItems" Type="Bool">true</Property>
				<Property Name="Bld_excludePolymorphicVIs" Type="Bool">true</Property>
				<Property Name="Bld_localDestDir" Type="Path">../builds/NI_AB_PROJECTNAME/NI_AB_TARGETNAME/RT_PCC_Control_v02b_clean</Property>
				<Property Name="Bld_localDestDirType" Type="Str">relativeToCommon</Property>
				<Property Name="Bld_modifyLibraryFile" Type="Bool">true</Property>
				<Property Name="Bld_previewCacheID" Type="Str">{15929484-22AE-405E-9F28-1DFBD0C6D211}</Property>
				<Property Name="Bld_targetDestDir" Type="Path">/home/lvuser/natinst/bin</Property>
				<Property Name="Bld_version.build" Type="Int">2</Property>
				<Property Name="Bld_version.major" Type="Int">1</Property>
				<Property Name="Destination[0].destName" Type="Str">startup.rtexe</Property>
				<Property Name="Destination[0].path" Type="Path">/home/lvuser/natinst/bin/startup.rtexe</Property>
				<Property Name="Destination[0].path.type" Type="Str">&lt;none&gt;</Property>
				<Property Name="Destination[0].preserveHierarchy" Type="Bool">true</Property>
				<Property Name="Destination[0].type" Type="Str">App</Property>
				<Property Name="Destination[1].destName" Type="Str">Support Directory</Property>
				<Property Name="Destination[1].path" Type="Path">/home/lvuser/natinst/bin/data</Property>
				<Property Name="Destination[1].path.type" Type="Str">&lt;none&gt;</Property>
				<Property Name="DestinationCount" Type="Int">2</Property>
				<Property Name="Source[0].itemID" Type="Str">{70804889-8F7D-46DB-8589-90ADC2B9870A}</Property>
				<Property Name="Source[0].type" Type="Str">Container</Property>
				<Property Name="Source[1].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[1].itemID" Type="Ref">/RT CompactRIO Target/Debugging/RT_PCC_Control_v02b_clean.vi</Property>
				<Property Name="Source[1].sourceInclusion" Type="Str">TopLevel</Property>
				<Property Name="Source[1].type" Type="Str">VI</Property>
				<Property Name="SourceCount" Type="Int">2</Property>
				<Property Name="TgtF_companyName" Type="Str">ORNL</Property>
				<Property Name="TgtF_fileDescription" Type="Str">RT_PCC_Control_v02b_clean</Property>
				<Property Name="TgtF_internalName" Type="Str">RT_PCC_Control_v02b_clean</Property>
				<Property Name="TgtF_legalCopyright" Type="Str">Copyright © 2016 ORNL</Property>
				<Property Name="TgtF_productName" Type="Str">RT_PCC_Control_v02b_clean</Property>
				<Property Name="TgtF_targetfileGUID" Type="Str">{69756B33-21DA-4460-9D8F-93FCAF398338}</Property>
				<Property Name="TgtF_targetfileName" Type="Str">startup.rtexe</Property>
			</Item>
		</Item>
	</Item>
</Project>
