// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

contract UserSettings {

    mapping(address => address[]) public trustLists;

    //事件日志   
    event SetUser(address indexed user, string messageHash, uint256 settingTime);
    event AddTrustPeople(address indexed user,address trustPeople, uint256 addTime);
    event DelPeople(address indexed user,address untrustPeople, uint256 delTime);

    //用户设置
    function setUser(string memory _messageHash)
        public 
    {       
        emit SetUser(msg.sender, _messageHash, block.timestamp);
    }

    //判断是否我的信任名单内
    function inMyTrustLists(address _user, address _people) 
        public 
        view 
        returns(bool)
    {
        require(_people != address(0));
        for(uint i = 0; i < trustLists[_user].length; i ++){
            if(trustLists[_user][i] == _people){
                return true;
            }     
        }
        return false;
    }

    //增加信任名单
    function addTrustPeople(address _people) 
        public 
    {
        require(_people != address(0));
        require(!inMyTrustLists(msg.sender, _people));
        trustLists[msg.sender].push(_people);

        emit AddTrustPeople(msg.sender,_people, block.timestamp);
    }

    //删除信任名单
    function delPeople(address _people)
        public
    {
        require(_people != address(0));
        require(inMyTrustLists(msg.sender, _people));
        
        for(uint i = 0; i < trustLists[msg.sender].length; i ++ )
        {
            if(trustLists[msg.sender][i] == _people)
            {
                delete trustLists[msg.sender][i];
            }
        }

        emit DelPeople(msg.sender, _people, block.timestamp);
    }
    
    //判断是否在信任名单内
    function inTrustLists(address _user, address _people) 
        public 
        view 
        returns(bool)
    {
        require(_people != address(0));

        //直接信任名单
        for(uint i = 0; i < trustLists[_user].length; i ++){
            if(trustLists[_user][i] == _people){
                return true;
            }     
        }
        // 拓展信任名单
        for(uint j = 0; j < trustLists[_user].length; j ++){
            for(uint k = 0; k < trustLists[trustLists[_user][j]].length; k ++){
                if(trustLists[trustLists[_user][j]][k] == _people){
                    return true;
                }
            }
        }
        return false;
    }

    function getTrustListsLength(address _user) public view returns(uint256){
        return trustLists[_user].length;
    } 
}