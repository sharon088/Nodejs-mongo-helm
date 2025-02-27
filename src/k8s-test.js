const mongoose = require('mongoose');
const mongoServiceName = process.env.MONGO_SERVICE_NAME || 'parkentin';
const url = `mongodb://${mongoServiceName}`;

async function main() {
    console.log('connecting to mongo')
    await mongoose.connect(url,{
        socketTimeoutMS: 120000
    });
    
    console.log('connected to mongo')
    const mongo = mongoose.connection;
    mongo.on('error', error => { console.error('mongo: ' + error.name) })
    mongo.on('connected', () => { console.log('mongo: Connected') })
    mongo.on('disconnected', () => { console.log('mongo: Disconnected') })
}
main()
