#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export udpspeeder_`

start_udpspeeder(){
	[ -n "$udpspeeder_timeout" ] && timeout="--timeout $udpspeeder_timeout" || timeout=""
	[ -n "$udpspeeder_report" ] && report="--timeout $udpspeeder_report" || report=""
	[ -n "$udpspeeder_fecmode" ] && fecmode="--mode $udpspeeder_fecmode" || fecmode=""
	[ -n "$udpspeeder_mtu" ] && mtu="--mtu $udpspeeder_mtu" || mtu=""
	[ -n "$udpspeeder_queue_len" ] && queue_len="--queue-len $udpspeeder_queue_len" || queue_len=""
	[ -n "$udpspeeder_jitter" ] && jitter="--jitter $udpspeeder_jitter" || jitter=""
	[ -n "$udpspeeder_interval" ] && interval="--interval $udpspeeder_interval" || interval=""
	[ -n "$udpspeeder_drop" ] && drop="--random-drop $udpspeeder_drop" || drop=""
	[ -n "$udpspeeder_fifo" ] && fifo="--fifo $udpspeeder_fifo" || fifo=""
	[ -n "$udpspeeder_decode_buf" ] && decode_buf="--decode-buf $udpspeeder_decode_buf" || decode_buf=""
	[ -n "$udpspeeder_fix_latency" ] && decode_buf="--fix_latency $udpspeeder_fix_latency" || fix_latency=""
	[ -n "$udpspeeder_delay_capacity" ] && delay_capacity="--delay-capacity $udpspeeder_delay_capacity" || delay_capacity=""
	[ -n "$udpspeeder_sock_buf" ] && sock_buf="--sock-buf $udpspeeder_sock_buf" || sock_buf=""
	[ "$udpspeeder_disable_obscure" == "1" ] && dobscure="--disable-obscure" || dobscure=""
	[ "$udpspeeder_disable_fec" == "1" ] && dfec="--disable-fec" || dfec=""
	speederv2 $udpspeeder_mode -l $udpspeeder_local_server:$udpspeeder_local_port -r $udpspeeder_remote_server:$udpspeeder_remote_port -f $udpspeeder_fec -k "$udpspeeder_password" $timeout $report $fecmode $mtu $queue_len $jitter $interval $drop $fifo $decode_buf $fix_latency $delay_capacity $sock_buf $sock_buf $dobscure $dfec >/dev/null 2>&1 &
	sleep 1
	if [ -n "$udpspeeder_shell" ];then
		if [ -f "$udpspeeder_shell" ];then
			chmod +x $udpspeeder_shell
			start-stop-daemon -S -q -b -x $udpspeeder_shell
		fi
	fi
}

# used by rc.d
case $1 in
start)
	if [ "$udpspeeder_enable" == "1" ];then
		start_udpspeeder
	else
        killall speederv2
	fi
	;;
stop)
	killall speederv2
	;;
esac

# used by httpdb
case $2 in
start)
	if [ "$udpspeeder_enable" == "1" ];then
		killall speederv2
		start_udpspeeder
		http_response '设置已保存！切勿重复提交！页面将在1秒后刷新'
	else
		killall speederv2
        http_response '设置已保存！切勿重复提交！页面将在1秒后刷新'
    fi
	;;
stop)
	killall speederv2
    http_response '设置已保存！切勿重复提交！页面将在1秒后刷新'
	;;
esac
