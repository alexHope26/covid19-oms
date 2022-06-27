// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.4;

contract CentroSalud {
    
    // Direcciones iniciales 
    address public DireccionCentroSalud;
    address public DireccionContrato;
    
    constructor (address _direccion) {
        DireccionCentroSalud = _direccion;
        DireccionContrato = address(this);
    }
    
   
    
    
}