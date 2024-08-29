
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

pragma solidity ^0.8.0;

contract AyudaSocial {
    // Dirección del administrador del contrato
    address public administrador;

    // Monto mínimo de donación en wei
    uint256 public montoMinimoDonacion;

    // Mapeo de direcciones de beneficiarios a sus datos
    mapping(address => Beneficiario) public beneficiarios;

    // Evento que se emite cuando se registra un nuevo beneficiario
    event BeneficiarioRegistrado(address beneficiario);

    // Evento que se emite cuando se realiza una donación
    event DonacionRecibida(address donante, uint256 monto);

    // Evento que se emite cuando se entrega un auxilio a un beneficiario
    event AuxilioEntregado(address beneficiario, uint256 monto);

    // Modificador que verifica si el usuario que llama es el administrador
    modifier soloAdministrador() {
        require(msg.sender == administrador, "Solo el administrador puede realizar esta acción");
        _;
    }

    // Constructor del contrato
    constructor(uint256 _montoMinimoDonacion) {
        administrador = msg.sender;
        montoMinimoDonacion = _montoMinimoDonacion;
    }

    // Función para registrar un nuevo beneficiario
    function registrarBeneficiario(address _direccion, uint _edad) public soloAdministrador {
        // Verificar que el beneficiario no esté registrado previamente
        require(beneficiarios[_direccion].direccion == address(0), "El beneficiario ya está registrado");

        // Crear un nuevo beneficiario
        beneficiarios[_direccion] = Beneficiario(_direccion, _edad, false);

        // Emitir evento de beneficiario registrado
        emit BeneficiarioRegistrado(_direccion);
    }

    // Función para realizar una donación al contrato
    function donar() public payable {
        // Verificar que el monto de la donación sea mayor o igual al mínimo
        require(msg.value >= montoMinimoDonacion, "El monto de la donación es menor al mínimo");

        // Emitir evento de donación recibida
        emit DonacionRecibida(msg.sender, msg.value);
    }

    // Función para entregar un auxilio a un beneficiario
    function entregarAuxilio(address _beneficiario, uint256 _monto) public soloAdministrador {
        // Verificar que el beneficiario esté registrado
        require(beneficiarios[_beneficiario].direccion != address(0), "El beneficiario no está registrado");

        // Verificar que el beneficiario no haya recibido auxilio previamente
        require(!beneficiarios[_beneficiario].haRecibidoAuxilio, "El beneficiario ya ha recibido auxilio");

        // Verificar que el contrato tenga suficientes fondos
        require(address(this).balance >= _monto, "El contrato no tiene suficientes fondos");

        // Marcar al beneficiario como que ha recibido auxilio
        beneficiarios[_beneficiario].haRecibidoAuxilio = true;

        // Transferir los fondos al beneficiario
        payable(_beneficiario).transfer(_monto);

        // Emitir evento de auxilio entregado
        emit AuxilioEntregado(_beneficiario, _monto);
    }
}