
* CPU
```
echo 4194303 > /proc/sys/kernel/pid_max   
echo “8192” > cat /sys/block/sda/queue/read_ahead_kb                        # pre-read
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor    # do it use script @-cpufreq
```

* HDD
```
echo deadline > /sys/block/sda/queue/scheduler    #HDA
echo noop > /sys/block/sda/queue/scheduler        #SSD
```


* Scripts @-cpufreq
```
#!/bin/bash
#set cpu scaling governor by your self
set_cpu()
{
    for i in `ls /sys/devices/system/cpu/ | grep 'cpu[0-9]?*'`
    do
        echo $1 > /sys/devices/system/cpu/$i/cpufreq/scaling_governor
    done
}

#判断输入
case $1 in
    #performance
    "pf")
        set_cpu performance
        ;;
    #ondemand
    "od")
        ;;
    #conservative
    "cs")
        ;;
    #powersave
    "ps")
        set_cpu powersave
        ;;
    *)
        echo "please input [pf][od][cs][ps]"
        ;;
esac

chmod +x cpufreq.sh
sudo ./cpufreq.sh pf
```

* scaling_governor
```
內核模塊	              調節器名稱	      功能
cpufreq_ondemand	    ondemand	      按需調節，內核提供的功能，不是很強大，但有效實現了動態頻率調節
cpufreq_powersave	    powersave	      省電模式，通常以最低頻率運行，
cpufreq_userspace	    userspace	      用戶模式，一些調頻工具軟體需要在此模式下才能運行
cpufreq_conservative	conservative   「保守」模式，類似於ondemand，但調整相對較緩
N/A	                  performance	    不降頻
```
