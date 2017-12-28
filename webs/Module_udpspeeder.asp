<title>软件中心 - UDPspeeder</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<style type="text/css">
	input[disabled]:hover{
    cursor:not-allowed;
}
</style>
<script type="text/javascript">
var dbus;
var softcenter = 0;
get_dbus_data();
setTimeout("get_run_status();", 1000);

function get_dbus_data(){
	$.ajax({
	  	type: "GET",
	 	url: "/_api/udpspeeder_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	dbus = data.result[0];
	  	}
	});
}

function get_run_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "udpspeeder_status.sh", "params":[2], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("_udpspeeder_status").innerHTML = response.result;
			setTimeout("get_run_status();", 3000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("_udpspeeder_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}

function verifyFields(focused, quiet){
	if(E('_udpspeeder_enable').checked){
		$('input').prop('disabled', false);
		$('select').prop('disabled', false);
	}else{
		$('input').prop('disabled', true);
		$('select').prop('disabled', true);
		$(E('_udpspeeder_enable')).prop('disabled', false);
	}
	return true;
}

function toggleVisibility(whichone) {
	if(E('sesdiv' + whichone).style.display=='') {
		E('sesdiv' + whichone).style.display='none';
		E('sesdiv' + whichone + 'showhide').innerHTML='<i class="icon-chevron-up"></i>';
		cookie.set('ss_' + whichone + '_vis', 0);
	} else {
		E('sesdiv' + whichone).style.display='';
		E('sesdiv' + whichone + 'showhide').innerHTML='<i class="icon-chevron-down"></i>';
		cookie.set('ss_' + whichone + '_vis', 1);
	}
}

function save(){
	var para_chk = ["udpspeeder_enable", "udpspeeder_disable_obscure"];
	var para_inp = ["udpspeeder_local_server", "udpspeeder_local_port", "udpspeeder_remote_server", "udpspeeder_remote_port", "udpspeeder_password", "udpspeeder_mode", "udpspeeder_fec", "udpspeeder_timeout", "udpspeeder_report", "udpspeeder_fecmode", "udpspeeder_mtu", "udpspeeder_queue_len", "udpspeeder_jitter", "udpspeeder_interval", "udpspeeder_drop", "udpspeeder_disable_obscure", "udpspeeder_fifo", "udpspeeder_decode_buf", "udpspeeder_fix_latency", "udpspeeder_delay_capacity", "udpspeeder_disable_fec", "udpspeeder_sock_buf", "udpspeeder_shell" ];
	// collect data from checkbox
	for (var i = 0; i < para_chk.length; i++) {
		dbus[para_chk[i]] = E('_' + para_chk[i] ).checked ? '1':'0';
	}
	// data from other element
	for (var i = 0; i < para_inp.length; i++) {
		console.log(E('_' + para_inp[i] ).value)
		if (!E('_' + para_inp[i] ).value){
			dbus[para_inp[i]] = "";
		}else{
			dbus[para_inp[i]] = E('_' + para_inp[i]).value;
		}
	}

	//-------------- post dbus to dbus ---------------
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method":'udpspeeder_config.sh', "params":["start"], "fields": dbus};
	var success = function(data) {
		$('#footer-msg').text(data.result);
		$('#footer-msg').show();
		setTimeout("window.location.reload()", 1000);
	};
	$('#footer-msg').text('保存中……');
	$('#footer-msg').show();
	$('button').addClass('disabled');
	$('button').prop('disabled', true);
	$.ajax({
	  type: "POST",
	  url: "/_api/",
	  data: JSON.stringify(postData),
	  success: success,
	  dataType: "json"
	});
}

</script>
<div class="box">
	<div class="heading">UDPspeeder 2.0.1<a href="#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
	<div class="content">
		<span class="col" style="line-height:30px;width:700px">
		Program:wangyu-<br />
		Interface:Hikaru Chang (i@rua.moe)<br />
		双边网络加速工具，软件本身的功能是加速UDP；不过，配合vpn可以加速全流量(包括TCP/UDP/ICMP)。通过合理配置，可以加速游戏，降低游戏的丢包和延迟；也可以加速下载和看视频这种大流量的应用。用1.5倍的流量，就可以把10%的丢包率降低到万分之一以下。跟 kcptun/finalspeed/BBR 等现有方案比，主要优势是可以加速 UDP 和 ICMP，现有方案几乎都只能加速 TCP。<br />
		最新的版本是v2版，在v1版的基础上增加了FEC功能，更省流量。<br />
		本插件仅实现web配置UDPspeeder功能，开启操作仅配置好加速通道，要进一步成功加速udp协议，还需要手动配置通道的下游软件，比如：shadowsocks，openvpn等..<br />
		详细介绍和使用教程请查看：<a href="https://github.com/wangyu-/UDPspeeder/blob/master/README.md" target="_blank"><u> 官方说明文档</u></a>&nbsp;&nbsp;&nbsp;&nbsp;
		</span>
	</div>
</div>
<div class="box" style="margin-top: 0px;">
	<div class="heading">基本配置（*表示UDPspeeder程序参数）</div>
	<hr>
	<div class="content">
	<div id="udpspeeder-fields"></div>
	<script type="text/javascript">
		var mode = [['-c', '客户端模式'], ['-s', '服务器模式']];
		$('#udpspeeder-fields').forms([
		{ title: '开启udpspeeder', name: 'udpspeeder_enable', type: 'checkbox', value: dbus.udpspeeder_enable == 1},
		{ title: 'udpspeeder运行状态', text: '<font id="_udpspeeder_status" name=udpspeeder_status color="#1bbf35">正在获取运行状态...</font>' },
		{ title: '* 本地监听地址：端口 （-l）', multi: [
			{ name: 'udpspeeder_local_server',type:'text', size: 20, value: dbus.udpspeeder_local_server || "0.0.0.0", suffix: ' ：' },
			{ name: 'udpspeeder_local_port', type: 'text', maxlen: 5, size: 10, value: dbus.udpspeeder_local_port || "7777"}
		]},
		{ title: '* 服务器地址：端口 （-r）', multi: [
			{ name: 'udpspeeder_remote_server',type:'text', size: 20, value: dbus.udpspeeder_remote_server, suffix: ' ：' },
			{ name: 'udpspeeder_remote_port', type: 'text', maxlen: 5, size: 10, value: dbus.udpspeeder_remote_port||"4095" }
		]},
		{ title: '* 密码 （-k,--key）', name: 'udpspeeder_password', type: 'password', maxlen: 20, size: 20, value: dbus.udpspeeder_password,peekaboo: 1},
		{ title: '* 运行模式 （-c/-s）', name: 'udpspeeder_mode', type: 'select', options:mode, value: dbus.udpspeeder_mode ||'-c' },
		{ title: '', suffix: '以下为包接收选项，两端设置可以不同。只影响本地包接受。' },

		{ title: '前向纠错 （--fec）', name: 'udpspeeder_fec', type: 'text', maxlen: 20, size: 20, value: dbus.udpspeeder_fec ||"",suffix: ' 前向纠错，为每个x包发送y冗余包。' },
		{ title: '超时 （--timeout）', name: 'udpspeeder_timeout', type: 'text', maxlen: 20, size: 20, value: dbus.udpspeeder_timeout ||"",suffix: ' 在做fec之前，一个数据包可以在队列中保持多久？单位：ms，默认值：8ms' },
		{ title: '数据发送和接受报告 （--report）', name: 'udpspeeder_report', type: 'text', maxlen: 20, size: 20, value: dbus.udpspeeder_report ||"",suffix: ' 数据发送和接受报告，单位：秒。开启后可以根据此数据推测出包速和丢包率等特征；留空则不使用。' },
		{ title: 'FEC模式 （--mode）', name: 'udpspeeder_fecmode', type: 'text', maxlen: 20, size: 20, value: dbus.udpspeeder_fecmode ||"",suffix: ' 可用值：0,1; 模式0（默认）花费更少带宽，没有mtu问题。' },
		{ title: 'MTU （--mtu）', name: 'udpspeeder_mtu', type: 'text', maxlen: 20, size: 20, value: dbus.udpspeeder_mtu ||"",suffix: ' 对于模式0，程序将分组分割成小于mtu值的分组。对于模式1，没有数据包将被拆分，程序只检查mtu是否超出。' },
		{ title: 'FEC队列长度 （--queue-len）', name: 'udpspeeder_queue_len', type: 'text', maxlen: 20, size: 20, value: dbus.udpspeeder_queue_len ||"",suffix: ' 只在模式0时，fec将在队列满后立即执行。默认值：200' },
		{ title: '原始数据抖动延迟 （-j）', name: 'udpspeeder_jitter', type: 'text', maxlen: 20, size: 20, value: dbus.udpspeeder_jitter ||"",suffix: ' 模拟抖动。随机延迟第一个数据包为0〜<数值> ms，默认值为0。如果你不知道这是什么意思，请不要使用。' },
		{ title: '间隔 （-interval）', name: 'udpspeeder_interval', type: 'text', maxlen: 20, size: 20, value: dbus.udpspeeder_interval ||"",suffix: ' 将每个fec组分散到<数值>ms的时间间隔，以保护突发性丢包。默认值：0。如果你不知道这是什么意思，请不要使用。' },
		{ title: '随机丢包 （--random-drop）', name: 'udpspeeder_drop', type: 'text', maxlen: 20, size: 20, value: dbus.udpspeeder_drop ||"",suffix: ' 模拟丢包，单位：0.01％。 默认值：0。' },
		{ title: '禁用模糊 （--disable-obscure）', name: 'udpspeeder_disable_obscure', type: 'checkbox', value: dbus.udpspeeder_disable_obscure == 1,suffix: ' 禁用模糊，以节省比特带宽和CPU。' },
		{ title: 'FIFO （--fifo）', name: 'udpspeeder_fifo', type: 'text', maxlen: 20, size: 20, value: dbus.udpspeeder_fifo ||"",suffix: ' 使用FIFO（命名管道）将命令发送到正在运行的程序，这样您就可以动态地修改FEC编码参数。' },
		{ title: '解码缓冲区 （--decode-buf）', name: 'udpspeeder_decode_buf', type: 'text', maxlen: 20, size: 20, value: dbus.udpspeeder_decode_buf ||"",suffix: ' FEC解码器的缓冲区大小，单位：数据包，默认值：2000' },
		{ title: '固定延迟 （--fix-latency）', name: 'udpspeeder_fix_latency', type: 'text', maxlen: 20, size: 20, value: dbus.udpspeeder_fix_latency ||"",suffix: ' 尝试稳定延迟，只适用于模式0' },
		{ title: '延迟容量 （--delay-capacity）', name: 'udpspeeder_delay_capacity', type: 'text', maxlen: 20, size: 20, value: dbus.udpspeeder_delay_capacity ||"",suffix: ' 最大数量的延迟数据包' },
		{ title: '禁用FEC （--disable-fec）', name: 'udpspeeder_disable_fec', type: 'checkbox', value: dbus.udpspeeder_disable_fec == 1,suffix: ' 完全禁用FEC，把程序变成一个普通的udp隧道' },
		{ title: '接口BUF （--sock-buf）', name: 'udpspeeder_sock_buf', type: 'text', maxlen: 20, size: 20, value: dbus.udpspeeder_sock_buf ||"",suffix: ' 套接字的buf大小> = 10且<= 10240，单位：千字节，默认值：1024' },

		{ title: '自定义触发脚本', name: 'udpspeeder_shell', type: 'text', size: 66, value: dbus.udpspeeder_shell ||"",suffix: ' 填写带绝对路径的shell脚本文件。UDPspeeder进程开启后会触发脚本启动。' }
		]);
		$('#_udpspeeder_enable').parent().parent().css("margin-left","-10px");
		$('#_udpspeeder_disable_filter').parent().parent().css("margin-left","-10px");
	</script>
	</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
