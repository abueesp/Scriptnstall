echo "
In your case, I would kindly like to ask you to perform a Recovery Update, which is an alternate update procedure to the Desktop Updater and the Rapid Update. The Recovery Update will reinstall the firmware on each Dash individually in order to ensure that everything is installed properly.
Please be aware, that we want to solve this issue together with you, and the following has proven to be a successful procedure:

1) Make sure, The Charger is charged.

2) Insert both The Left Dash and The Right Dash and attach it to the computer via the USB (leave it attached).

3) Press the reset button of The Charger for 1-2 seconds.

4) After a few seconds "The Dash" might show up in file manager twice (2x) and sometimes it won't, please continue in either way.

5) Now press the reset button of The Charger for 5 seconds until the LED of The Charger (next to the USB port) blinks red 3 times and wait for a few seconds.

6) You should now see "THE DASH“ two times in your Explorer/Finder. You can identify The Left Dash by the lower storage size of about ~4MB and no "My Music" folder inside. The other folder represents The Right Dash. (if one of them doesn't show up please repeat steps 3-5)

7) Put the left side rapid update file fwthedash_bl.bra on The Left Dash and the right side update file fwthedash_br.bra on The Right Dash.

8) After you copied both files to the respective side of The Dash (It might a bit longer for The Left Dash to transfer the file), disconnect the USB cable (don't reconnect).

9) The Dash will begin to blink rapidly which indicates the update has begun, it can take a few seconds before this starts. Once your Dash is breathing as normal the update is completed. This process takes between 5 to minutes. It is possible that the LED of the Dash might breath red, indicating that the battery was empty and is now charging.

10) Your The Dash is now recovered. Let it charge and have fun with it.

In case the Dash is not connecting to your PC, please try this procedure using a different Micro USB cable.
If the connection is still not working please send us a picture of The Dash and The Charger focusing the golden charging pins. Furthermore, if you are facing any difficulties performing this procedure please let us know at which exact step of the recovery update you do."

wget http://update.bragi.com/firmware/latest/fwthedash_bl.bra
wget http://update.bragi.com/firmware/latest/fwthedash_br.bra
