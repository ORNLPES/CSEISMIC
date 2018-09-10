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
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="Configs" Type="Folder">
			<Item Name="ES1_Config.ini" Type="Document" URL="../Configs/ES1_Config.ini"/>
			<Item Name="ES2_Config.ini" Type="Document" URL="../Configs/ES2_Config.ini"/>
			<Item Name="GEN_Config.ini" Type="Document" URL="../Configs/GEN_Config.ini"/>
			<Item Name="Load_Config.ini" Type="Document" URL="../Configs/Load_Config.ini"/>
			<Item Name="PV_Config.ini" Type="Document" URL="../Configs/PV_Config.ini"/>
			<Item Name="SmartRelay_Config.ini" Type="Document" URL="../Configs/SmartRelay_Config.ini"/>
		</Item>
		<Item Name="Controls" Type="Folder">
			<Item Name="Data Type DVRs.ctl" Type="VI" URL="../Controls/Data Type DVRs.ctl"/>
			<Item Name="DDS State.ctl" Type="VI" URL="../Controls/DDS State.ctl"/>
			<Item Name="Generation Mode Loop Selector.ctl" Type="VI" URL="../Controls/Generation Mode Loop Selector.ctl"/>
			<Item Name="GenerationMode.ctl" Type="VI" URL="../Controls/GenerationMode.ctl"/>
			<Item Name="Scaling Coefficients Cluster.ctl" Type="VI" URL="../Controls/Scaling Coefficients Cluster.ctl"/>
			<Item Name="Scaling Coefficients Measurements.ctl" Type="VI" URL="../Controls/Scaling Coefficients Measurements.ctl"/>
			<Item Name="Scaling Coefficients Setpoints.ctl" Type="VI" URL="../Controls/Scaling Coefficients Setpoints.ctl"/>
			<Item Name="Smart Relay Config Settings.ctl" Type="VI" URL="../Controls/Smart Relay Config Settings.ctl"/>
			<Item Name="Smart Relay Scaling Cluster.ctl" Type="VI" URL="../Controls/Smart Relay Scaling Cluster.ctl"/>
			<Item Name="State Transition Loop Selector.ctl" Type="VI" URL="../Controls/State Transition Loop Selector.ctl"/>
		</Item>
		<Item Name="Devices" Type="Folder">
			<Item Name="ES Main.vi" Type="VI" URL="../Devices/ES Main.vi"/>
			<Item Name="ES2 Main.vi" Type="VI" URL="../Devices/ES2 Main.vi"/>
			<Item Name="Gen Main.vi" Type="VI" URL="../Devices/Gen Main.vi"/>
			<Item Name="Load Main.vi" Type="VI" URL="../Devices/Load Main.vi"/>
			<Item Name="PCC Main.vi" Type="VI" URL="../Devices/PCC Main.vi"/>
			<Item Name="PV Main.vi" Type="VI" URL="../Devices/PV Main.vi"/>
		</Item>
		<Item Name="Global Variables" Type="Folder">
			<Item Name="Broadcast Topics (Global).vi" Type="VI" URL="../Global Variables/Broadcast Topics (Global).vi"/>
			<Item Name="DDS States (Global).vi" Type="VI" URL="../Global Variables/DDS States (Global).vi"/>
			<Item Name="Manual Control (Global).vi" Type="VI" URL="../Global Variables/Manual Control (Global).vi"/>
			<Item Name="Measurements (Global).vi" Type="VI" URL="../Global Variables/Measurements (Global).vi"/>
			<Item Name="Stop (Global).vi" Type="VI" URL="../Global Variables/Stop (Global).vi"/>
			<Item Name="Timeout Topics (Global).vi" Type="VI" URL="../Global Variables/Timeout Topics (Global).vi"/>
		</Item>
		<Item Name="subVIs" Type="Folder">
			<Item Name="Config Reader" Type="Folder">
				<Property Name="NI.SortType" Type="Int">3</Property>
				<Item Name="Read INI File (ES).vi" Type="VI" URL="../subVIs/Read INI File (ES).vi"/>
				<Item Name="ES Info Data from INI.vi" Type="VI" URL="../subVIs/ES Info Data from INI.vi"/>
				<Item Name="Read INI File (Gen).vi" Type="VI" URL="../subVIs/Read INI File (Gen).vi"/>
				<Item Name="Gen Info Data from INI.vi" Type="VI" URL="../subVIs/Gen Info Data from INI.vi"/>
				<Item Name="Read INI File (PV).vi" Type="VI" URL="../subVIs/Read INI File (PV).vi"/>
				<Item Name="PV Info Data from INI.vi" Type="VI" URL="../subVIs/PV Info Data from INI.vi"/>
				<Item Name="DER Info Data from INI.vi" Type="VI" URL="../subVIs/DER Info Data from INI.vi"/>
				<Item Name="Read ScalingData INI File.vi" Type="VI" URL="../subVIs/Read ScalingData INI File.vi"/>
				<Item Name="Read SmartRelay INI File.vi" Type="VI" URL="../subVIs/Read SmartRelay INI File.vi"/>
				<Item Name="Scaling Coefficients from INI.vi" Type="VI" URL="../subVIs/Scaling Coefficients from INI.vi"/>
			</Item>
			<Item Name="Faults" Type="Folder">
				<Item Name="Island Fault.vi" Type="VI" URL="../subVIs/Faults/Island Fault.vi"/>
				<Item Name="Switch Close Fault.vi" Type="VI" URL="../subVIs/Faults/Switch Close Fault.vi"/>
				<Item Name="Switch Open Fault.vi" Type="VI" URL="../subVIs/Faults/Switch Open Fault.vi"/>
				<Item Name="VF_DeviceID Zero Fault.vi" Type="VI" URL="../subVIs/Faults/VF_DeviceID Zero Fault.vi"/>
			</Item>
			<Item Name="DDS Comms.vi" Type="VI" URL="../subVIs/DDS Comms.vi"/>
			<Item Name="DDS Inits.vi" Type="VI" URL="../subVIs/DDS Inits.vi"/>
			<Item Name="Delete DVR Entry for DeviceID.vi" Type="VI" URL="../subVIs/Delete DVR Entry for DeviceID.vi"/>
			<Item Name="Initialize Data DVRs.vi" Type="VI" URL="../subVIs/Initialize Data DVRs.vi"/>
			<Item Name="Ramp Rate Coercion.vi" Type="VI" URL="../subVIs/Ramp Rate Coercion.vi"/>
		</Item>
		<Item Name="Data DVRs.lvlib" Type="Library" URL="../Malleable Data Transfer/Data DVRs.lvlib"/>
		<Item Name="Top Level.vi" Type="VI" URL="../Top Level.vi"/>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="user.lib" Type="Folder">
				<Item Name="String to 1D Array__ogtk.vi" Type="VI" URL="/&lt;userlib&gt;/_OpenG.lib/string/string.llb/String to 1D Array__ogtk.vi"/>
			</Item>
			<Item Name="vi.lib" Type="Folder">
				<Item Name="8.6CompatibleGlobalVar.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/config.llb/8.6CompatibleGlobalVar.vi"/>
				<Item Name="Application Directory.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Application Directory.vi"/>
				<Item Name="BuildHelpPath.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/BuildHelpPath.vi"/>
				<Item Name="Check if File or Folder Exists.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/libraryn.llb/Check if File or Folder Exists.vi"/>
				<Item Name="Check Special Tags.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Check Special Tags.vi"/>
				<Item Name="Clear Errors.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Clear Errors.vi"/>
				<Item Name="Convert property node font to graphics font.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Convert property node font to graphics font.vi"/>
				<Item Name="CSEISMIC DDS.lvlib" Type="Library" URL="/&lt;vilib&gt;/ORNL/CSEISMIC DDS/CSEISMIC DDS.lvlib"/>
				<Item Name="Details Display Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Details Display Dialog.vi"/>
				<Item Name="DialogType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogType.ctl"/>
				<Item Name="DialogTypeEnum.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogTypeEnum.ctl"/>
				<Item Name="Error Cluster From Error Code.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Cluster From Error Code.vi"/>
				<Item Name="Error Code Database.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Code Database.vi"/>
				<Item Name="ErrWarn.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/ErrWarn.ctl"/>
				<Item Name="eventvkey.ctl" Type="VI" URL="/&lt;vilib&gt;/event_ctls.llb/eventvkey.ctl"/>
				<Item Name="Find Tag.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Find Tag.vi"/>
				<Item Name="Format Message String.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Format Message String.vi"/>
				<Item Name="FormatTime String.vi" Type="VI" URL="/&lt;vilib&gt;/express/express execution control/ElapsedTimeBlock.llb/FormatTime String.vi"/>
				<Item Name="General Error Handler Core CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/General Error Handler Core CORE.vi"/>
				<Item Name="General Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/General Error Handler.vi"/>
				<Item Name="Get String Text Bounds.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Get String Text Bounds.vi"/>
				<Item Name="Get Text Rect.vi" Type="VI" URL="/&lt;vilib&gt;/picture/picture.llb/Get Text Rect.vi"/>
				<Item Name="GetHelpDir.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/GetHelpDir.vi"/>
				<Item Name="GetRTHostConnectedProp.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/GetRTHostConnectedProp.vi"/>
				<Item Name="Longest Line Length in Pixels.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Longest Line Length in Pixels.vi"/>
				<Item Name="LVBoundsTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVBoundsTypeDef.ctl"/>
				<Item Name="LVDDS_library.lvlib" Type="Library" URL="/&lt;vilib&gt;/RTI DDS Toolkit/Library/LVDDS_library.lvlib"/>
				<Item Name="LVRectTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVRectTypeDef.ctl"/>
				<Item Name="NI_AALBase.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/NI_AALBase.lvlib"/>
				<Item Name="NI_FileType.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/lvfile.llb/NI_FileType.lvlib"/>
				<Item Name="NI_LVConfig.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/config.llb/NI_LVConfig.lvlib"/>
				<Item Name="NI_PackedLibraryUtility.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/LVLibp/NI_PackedLibraryUtility.lvlib"/>
				<Item Name="NI_PtbyPt.lvlib" Type="Library" URL="/&lt;vilib&gt;/ptbypt/NI_PtbyPt.lvlib"/>
				<Item Name="Not Found Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Not Found Dialog.vi"/>
				<Item Name="PV_Info.ctl" Type="VI" URL="/&lt;vilib&gt;/ORNL/CSEISMIC DDS/CSEISMIC DDS Base/Data Types/PV_Info.ctl"/>
				<Item Name="rtilvdds.dll" Type="Document" URL="/&lt;vilib&gt;/_RTI DDS Toolkit_internal_deps/rtilvdds.dll"/>
				<Item Name="Search and Replace Pattern.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Search and Replace Pattern.vi"/>
				<Item Name="Set Bold Text.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set Bold Text.vi"/>
				<Item Name="Set String Value.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set String Value.vi"/>
				<Item Name="Simple Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Simple Error Handler.vi"/>
				<Item Name="subElapsedTime.vi" Type="VI" URL="/&lt;vilib&gt;/express/express execution control/ElapsedTimeBlock.llb/subElapsedTime.vi"/>
				<Item Name="TagReturnType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/TagReturnType.ctl"/>
				<Item Name="Three Button Dialog CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog CORE.vi"/>
				<Item Name="Three Button Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog.vi"/>
				<Item Name="Trim Whitespace.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Trim Whitespace.vi"/>
				<Item Name="whitespace.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/whitespace.ctl"/>
			</Item>
			<Item Name="lvanlys.dll" Type="Document" URL="/&lt;resource&gt;/lvanlys.dll"/>
		</Item>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
