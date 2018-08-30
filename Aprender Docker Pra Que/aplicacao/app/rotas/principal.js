var express = require('express');
var router = express.Router();

var Participante = require('../controllers/participantesController');

router.get('/', Participante.list);
router.get('/sortear', Participante.sortear);

router.post('/', Participante.post);

router.get('/:codigo', Participante.get);
router.put('/:codigo', Participante.put);
router.delete('/:codigo', Participante.delete);

module.exports = router;