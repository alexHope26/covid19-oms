// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.4;

contract CentroSalud {
    
    // Direcciones de contrato y centro de salud 
    address public AddrCentroSalud;
    address public AddrContrato;
    


    constructor (address _direccion) {
        AddrCentroSalud = _direccion;
        AddrContrato = address(this);
    }

    //Estructura para los almacebar resultados
    struct InfoResultados{
        bool resultadoMuestra;
        uint256 timestamp;
    }

    //Evento Resultado para visualizar resultadoMuestra y timestamp
    event Resultado (bool, uint256);


    // Mapping de relacion entre el id de la persona con el resultado
    mapping (bytes8 => InfoResultados) ResultadosCOVID;
    
    //Exclusivo para el centro de salud 
    modifier ExclusivoCentroSalud(address _addrCentroSalud){
        require(_addrCentroSalud == AddrCentroSalud, "No se tienen permisos necesarios para ejecutar la funcion.");
        _;
    }

    //Funcion para expedicion de resultados de prueba COVID por centro de salud
    function ExpedicionResultadosCovid19(bytes8 _idPersona,bool _resultadoCovid) public ExclusivoCentroSalud(msg.sender){
        //Obtiene el timestamp del bloque
        uint256 _tiempo = block.timestamp;
        //Almacena en Mapping el ID persona y el timestamp
        ResultadosCOVID[_idPersona] = InfoResultados(_resultadoCovid,_tiempo);
        emit Resultado(_resultadoCovid,_tiempo);
    }


    //Funcion para la Consulta de resultados por el ID de persona (idPersona de 8 bytes)
    function ConsultaResultados(bytes8 _idPersona)public view returns(string memory _resultadoPruebaCOVID19, uint256 _time){
    //Resultado de la prueba en texto legible 
    string memory resultado;
    resultado = ResultadosCOVID[_idPersona].resultadoMuestra == true ? "Positivo" : "Negativo";

    //Retorno de valores de la prueba por idPersona (8 bytes)
    _resultadoPruebaCOVID19 = resultado;
    _time = ResultadosCOVID[_idPersona].timestamp;
    }


    
}