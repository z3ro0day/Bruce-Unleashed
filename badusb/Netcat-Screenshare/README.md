
<h2 align="center"> Desktop Screensahre Over Netcat </h2>

SYNOPSIS

Starts a video stream of the desktop to a netcat session (the output is viewed in a browser.)

USAGE

Run script on target Windows system.
On a Linux box use this command > nc -lvnp 9000 | nc -lvnp 8080
Then in a firefox browser goto  > http://localhost:8080

(Firefox is the only browser that supports the codec for the video stream..)