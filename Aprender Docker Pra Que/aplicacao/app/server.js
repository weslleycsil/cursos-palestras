var express     = require("express");
var app         = express();
var bodyParser  = require("body-parser");

var cors            = require('cors');

var corsOptions = {
    origin: "*",
    methods: "GET,PUT,POST,DELETE",
    optionsSuccessStatus: 204
};

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors(corsOptions));

var principalRota = require('./rotas/principal')

app.use('/', principalRota);

var server = app.listen('8080', function () {
    console.log('APP rodando na porta: ', server.address().port);
    require('./db');
});