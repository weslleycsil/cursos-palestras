var mongoose 		= require('mongoose');

mongoose.Promise = global.Promise;
const dbase = 'mongodb://database:27017/cursoDocker';
const connection = mongoose.connect(dbase);

connection
	.then(db => {
		console.log(
			`Conectado com sucesso a ${dbase} MongoDB`,
		);
		return db;
	})
	.catch(err => {
		if (err.message.code === 'ETIMEDOUT') {
			console.log('Tentando re-estabelecer conexão ao BD.');
			mongoose.connect(dbase);
		} else {
			console.error('Erro ao tentar conectar ao BD: ');
			console.error(err);
		}
	});

module.exports = connection;