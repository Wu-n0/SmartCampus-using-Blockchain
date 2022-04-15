contract token {
    string public standard = 'Token 1';
    string public name;
    string public image;
    uint8 public decimals;
    uint256 public totalCount;
    
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    function token(
        uint256 initialCount,
        string tokenName,
        uint8 decimalUnits,
        string tokenImage
        ) {
        balanceOf[msg.sender] = initialCount; 
        
        totalCount = initialCount; 
        name = tokenName; 
        image = tokenImage; 
        decimals = decimalUnits; 
    }
    
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] < _value) throw; 
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
        balanceOf[msg.sender] -= _value; 
        balanceOf[_to] += _value; 
        Transfer(msg.sender, _to, _value); 
    }
    
    function () {
        throw; 
    }
}