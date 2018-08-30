// importar modelo Participantes
var Participantes = require('../models/participante');

exports.list = (req, res) => {
    Participantes.find()
    .then(participantes => {
        res.json(participantes);
    })
    .catch(err => {
        console.error(err);
        res.status(422).send(err.errors);
    });
};

exports.sortear = (req, res) => {
    Participantes.find()
    .then(participantes => {
        res.json(participantes[((Math.random() * participantes.length) | 0)]);
    })
    .catch(err => {
        console.error(err);
        res.status(422).send(err.errors);
    });
};


exports.get = (req, res) => {
    Participantes.find({codigo: req.params.codigo})
    .then(participante => {
        res.json(participante);
    })
    .catch(err => {
        console.error(err);
        res.status(422).send(err.errors);
    });
};

exports.post = (req, res) => {

    const data = req.body || {};
    var dado = new Participantes(data);

    dado.save()
        .then(participante => {
            res.json(participante);
        })
        .catch(err => {
            logger.error(err);
            res.status(500).send(err);
        });
};

exports.put = (req, res) => {
    Participantes.findOneAndUpdate({codigo: req.params.codigo}, req.body, function(err, participante) {
        if (err)
            res.status(422).send(err);
        res.json(participante);
    });
};

exports.delete = (req, res) => {
    Participantes.findOneAndRemove({codigo: req.params.codigo})
    .then(participante => {
        if (!participante) {
            return res.sendStatus(404);
        }

        res.sendStatus(204);
    })
    .catch(err => {
        console.log(err);
        res.status(422).send(err.errors);
    });
};