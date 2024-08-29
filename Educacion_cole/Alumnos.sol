// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AlumnosContract {
    struct Alumno {
        string nombre;
        string apellido;
        uint8 grado;
        string sexo;
    }

    address public owner;
    mapping(address => Alumno) public alumnos;
    address[] public alumnosList;
    
    event AlumnoRegistrado(address alumno, string nombre, string apellido);
    event AlumnoEliminado(address alumno);
    event AlumnoActualizado(address alumno, string nombre, string apellido);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el propietario puede ejecutar esta funcion");
        _;
    }

    function registrarAlumno(string memory _nombre, string memory _apellido, uint8 _grado, string memory _sexo) public {
        Alumno memory alumno = Alumno(_nombre, _apellido, _grado, _sexo);
        alumnos[msg.sender] = alumno;
        alumnosList.push(msg.sender);
        emit AlumnoRegistrado(msg.sender, _nombre, _apellido);
    }

    function eliminarAlumno(address _alumno) public onlyOwner {
        delete alumnos[_alumno];
        emit AlumnoEliminado(_alumno);
    }

    function actualizarAlumno(string memory _nombre, string memory _apellido, uint8 _grado, string memory _sexo) public {
        Alumno storage alumno = alumnos[msg.sender];
        alumno.nombre = _nombre;
        alumno.apellido = _apellido;
        alumno.grado = _grado;
        alumno.sexo = _sexo;
        emit AlumnoActualizado(msg.sender, _nombre, _apellido);
    }

    function totalAlumnos() public view returns (uint256) {
        return alumnosList.length;
    }

    // Funcionalidad para manejar tokens (ERC20)

    string public name = "AlumnoToken";
    string public symbol = "ALT";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function _mint(address _to, uint256 _value) internal {
        totalSupply += _value;
        balanceOf[_to] += _value;
        emit Transfer(address(0), _to, _value);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Balance insuficiente");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from], "Balance insuficiente");
        require(_value <= allowance[_from][msg.sender], "Allowance insuficiente");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function comprarTokens() public payable {
        uint256 tokens = msg.value * 100; // 1 ETH = 100 ALT (Ejemplo)
        _mint(msg.sender, tokens);
    }
}
