<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="18008000">
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
		<Property Name="NI.SortType" Type="Int">3</Property>
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="Configuration" Type="Folder" URL="../Configuration">
			<Property Name="NI.DISK" Type="Bool">true</Property>
			<Property Name="NI.SortType" Type="Int">0</Property>
		</Item>
		<Item Name="CSEISMIC Configs" Type="Folder" URL="../CSEISMIC Configs">
			<Property Name="NI.DISK" Type="Bool">true</Property>
		</Item>
		<Item Name="Default Forecasts" Type="Folder" URL="../Default Forecasts">
			<Property Name="NI.DISK" Type="Bool">true</Property>
		</Item>
		<Item Name="External Code" Type="Folder" URL="../External Code">
			<Property Name="NI.DISK" Type="Bool">true</Property>
			<Property Name="NI.SortType" Type="Int">0</Property>
		</Item>
		<Item Name="Global Variables" Type="Folder">
			<Item Name="Controls" Type="Folder">
				<Item Name="Optimization Type Selector.ctl" Type="VI" URL="../Global Variables/Controls/Optimization Type Selector.ctl"/>
			</Item>
			<Item Name="Global Variables.vi" Type="VI" URL="../Global Variables/Global Variables.vi"/>
		</Item>
		<Item Name="Abstract Actors" Type="Folder">
			<Item Name="EMS Generic Actor.lvlib" Type="Library" URL="../EMS Generic Actor/EMS Generic Actor.lvlib"/>
			<Item Name="Device Communication and Control Abstract Actor.lvlib" Type="Library" URL="../Device Communication and Control Abstract Actor/Device Communication and Control Abstract Actor.lvlib"/>
		</Item>
		<Item Name="IED Actors" Type="Folder">
			<Property Name="NI.SortType" Type="Int">3</Property>
			<Item Name="Device DDS Communication Framework" Type="Folder">
				<Item Name="Device DDS Communications Framework.lvlib" Type="Library" URL="../IED Actors/Device DDS Communications Framework/Device DDS Communications Framework.lvlib"/>
			</Item>
			<Item Name="IED Test Framework" Type="Folder">
				<Item Name="IED Test Framework.lvlib" Type="Library" URL="../IED Actors/IED Test Framework/IED Test Framework.lvlib"/>
			</Item>
			<Item Name="DER Actor" Type="Folder">
				<Item Name="DER Actor.lvlib" Type="Library" URL="../IED Actors/DER Actor/DER Actor.lvlib"/>
			</Item>
			<Item Name="ES Actor" Type="Folder">
				<Item Name="ES Actor.lvlib" Type="Library" URL="../IED Actors/ES Actor/ES Actor.lvlib"/>
			</Item>
			<Item Name="ForecastData Actor" Type="Folder">
				<Item Name="ForecastData Actor.lvlib" Type="Library" URL="../IED Actors/ForecastData Actor/ForecastData Actor.lvlib"/>
			</Item>
			<Item Name="HVAC Actor" Type="Folder">
				<Item Name="HVAC Actor.lvlib" Type="Library" URL="../IED Actors/HVAC Actor/HVAC Actor.lvlib"/>
			</Item>
			<Item Name="IED Actor" Type="Folder">
				<Item Name="IED Actor.lvlib" Type="Library" URL="../IED Actors/IED Actor/IED Actor.lvlib"/>
			</Item>
			<Item Name="Load Actor" Type="Folder">
				<Item Name="Load Actor.lvlib" Type="Library" URL="../IED Actors/Load Actor/Load Actor.lvlib"/>
			</Item>
			<Item Name="PCC Actor" Type="Folder">
				<Item Name="PCC Actor.lvlib" Type="Library" URL="../IED Actors/PCC Actor/PCC Actor.lvlib"/>
			</Item>
			<Item Name="PriceData Actor" Type="Folder">
				<Item Name="PriceData Actor.lvlib" Type="Library" URL="../IED Actors/PriceData Actor/PriceData Actor.lvlib"/>
			</Item>
			<Item Name="PV Actor" Type="Folder">
				<Item Name="PV Actor.lvlib" Type="Library" URL="../IED Actors/PV Actor/PV Actor.lvlib"/>
			</Item>
			<Item Name="Relay Actor" Type="Folder">
				<Item Name="Relay Actor.lvlib" Type="Library" URL="../IED Actors/Relay Actor/Relay Actor.lvlib"/>
			</Item>
			<Item Name="Smart Relay Actor" Type="Folder">
				<Item Name="Smart Relay Actor.lvlib" Type="Library" URL="../IED Actors/Smart Relay Actor/Smart Relay Actor.lvlib"/>
			</Item>
			<Item Name="Meter Actor" Type="Folder">
				<Item Name="Meter Actor.lvlib" Type="Library" URL="../IED Actors/Meter Actor/Meter Actor.lvlib"/>
			</Item>
			<Item Name="Generator Actor" Type="Folder">
				<Item Name="Generator Actor.lvlib" Type="Library" URL="../IED Actors/Generator Actor/Generator Actor.lvlib"/>
			</Item>
		</Item>
		<Item Name="Optimization" Type="Folder">
			<Property Name="NI.SortType" Type="Int">3</Property>
			<Item Name="Generic Optimization Actor" Type="Folder">
				<Item Name="Generic Optimization Actor.lvlib" Type="Library" URL="../Optimization/Generic Optimization Actor/Generic Optimization Actor.lvlib"/>
				<Item Name="Startup Optimization Actor.lvlib" Type="Library" URL="../Optimization/Startup Optimization Actor/Startup Optimization Actor.lvlib"/>
			</Item>
			<Item Name="Activation Actor" Type="Folder">
				<Item Name="Activation Actor.lvlib" Type="Library" URL="../Optimization/Activation Actor/Activation Actor.lvlib"/>
			</Item>
			<Item Name="Blackstart Actor" Type="Folder">
				<Item Name="Blackstart Actor.lvlib" Type="Library" URL="../Optimization/Blackstart Actor/Blackstart Actor.lvlib"/>
			</Item>
			<Item Name="Commissioning Actor" Type="Folder">
				<Item Name="Commissioning Actor.lvlib" Type="Library" URL="../Optimization/Commissioning Actor/Commissioning Actor.lvlib"/>
			</Item>
			<Item Name="Island Actor" Type="Folder">
				<Item Name="Island Actor.lvlib" Type="Library" URL="../Optimization/Island Actor/Island Actor.lvlib"/>
			</Item>
			<Item Name="Off-Grid Actor" Type="Folder">
				<Item Name="Off-Grid Actor.lvlib" Type="Library" URL="../Optimization/Off-Grid Actor/Off-Grid Actor.lvlib"/>
			</Item>
			<Item Name="On-Grid Actor" Type="Folder">
				<Item Name="On-Grid Actor.lvlib" Type="Library" URL="../Optimization/On-Grid Actor/On-Grid Actor.lvlib"/>
			</Item>
			<Item Name="Resynchronization Actor" Type="Folder">
				<Item Name="Resynchronization Actor.lvlib" Type="Library" URL="../Optimization/Resynchronization Actor/Resynchronization Actor.lvlib"/>
			</Item>
			<Item Name="Shutdown Actor" Type="Folder">
				<Item Name="Shutdown Actor.lvlib" Type="Library" URL="../Optimization/Shutdown Actor/Shutdown Actor.lvlib"/>
			</Item>
			<Item Name="Manual Control Actor" Type="Folder">
				<Item Name="Manual Control Actor.lvlib" Type="Library" URL="../Optimization/Manual Control Actor/Manual Control Actor.lvlib"/>
			</Item>
		</Item>
		<Item Name="EMS Core" Type="Folder">
			<Item Name="EMS Core.lvlib" Type="Library" URL="../EMS Core/EMS Core.lvlib"/>
		</Item>
		<Item Name="EMS User Interface Actor" Type="Folder">
			<Item Name="Utilities" Type="Folder">
				<Item Name="Scripted Operation" Type="Folder">
					<Item Name="Controls" Type="Folder">
						<Item Name="FGV Action.ctl" Type="VI" URL="../Utilities/Scripted Operation/Controls/FGV Action.ctl"/>
						<Item Name="Action Button.ctl" Type="VI" URL="../Utilities/Scripted Operation/Controls/Action Button.ctl"/>
					</Item>
					<Item Name="Script FGV.vi" Type="VI" URL="../Utilities/Scripted Operation/Script FGV.vi"/>
				</Item>
				<Item Name="Password Protection" Type="Folder">
					<Item Name="Password Protection.lvlib" Type="Library" URL="../Utilities/Password Protection/Password Protection.lvlib"/>
				</Item>
				<Item Name="Python" Type="Folder">
					<Item Name="Generate Typedef for Python Optimization.vi" Type="VI" URL="../Utilities/Python/Generate Typedef for Python Optimization.vi"/>
					<Item Name="Optimization Tester.vi" Type="VI" URL="../Utilities/Python/Optimization Tester.vi"/>
					<Item Name="Get Python Location.vi" Type="VI" URL="../Utilities/Python/Get Python Location.vi"/>
				</Item>
				<Item Name="Status Messaging.lvlib" Type="Library" URL="../Utilities/Status Messaging.llb/Status Messaging.lvlib"/>
				<Item Name="Waveform Equalizer.lvlib" Type="Library" URL="../Utilities/Forecast-Waveform-Equalizer/Waveform Equalizer/Waveform Equalizer.lvlib"/>
				<Item Name="Error Bound Wait (ms).vi" Type="VI" URL="../Utilities/Error Bound Wait (ms).vi"/>
				<Item Name="Determine Device Types.vi" Type="VI" URL="../Utilities/Determine Device Types.vi"/>
				<Item Name="Find Missing Elements in Array (Double).vi" Type="VI" URL="../Utilities/Find Missing Elements in Array (Double).vi"/>
				<Item Name="Find Missing Elements in Array (String).vi" Type="VI" URL="../Utilities/Find Missing Elements in Array (String).vi"/>
				<Item Name="Continuous File Read.vi" Type="VI" URL="../Utilities/Continuous File Read.vi"/>
			</Item>
			<Item Name="EMS User Interface Actor.lvlib" Type="Library" URL="../EMS User Interface Actor/EMS User Interface Actor.lvlib"/>
		</Item>
		<Item Name="Plug-ins" Type="Folder" URL="../Plug-ins">
			<Property Name="NI.DISK" Type="Bool">true</Property>
		</Item>
		<Item Name="Device Specific Actors" Type="Folder">
			<Item Name="AE75TX Actor.lvlib" Type="Library" URL="../Device Specific Actors/AE75TX Actor/AE75TX Actor.lvlib"/>
		</Item>
		<Item Name="Integration Testers" Type="Folder">
			<Item Name="Discovery Device Spammer" Type="Folder">
				<Item Name="Spammer.vi" Type="VI" URL="../Integration Testers/Discovery Device Spammer/Spammer.vi"/>
			</Item>
			<Item Name="IED Status Logger" Type="Folder">
				<Item Name="IED Status Logger Actor.lvlib" Type="Library" URL="../Integration Testers/IED Status Logger Actor/IED Status Logger Actor.lvlib"/>
			</Item>
			<Item Name="Device Discovery Tester.vi" Type="VI" URL="../Integration Testers/Device Discovery Tester.vi"/>
		</Item>
		<Item Name="Dialog Actors" Type="Folder">
			<Item Name="Devices to Load Config Actor" Type="Folder">
				<Item Name="Devices to Load Config Actor.lvlib" Type="Library" URL="../Dialog Actors/Devices to Load Actor/Devices to Load Config Actor.lvlib"/>
			</Item>
			<Item Name="File Dialog Actor" Type="Folder">
				<Item Name="File Dialog Actor.lvlib" Type="Library" URL="../Dialog Actors/File Dialog Actor/File Dialog Actor.lvlib"/>
			</Item>
			<Item Name="Load File Actor" Type="Folder">
				<Item Name="Open File Actor.lvlib" Type="Library" URL="../Dialog Actors/Load File Actor/Open File Actor.lvlib"/>
			</Item>
			<Item Name="Save File Actor" Type="Folder">
				<Item Name="Save File Actor.lvlib" Type="Library" URL="../Dialog Actors/Save File Actor/Save File Actor.lvlib"/>
			</Item>
			<Item Name="VF Device Selection Actor" Type="Folder">
				<Item Name="VF Device Selection Actor.lvlib" Type="Library" URL="../Dialog Actors/VF Device Selection Actor/VF Device Selection Actor.lvlib"/>
			</Item>
		</Item>
		<Item Name="RTI DLLs" Type="Folder">
			<Item Name="nddsc.dll" Type="Document" URL="/&lt;vilib&gt;/_RTI DDS Toolkit_internal_deps/nddsc.dll"/>
			<Item Name="nddscore.dll" Type="Document" URL="/&lt;vilib&gt;/_RTI DDS Toolkit_internal_deps/nddscore.dll"/>
			<Item Name="nddssecurity.dll" Type="Document" URL="/&lt;vilib&gt;/_RTI DDS Toolkit_internal_deps/nddssecurity.dll"/>
			<Item Name="rtidlc.dll" Type="Document" URL="/&lt;vilib&gt;/_RTI DDS Toolkit_internal_deps/rtidlc.dll"/>
			<Item Name="rtilvdds.dll" Type="Document" URL="/&lt;vilib&gt;/_RTI DDS Toolkit_internal_deps/rtilvdds.dll"/>
			<Item Name="rtimonitoring.dll" Type="Document" URL="/&lt;vilib&gt;/_RTI DDS Toolkit_internal_deps/rtimonitoring.dll"/>
		</Item>
		<Item Name="Remote Operation" Type="Folder">
			<Item Name="Remote Operation Abstract.lvlib" Type="Library" URL="../Remote Operation/Remote Operation Abstract.lvlib"/>
			<Item Name="Alabama Power Remote Actor.lvlib" Type="Library" URL="../Remote Operation/Alabama Power Remote Actor/Alabama Power Remote Actor.lvlib"/>
		</Item>
		<Item Name="EMS Launcher.lvlib" Type="Library" URL="../EMS Launcher/EMS Launcher.lvlib"/>
		<Item Name="EMS.ico" Type="Document" URL="../Icon/EMS.ico"/>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="vi.lib" Type="Folder">
				<Item Name="Error Cluster From Error Code.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Cluster From Error Code.vi"/>
				<Item Name="Actor Framework.lvlib" Type="Library" URL="/&lt;vilib&gt;/ActorFramework/Actor Framework.lvlib"/>
				<Item Name="NI_FileType.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/lvfile.llb/NI_FileType.lvlib"/>
				<Item Name="Application Directory.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Application Directory.vi"/>
				<Item Name="Trim Whitespace.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Trim Whitespace.vi"/>
				<Item Name="whitespace.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/whitespace.ctl"/>
				<Item Name="8.6CompatibleGlobalVar.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/config.llb/8.6CompatibleGlobalVar.vi"/>
				<Item Name="NI_LVConfig.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/config.llb/NI_LVConfig.lvlib"/>
				<Item Name="NI_PackedLibraryUtility.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/LVLibp/NI_PackedLibraryUtility.lvlib"/>
				<Item Name="Check if File or Folder Exists.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/libraryn.llb/Check if File or Folder Exists.vi"/>
				<Item Name="Clear Errors.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Clear Errors.vi"/>
				<Item Name="GetHelpDir.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/GetHelpDir.vi"/>
				<Item Name="BuildHelpPath.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/BuildHelpPath.vi"/>
				<Item Name="LVBoundsTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVBoundsTypeDef.ctl"/>
				<Item Name="Get String Text Bounds.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Get String Text Bounds.vi"/>
				<Item Name="Get Text Rect.vi" Type="VI" URL="/&lt;vilib&gt;/picture/picture.llb/Get Text Rect.vi"/>
				<Item Name="Convert property node font to graphics font.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Convert property node font to graphics font.vi"/>
				<Item Name="Longest Line Length in Pixels.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Longest Line Length in Pixels.vi"/>
				<Item Name="LVRectTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVRectTypeDef.ctl"/>
				<Item Name="Three Button Dialog CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog CORE.vi"/>
				<Item Name="Three Button Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog.vi"/>
				<Item Name="DialogTypeEnum.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogTypeEnum.ctl"/>
				<Item Name="Not Found Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Not Found Dialog.vi"/>
				<Item Name="Set Bold Text.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set Bold Text.vi"/>
				<Item Name="eventvkey.ctl" Type="VI" URL="/&lt;vilib&gt;/event_ctls.llb/eventvkey.ctl"/>
				<Item Name="TagReturnType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/TagReturnType.ctl"/>
				<Item Name="ErrWarn.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/ErrWarn.ctl"/>
				<Item Name="Details Display Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Details Display Dialog.vi"/>
				<Item Name="Search and Replace Pattern.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Search and Replace Pattern.vi"/>
				<Item Name="Find Tag.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Find Tag.vi"/>
				<Item Name="Format Message String.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Format Message String.vi"/>
				<Item Name="Error Code Database.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Code Database.vi"/>
				<Item Name="GetRTHostConnectedProp.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/GetRTHostConnectedProp.vi"/>
				<Item Name="Set String Value.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set String Value.vi"/>
				<Item Name="Check Special Tags.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Check Special Tags.vi"/>
				<Item Name="General Error Handler Core CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/General Error Handler Core CORE.vi"/>
				<Item Name="DialogType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogType.ctl"/>
				<Item Name="General Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/General Error Handler.vi"/>
				<Item Name="Simple Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Simple Error Handler.vi"/>
				<Item Name="Dflt Data Dir.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Dflt Data Dir.vi"/>
				<Item Name="Time-Delay Override Options.ctl" Type="VI" URL="/&lt;vilib&gt;/ActorFramework/Time-Delayed Send Message/Time-Delay Override Options.ctl"/>
				<Item Name="Get LV Class Name.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/LVClass/Get LV Class Name.vi"/>
				<Item Name="NI_Data Type.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/Data Type/NI_Data Type.lvlib"/>
				<Item Name="Space Constant.vi" Type="VI" URL="/&lt;vilib&gt;/dlg_ctls.llb/Space Constant.vi"/>
				<Item Name="LVNumericRepresentation.ctl" Type="VI" URL="/&lt;vilib&gt;/numeric/LVNumericRepresentation.ctl"/>
				<Item Name="subFile Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/express/express input/FileDialogBlock.llb/subFile Dialog.vi"/>
				<Item Name="ex_CorrectErrorChain.vi" Type="VI" URL="/&lt;vilib&gt;/express/express shared/ex_CorrectErrorChain.vi"/>
				<Item Name="Is Path and Not Empty.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Is Path and Not Empty.vi"/>
				<Item Name="LVDDS_library.lvlib" Type="Library" URL="/&lt;vilib&gt;/RTI DDS Toolkit/Library/LVDDS_library.lvlib"/>
				<Item Name="subElapsedTime.vi" Type="VI" URL="/&lt;vilib&gt;/express/express execution control/ElapsedTimeBlock.llb/subElapsedTime.vi"/>
				<Item Name="FormatTime String.vi" Type="VI" URL="/&lt;vilib&gt;/express/express execution control/ElapsedTimeBlock.llb/FormatTime String.vi"/>
				<Item Name="Time-Delayed Send Message Core.vi" Type="VI" URL="/&lt;vilib&gt;/ActorFramework/Time-Delayed Send Message/Time-Delayed Send Message Core.vi"/>
				<Item Name="Time-Delayed Send Message.vi" Type="VI" URL="/&lt;vilib&gt;/ActorFramework/Time-Delayed Send Message/Time-Delayed Send Message.vi"/>
				<Item Name="NI_AALBase.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/NI_AALBase.lvlib"/>
				<Item Name="Modbus Master.lvclass" Type="LVClass" URL="/&lt;vilib&gt;/Modbus/master/Modbus Master.lvclass"/>
				<Item Name="SubVIs.lvlib" Type="Library" URL="/&lt;vilib&gt;/Modbus/subvis/SubVIs.lvlib"/>
				<Item Name="CSEISMIC DDS.lvlib" Type="Library" URL="/&lt;vilib&gt;/ORNL/CSEISMIC DDS/CSEISMIC DDS.lvlib"/>
				<Item Name="NI_Gmath.lvlib" Type="Library" URL="/&lt;vilib&gt;/gmath/NI_Gmath.lvlib"/>
				<Item Name="System Exec.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/system.llb/System Exec.vi"/>
				<Item Name="LVRowAndColumnTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVRowAndColumnTypeDef.ctl"/>
				<Item Name="Find First Error.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Find First Error.vi"/>
				<Item Name="Close File+.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Close File+.vi"/>
				<Item Name="compatReadText.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/compatReadText.vi"/>
				<Item Name="Read File+ (string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read File+ (string).vi"/>
				<Item Name="Open File+.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Open File+.vi"/>
				<Item Name="Read Lines From File (with error IO).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read Lines From File (with error IO).vi"/>
				<Item Name="Read Delimited Spreadsheet (DBL).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read Delimited Spreadsheet (DBL).vi"/>
				<Item Name="Read Delimited Spreadsheet (string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read Delimited Spreadsheet (string).vi"/>
				<Item Name="Read Delimited Spreadsheet (I64).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read Delimited Spreadsheet (I64).vi"/>
				<Item Name="Read Delimited Spreadsheet.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read Delimited Spreadsheet.vi"/>
				<Item Name="Get LV Class Default Value.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/LVClass/Get LV Class Default Value.vi"/>
				<Item Name="List Directory and LLBs.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/libraryn.llb/List Directory and LLBs.vi"/>
				<Item Name="Recursive File List.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/libraryn.llb/Recursive File List.vi"/>
				<Item Name="NI_SystemLogging.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/SystemLogging/NI_SystemLogging.lvlib"/>
				<Item Name="High Resolution Relative Seconds.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/High Resolution Relative Seconds.vi"/>
				<Item Name="LVPointTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVPointTypeDef.ctl"/>
				<Item Name="LVPositionTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVPositionTypeDef.ctl"/>
			</Item>
			<Item Name="user.lib" Type="Folder">
				<Item Name="String to 1D Array__ogtk.vi" Type="VI" URL="/&lt;userlib&gt;/_OpenG.lib/string/string.llb/String to 1D Array__ogtk.vi"/>
				<Item Name="1D Array to String__ogtk.vi" Type="VI" URL="/&lt;userlib&gt;/_OpenG.lib/string/string.llb/1D Array to String__ogtk.vi"/>
			</Item>
			<Item Name="AF Debug.lvlib" Type="Library" URL="/&lt;resource&gt;/AFDebug/AF Debug.lvlib"/>
			<Item Name="lvanlys.dll" Type="Document" URL="/&lt;resource&gt;/lvanlys.dll"/>
			<Item Name="mscorlib" Type="VI" URL="mscorlib">
				<Property Name="NI.PreserveRelativePath" Type="Bool">true</Property>
			</Item>
			<Item Name="systemLogging.dll" Type="Document" URL="systemLogging.dll">
				<Property Name="NI.PreserveRelativePath" Type="Bool">true</Property>
			</Item>
			<Item Name="LV Config Read String.vi" Type="VI" URL="/&lt;resource&gt;/dialog/lvconfig.llb/LV Config Read String.vi"/>
			<Item Name="_ChannelSupport.lvlib" Type="Library" URL="/&lt;resource&gt;/ChannelSupport/_ChannelSupport/_ChannelSupport.lvlib"/>
			<Item Name="Tag-t&apos;CSEISMIC DDS.lvlib-CSEISMIC DDS.lvclass-IED_Status.ctl&apos;.lvlib" Type="Library" URL="/&lt;extravilib&gt;/ChannelInstances/Tag-t&apos;CSEISMIC DDS.lvlib-CSEISMIC DDS.lvclass-IED_Status.ctl&apos;.lvlib"/>
			<Item Name="ChannelProbePositionAndTitle.vi" Type="VI" URL="/&lt;resource&gt;/ChannelSupport/_ChannelSupport/ChannelProbePositionAndTitle.vi"/>
			<Item Name="ChannelProbeWindowStagger.vi" Type="VI" URL="/&lt;resource&gt;/ChannelSupport/_ChannelSupport/ChannelProbeWindowStagger.vi"/>
			<Item Name="Tag-t&apos;CSEISMIC DDS.lvlib-CSEISMIC DDS.lvclass-DER_Status.ctl&apos;.lvlib" Type="Library" URL="/&lt;extravilib&gt;/ChannelInstances/Tag-t&apos;CSEISMIC DDS.lvlib-CSEISMIC DDS.lvclass-DER_Status.ctl&apos;.lvlib"/>
			<Item Name="Tag-t&apos;CSEISMIC DDS.lvlib-CSEISMIC DDS.lvclass-DER_Measurement.ctl&apos;.lvlib" Type="Library" URL="/&lt;extravilib&gt;/ChannelInstances/Tag-t&apos;CSEISMIC DDS.lvlib-CSEISMIC DDS.lvclass-DER_Measurement.ctl&apos;.lvlib"/>
			<Item Name="PipeLogic.lvclass" Type="LVClass" URL="/&lt;resource&gt;/ChannelSupport/_ChannelSupport/PipeLogic/PipeLogic.lvclass"/>
			<Item Name="Stream-u16.lvlib" Type="Library" URL="/&lt;extravilib&gt;/ChannelInstances/Stream-u16.lvlib"/>
			<Item Name="Update Probe Details String.vi" Type="VI" URL="/&lt;resource&gt;/ChannelSupport/_ChannelSupport/ProbeSupport/Update Probe Details String.vi"/>
			<Item Name="ProbeFormatting.vi" Type="VI" URL="/&lt;resource&gt;/ChannelSupport/_ChannelSupport/ProbeSupport/ProbeFormatting.vi"/>
		</Item>
		<Item Name="Build Specifications" Type="Build">
			<Item Name="CSEISMIC" Type="EXE">
				<Property Name="App_copyErrors" Type="Bool">true</Property>
				<Property Name="App_INI_aliasGUID" Type="Str">{CE9E6212-9690-423E-B2E0-9DD42DAEBA9C}</Property>
				<Property Name="App_INI_GUID" Type="Str">{B23EEC4B-FA3C-41F5-A0BC-17085BC7DC80}</Property>
				<Property Name="App_serverConfig.httpPort" Type="Int">8002</Property>
				<Property Name="Bld_autoIncrement" Type="Bool">true</Property>
				<Property Name="Bld_buildCacheID" Type="Str">{B2C03369-90A6-4083-A2E9-680FC22956A4}</Property>
				<Property Name="Bld_buildSpecName" Type="Str">CSEISMIC</Property>
				<Property Name="Bld_excludeInlineSubVIs" Type="Bool">true</Property>
				<Property Name="Bld_excludeLibraryItems" Type="Bool">true</Property>
				<Property Name="Bld_excludePolymorphicVIs" Type="Bool">true</Property>
				<Property Name="Bld_localDestDir" Type="Path">../builds/CSEISMIC</Property>
				<Property Name="Bld_localDestDirType" Type="Str">relativeToCommon</Property>
				<Property Name="Bld_modifyLibraryFile" Type="Bool">true</Property>
				<Property Name="Bld_previewCacheID" Type="Str">{094B88EF-28E5-46A1-BC07-623EA86B4967}</Property>
				<Property Name="Bld_version.build" Type="Int">49</Property>
				<Property Name="Bld_version.major" Type="Int">1</Property>
				<Property Name="Destination[0].destName" Type="Str">CSEISMIC.exe</Property>
				<Property Name="Destination[0].path" Type="Path">../builds/CSEISMIC/CSEISMIC.exe</Property>
				<Property Name="Destination[0].preserveHierarchy" Type="Bool">true</Property>
				<Property Name="Destination[0].type" Type="Str">App</Property>
				<Property Name="Destination[1].destName" Type="Str">Support Directory</Property>
				<Property Name="Destination[1].path" Type="Path">../builds/CSEISMIC/data</Property>
				<Property Name="Destination[2].destName" Type="Str">External Code</Property>
				<Property Name="Destination[2].path" Type="Path">../builds/CSEISMIC/External Code/Python OnGrid Optimization</Property>
				<Property Name="Destination[3].destName" Type="Str">CSEISMIC Configs</Property>
				<Property Name="Destination[3].path" Type="Path">../builds/CSEISMIC/CSEISMIC Configs</Property>
				<Property Name="Destination[4].destName" Type="Str">Default Forecasts</Property>
				<Property Name="Destination[4].path" Type="Path">../builds/CSEISMIC/Default Forecasts</Property>
				<Property Name="Destination[5].destName" Type="Str">Configuration</Property>
				<Property Name="Destination[5].path" Type="Path">../builds/CSEISMIC/Configuration</Property>
				<Property Name="Destination[6].destName" Type="Str">data</Property>
				<Property Name="Destination[6].path" Type="Path">../builds/CSEISMIC/data</Property>
				<Property Name="DestinationCount" Type="Int">7</Property>
				<Property Name="Exe_iconItemID" Type="Ref">/My Computer/EMS.ico</Property>
				<Property Name="Source[0].itemID" Type="Str">{58FF6B8B-FC67-44F0-94E6-980F552B6174}</Property>
				<Property Name="Source[0].type" Type="Str">Container</Property>
				<Property Name="Source[1].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[1].itemID" Type="Ref">/My Computer/EMS Launcher.lvlib/Launcher.vi</Property>
				<Property Name="Source[1].sourceInclusion" Type="Str">TopLevel</Property>
				<Property Name="Source[1].type" Type="Str">VI</Property>
				<Property Name="Source[10].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[10].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[10].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[10].itemID" Type="Ref">/My Computer/Device Specific Actors</Property>
				<Property Name="Source[10].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[10].type" Type="Str">Container</Property>
				<Property Name="Source[11].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[11].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[11].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[11].itemID" Type="Ref">/My Computer/Integration Testers</Property>
				<Property Name="Source[11].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[11].type" Type="Str">Container</Property>
				<Property Name="Source[12].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[12].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[12].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[12].itemID" Type="Ref">/My Computer/Dialog Actors</Property>
				<Property Name="Source[12].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[12].type" Type="Str">Container</Property>
				<Property Name="Source[13].Container.applyDestination" Type="Bool">true</Property>
				<Property Name="Source[13].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[13].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[13].destinationIndex" Type="Int">3</Property>
				<Property Name="Source[13].itemID" Type="Ref">/My Computer/CSEISMIC Configs</Property>
				<Property Name="Source[13].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[13].type" Type="Str">Container</Property>
				<Property Name="Source[14].Container.applyDestination" Type="Bool">true</Property>
				<Property Name="Source[14].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[14].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[14].destinationIndex" Type="Int">4</Property>
				<Property Name="Source[14].itemID" Type="Ref">/My Computer/Default Forecasts</Property>
				<Property Name="Source[14].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[14].type" Type="Str">Container</Property>
				<Property Name="Source[15].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[15].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[15].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[15].itemID" Type="Ref">/My Computer/Abstract Actors</Property>
				<Property Name="Source[15].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[15].type" Type="Str">Container</Property>
				<Property Name="Source[16].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[16].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[16].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[16].itemID" Type="Ref">/My Computer/Remote Operation</Property>
				<Property Name="Source[16].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[16].type" Type="Str">Container</Property>
				<Property Name="Source[2].Container.applyDestination" Type="Bool">true</Property>
				<Property Name="Source[2].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[2].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[2].destinationIndex" Type="Int">5</Property>
				<Property Name="Source[2].itemID" Type="Ref">/My Computer/Configuration</Property>
				<Property Name="Source[2].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[2].type" Type="Str">Container</Property>
				<Property Name="Source[3].Container.applyDestination" Type="Bool">true</Property>
				<Property Name="Source[3].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[3].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[3].destinationIndex" Type="Int">6</Property>
				<Property Name="Source[3].itemID" Type="Ref">/My Computer/RTI DLLs</Property>
				<Property Name="Source[3].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[3].type" Type="Str">Container</Property>
				<Property Name="Source[4].Container.applyDestination" Type="Bool">true</Property>
				<Property Name="Source[4].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[4].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[4].destinationIndex" Type="Int">2</Property>
				<Property Name="Source[4].itemID" Type="Ref">/My Computer/External Code</Property>
				<Property Name="Source[4].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[4].type" Type="Str">Container</Property>
				<Property Name="Source[5].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[5].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[5].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[5].itemID" Type="Ref">/My Computer/Optimization</Property>
				<Property Name="Source[5].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[5].type" Type="Str">Container</Property>
				<Property Name="Source[6].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[6].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[6].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[6].itemID" Type="Ref">/My Computer/Global Variables</Property>
				<Property Name="Source[6].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[6].type" Type="Str">Container</Property>
				<Property Name="Source[7].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[7].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[7].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[7].itemID" Type="Ref">/My Computer/IED Actors</Property>
				<Property Name="Source[7].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[7].type" Type="Str">Container</Property>
				<Property Name="Source[8].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[8].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[8].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[8].itemID" Type="Ref">/My Computer/EMS Core</Property>
				<Property Name="Source[8].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[8].type" Type="Str">Container</Property>
				<Property Name="Source[9].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[9].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[9].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[9].itemID" Type="Ref">/My Computer/EMS User Interface Actor</Property>
				<Property Name="Source[9].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[9].type" Type="Str">Container</Property>
				<Property Name="SourceCount" Type="Int">17</Property>
				<Property Name="TgtF_companyName" Type="Str">ORNL</Property>
				<Property Name="TgtF_fileDescription" Type="Str">CSEISMIC</Property>
				<Property Name="TgtF_internalName" Type="Str">CSEISMIC</Property>
				<Property Name="TgtF_legalCopyright" Type="Str">Copyright © 2017 ORNL</Property>
				<Property Name="TgtF_productName" Type="Str">CSEISMIC</Property>
				<Property Name="TgtF_targetfileGUID" Type="Str">{ACAC90A0-AC90-461B-A95F-BE848C67CA3A}</Property>
				<Property Name="TgtF_targetfileName" Type="Str">CSEISMIC.exe</Property>
			</Item>
		</Item>
	</Item>
</Project>
