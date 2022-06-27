// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.4;


import './CentroSalud.sol';

contract Covid19_OMS {
    
    //  Owner del contrato 
    address public oms;
    
    // Constructor de contrato 
    constructor ()  {
        oms = msg.sender;
    }
    
     // Eventos solicitados para obtener informacion
    event NuevoCentroValidado (address);
    event NuevoContrato (address, address);
    event SolicitudAcceso (address);
    
    //Mapeo de centro de salud y un bool para saber si es valido o no
    mapping (address => bool) public AddrCentroSalud_validacion;
    // Mapeo direccion de centro de salud a contrato (Para utilizar la fabrica)
    mapping (address => address) public AddrCentroSalud_AddrContrato;

   
    // Arreglo de direcciones para los contratos de los centros de salud validados 
    address [] public addr_contratos_salud_validos;
    
    // Arreglo de las direcciones que realicen la solicitud de acceso 
    address [] SolicitudesSistemaMedico;
    
    // Modificador el cual permite unicamente la ejecucion de funciones de forma exclusiva por la OMS 
    modifier ExclusivaOMS(address _addr) {
        require(_addr == oms, "No se tienen permisos necesarios para ejecutar la funcion.");
        _;
    }
    
    modifier ExclusivoCentroSaludValido(address _addrValido){
        require (AddrCentroSalud_validacion[_addrValido] == true, "No se tienen permisos necesarios para ejecutar la funcion.");
        _;
    }

    // Funcion para validar nuevos centros de salud que puedan autogestionarse
    function ValidacionCentrosSalud (address _centroSalud) public ExclusivaOMS(msg.sender) {
        // Otorgamiento de validez a centro de salud por parte de OMS
        AddrCentroSalud_validacion[_centroSalud] = true;
        // Emite del evento NuevoCentroValidado
        emit NuevoCentroValidado(_centroSalud);
    }

    // Funcion que permita crear un contrato inteligente de un centro de salud. Esta Funcion solo puede ser ejecutada por los centros de salud validos  
    function FactoryCentroSalud() public ExclusivoCentroSaludValido(msg.sender){
        // Generar un contrato para centro de salud y guardar su direccion. 
        address addrContrato_CentroSalud = address (new CentroSalud(msg.sender));
        // Guarda direccion de contrato en arreglo de contratos validos
        addr_contratos_salud_validos.push(addrContrato_CentroSalud);
        // Guarda el mapeo de direccion de centro de salud y la direccion de su contrato
        AddrCentroSalud_AddrContrato[msg.sender] = addrContrato_CentroSalud;
        // Emite del evento Nuevo Contrato
        emit NuevoContrato(addrContrato_CentroSalud, msg.sender);
    }

    //Funcion solicitar el acceso al sistema medico 
    function SolicitarAccesoSistemaMedico() public {
        // Guarda la direccion en el array de solicitudes al sistema medico 
        SolicitudesSistemaMedico.push(msg.sender);
        // Emite evento SolicitudAcceso 
        emit SolicitudAcceso (msg.sender);
    }
    
    //Funcion visualizar las direcciones que han solicitado este acceso 
    function VisorSolicitudes() public view ExclusivaOMS(msg.sender) returns (address [] memory){
        return SolicitudesSistemaMedico;
    }
      
}