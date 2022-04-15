contract BitsToken is owned, token {
    mapping (address => bool) public frozenAccount;
    mapping (uint => address) public findUserStep1;
    mapping (address => string) public findUserStep2;
    mapping (uint => string) public findUserEC;
    mapping (address => uint) public penaltyCount;
    
    uint public count;
    uint public countEC;

    event FrozenFunds(address target, bool frozen);
    
    function BitsToken(
        uint256 initialCount,
        string tokenName,
        uint8 decimalUnits,
        string tokenImage
    ) token (initialCount, tokenName, decimalUnits, tokenImage) {}
    
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] < _value) throw;
        if (balanceOf[_to] + _value < balanceOf[_to]) throw;
        if (frozenAccount[msg.sender]) throw; 
        balanceOf[msg.sender] -= _value; 
        balanceOf[_to] += _value; 
        Transfer(msg.sender, _to, _value);
    }
    
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (frozenAccount[_from]) throw; 
        if (balanceOf[_from] < _value) throw; 
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
        if (_value > allowance[_from][msg.sender]) throw; 
        balanceOf[_from] -= _value; 
        balanceOf[_to] += _value; 
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }
    
    function smartUsersPayments(address _user, uint256 _origin) payable onlyOwner returns (bool success) {
        if (_user == 0x0) throw;
        if (balanceOf[msg.sender] < 10) throw;
        if (balanceOf[_user] + 10 < balanceOf[_user]) throw;
        uint mintedAmount = 10;
        uint aux =0;
        uint positivePoints = 2;
        uint negativePoints = 5;
        uint destroyAmount = 5;
        if((_origin>0) && (_origin<= 100)){
            
            balanceOf[_user] += mintedAmount; 
            totalSupply += mintedAmount; 
            Transfer(0, this, mintedAmount);
            Transfer(this, _user, mintedAmount);
            
            aux = penaltyCount[_user]; 
            if (penaltyCount[_user] == 1){
                penaltyCount[_user] = 0; 
            }
            if (penaltyCount[_user] > positivePoints){
                penaltyCount[_user] = aux -positivePoints; 
            }
            if (penaltyCount[_user] < 25){
                frozenAccount[_user] = false;
                FrozenFunds(_user, false);
            }
            return true;
        }
        else{
            if(balanceOf[_user] >= destroyAmount){
                balanceOf[_user] -= destroyAmount; 
                totalSupply -= destroyAmount; 
            } else {
                if((balanceOf[_user] > 0) && (balanceOf[_user] < destroyAmount)){
                    uint aux2 = balanceOf[_user];
                    balanceOf[_user]-= aux2; 
                    totalSupply -= aux2;
                }
            }
            aux = penaltyCount[_user]; 
            penaltyCount[_user] = aux + negativePoints; 
            if (penaltyCount[_user] >= 25){
                frozenAccount[_user] = true;
                FrozenFunds(_user, true);
            }
        }
    }
    function addUser(address publicKey, string id) onlyOwner {
        findUserStep1[count] = publicKey;
        findUserStep2[publicKey] = id;
        penaltyCount[publicKey] = 0; 
        count++;
    }
    function addUserEC(uint idEC, string id) onlyOwner {
        findUserEC[idEC] = id;
        countEC++;
    }
}