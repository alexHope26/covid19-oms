const { expect } = require("chai");
const { ethers } = require("hardhat");



describe("COVID19_OMS",function(){

let CSF;
let CS;
let owner,signer1,signer2,signer3,signer4,signer5;
let csf;
let addr_centro1,addr_centro2;

beforeEach(async function(){

    CSF = await ethers.getContractFactory("Covid19_OMS");
    CS = await ethers.getContractFactory("CentroSalud");
    [owner,signer1,signer2,signer3,signer4,signer5] = await ethers.getSigners();

    csf = await CSF.deploy();
    await csf.deployed();

});

describe("Validacion OMS centro salud y autogestion", function () {
    it("OMS genera validacion a centros de salud y contratos", async function () {
 
      //Direccion del contrato
    console.log("COVID19_OMS deployed to:", csf.address);

        //Agregamos la cuenta 1 y 2 como centros de salud validos.
    await csf.ValidacionCentrosSalud(signer1.address);
    await csf.ValidacionCentrosSalud(signer2.address);

   //Validacion de centro de salud.
    expect (await csf.AddrCentroSalud_validacion(signer1.address).true);
    expect (await csf.AddrCentroSalud_validacion(signer2.address).true);
    //Cuenta signer3 no validada como centro de salud
    expect (await csf.AddrCentroSalud_validacion(signer3.address).false);


    //Creacion de contrato de centro de salud por parte de la cuenta signer1 (validada)
    await csf.connect(signer1).FactoryCentroSalud();
    addr_centro1 = await csf.AddrCentroSalud_AddrContrato(signer1.address);
    console.log("Contrato de factory Signer1",addr_centro1);

     //Creacion de contrato de centro de salud por parte de la cuenta signer2 (validada)
     await csf.connect(signer2).FactoryCentroSalud();
     addr_centro2 = await csf.AddrCentroSalud_AddrContrato(signer2.address);
     console.log("Contrato de factory Signer2",addr_centro2);


    // Attach las direcciones de los contratos de centros de salud generados.
    const centroSalud1 = await CS.attach(addr_centro1);
    const centroSalud2 = await CS.attach(addr_centro2);

    await centroSalud1.connect(signer1).ExpedicionResultadosCovid19(1234567,true);
    await centroSalud2.connect(signer2).ExpedicionResultadosCovid19(9876543,false);

    var resultado1 = await centroSalud1.ConsultaResultados(1234567);
    var resultado2 = await centroSalud2.ConsultaResultados(9876543);

    console.log("Resultado 1",resultado1);
    expect (resultado1._resultadoPruebaCOVID19.true);
    
    console.log("Resultado 2",resultado2);
    expect (resultado2._resultadoPruebaCOVID19.false);


    });

    it("Solicitud Acceso al sistema medico", async function () {

        await csf.connect(signer3).SolicitarAccesoSistemaMedico();
        await csf.connect(signer4).SolicitarAccesoSistemaMedico();
        await csf.connect(signer5).SolicitarAccesoSistemaMedico();

    var solicitudes  =  await csf.VisorSolicitudes();
    console.log("Solicitudes",solicitudes);
    });
      
}); 
});
