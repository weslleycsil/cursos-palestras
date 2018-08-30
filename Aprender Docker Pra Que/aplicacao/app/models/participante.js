var mongoose = require('mongoose'); 
var Schema = mongoose.Schema;

const participanteSchema = new Schema({ 
    codigo: {type: String, trim: true, required: true, default: '', lowercase: true, index: true, unique: true}, 
    nome: String,  
    email: String
   }, {collection: 'participantes'});
   
module.exports = mongoose.model('Participante', participanteSchema); // export model for use