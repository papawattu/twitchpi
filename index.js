require('dotenv').config() 

const Gpio = require('onoff').Gpio;
const path = require('path')

const output_res = process.env.OUTPUT_RES || '1280x720'
const refresh_rate = process.env.OUTPUT_REFRESH || '30'
const stream_uri = process.env.STREAM_URI
const start_gpio_pin = process.env.START_GPIO_PIN || 4

const button = new Gpio(start_gpio_pin, 'in', 'rising', {debounceTimeout: 10});

const args = ['-f'
    ,'v4l2'
    ,'-pix_fmt','yuv420p'
    ,'-thread_queue_size','10240'
    ,'-codec:v','h264'
    ,'-s',output_res
    ,'-r',refresh_rate
    ,'-i','/dev/video0'
    ,'-codec:v','copy'
    ,'-codec:a','copy'
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

button.watch((err, value) => {
    if (err) {
      throw err;
    }
    if(!streaming) {
        console.log('Starting stream')
        
        streaming = startStream()

    } else {
        console.log('Stopping stream')
        
        streaming.kill()
        streaming = null
    }
    
})

