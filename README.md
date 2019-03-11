# volumio_tft
Scripts to display volumio information on an fbtft_device display. The kernel modules are configured for an 2.4" itdb28 TFT display + ads7846 resistive touchscreen bought from dx.com (sku-285311)

use in combination with https://github.com/ferbar/fb_cairo to display the track currently played.

##itb28 / ILI9325 config
copy etc_systemd/* to /etc/systemd/system
systemctl enable volumio_tft.timer

copy etc_modules* to /etc/modulesxyz

##ads7846 config
only configurable by an dtoverly (google for ads7846-overlay.dts)

/boot/config.txt:
```ini
# display is using i2c pins, we have to turn it off:
dtparam=i2c_arm=off

dtparam=spi=on
#dtoverlay=spi0-cs,cs0_pin=16,cs1_pin=0
# 40+41 wird nicht verwendet alternative: eigenes dts file schreiben, default cs1=7 wird vom display verwendet
#keine spi-CS pins, dx display touchscreen cs hängt immer auf masse
dtoverlay=spi0-cs,cs0_pin=40,cs1_pin=41
dtoverlay=ads7846,cs=NO,penirq=8,speed=10000,penirq_pull=2,xohms=150
#dtoverlay=ads7846,cs=1,penirq=17,penirq_pull=2,speed=1000000,keep_vref_on=1,swapxy=1,pmax=255,xohms=60,xmin=200,xmax=3900,ymin=200,ymax=3900
```

