require('dotenv').config() 
const path = require('path')

const output_res = '1280x720'
const refresh_rate = '30'
const stream_uri = process.env.STREAM_URI

const args = ['-f','v4l2','-pix_fmt','yuv420p','-thread_queue_size','10240','-codec:v','h264','-s',output_res,'-r',refresh_rate,'-i','/dev/video0','-codec:v','copy','-codec:a','copy','-f','flv',stream_uri]

console.log(path.resolve(process.cwd(), '.env'))
const { spawn } = require('child_process');
const child = spawn('ffmpeg', args, { detached : true })


child.stdout.on('data', (data) => {
    console.log('FFMPEG' + data);
});

child.stderr.on('data', data => {
    console.log('FFMPEG : ' + data);
})


setTimeout(()=> child.kill(),20000)
