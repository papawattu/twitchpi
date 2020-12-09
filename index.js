require('dotenv').config() 

//const Gpio = require('onoff').Gpio;
const path = require('path')

const output_res = process.env.OUTPUT_RES || '1280x720'
const refresh_rate = process.env.OUTPUT_REFRESH || '60'
const stream_uri = process.env.STREAM_URI
const video_dev = process.env.VIDEO_DEV || '/dev/video0'
const audio_dev = process.env.AUDIO_DEV || 'hw:0'
const bit_rate = process.env.BIT_RATE || '2800k'
const start_gpio_pin = process.env.START_GPIO_PIN || 4
const audio_sample_rate = process.env.AUDIO_SAMPLE_RATE || 48000

const autostart = process.env.AUTOSTART || true

//const button = new Gpio(start_gpio_pin, 'in', 'rising', {debounceTimeout: 0});


const args = [
     '-thread_queue_size','10240'
    ,'-threads','4'
//    ,'-f','alsa'
//    ,'-i',audio_dev
    ,'-re'
    ,'-f','v4l2'
    ,'-i',video_dev
//    ,'-map','0:0'
    ,'-c:v','h264_omx'
    ,'-s',output_res
    ,'-r',refresh_rate
    ,'-strict','experimental'
    ,'-b:v',bit_rate 
    ,'-bufsize','6M'
    ,'-minrate',bit_rate
    ,'-maxrate',bit_rate
    ,'-g','30'
    ,'-pix_fmt','yuv420p'
//    ,'-map','1:0'
//    ,'-ar',audio_sample_rate
    ,'-codec:a','aac'
    ,'-f','flv'
    ,stream_uri]

const { spawn } = require('child_process');

let streaming = null

if(!stream_uri) {
    console.log('No stream URI found - set STREAM_URI environment variable')
    process.exit()
}

console.log("TwtichPi")

console.log(`Button on GPIO ${start_gpio_pin}\nPress control + c to quit`)

function startStream()
{
    const child = spawn('ffmpeg', args)


    child.stdout.on('data', (data) => {
        console.log('FFMPEG' + data);
    });
    
    child.stderr.on('data', data => {
        console.log('FFMPEG : ' + data);
        
    })
    return child
}

if(autostart) {
	startStream()
}
