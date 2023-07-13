const COS = require('cos-nodejs-sdk-v5');

// Set up Tencent COS SDK
const cos = new COS({
    SecretId: 'AKIDviKitqZBYhBTXNzNXTBfvxkeMsBJFzUl',
    SecretKey: '5wZy83kCbomW2JMAl8HCseEahaGiwvhG'
});

exports.main = async function (event,context) {
    return new Promise((resolve, reject) => {
        cos.getBucket({
            Bucket: 'stupid-english-app-1318830690',
            Region: 'ap-shanghai',
            Prefix: 'audios/',
        }, function (err, data) {
              console.log('Error:', err);
              console.log('Data:', data);
            if (err) {
                reject(err);
            } else {
                var count = 0;
                for (var i = 0; i < data.Contents.length; i++) {
                    let file = data.Contents[i];
                    if (file.Key.endsWith('.mp3')) {
                        // 执行你需要的操作
                        console.log(file.Key);
                        count++;
                    }
                }
                resolve({
                    fileCount: count
                });
                }
            }
        )
    })
}