pragma solidity >=0.4.22 ;

contract Practical5{
    mapping(address=>Entity) public entities;
    mapping(uint=>Medicine) public medicines;
    
    enum Role{NA, Doctor, Patient, Staff}
    enum SurgeryDomains{heart, kideny, liver, stomach, brain}
    enum SurgeryResult{successful, failed}
    enum RecommendType{strongly, normal , not}
    
    struct Medicine{
        uint id;
        string name;
        uint stock;
    }
    
    struct Entity{
        string name;
        string location;
        string dob;
        Role role;
        
        SurgeryDomains speciality;
        RecommendType surgenRecommended;
        bool isCertified;
        uint32 surgerySuccessful;
        uint32 surgeryUnsuccessful;
        uint32 performanceRate;
    }
    
    modifier onlyPatient{
        require(entities[msg.sender].role == Role.Patient);
        _;
    }
    
    modifier onlyStaff{
        require(entities[msg.sender].role == Role.Staff);
        _;
    }
    
    function registerPatint(
    string memory _name,
    string memory _location,
    string memory _dob
        ) public {
            require(entities[msg.sender].role!=Role.Patient,"Already Enrolled");
            entities[msg.sender].role = Role.Patient;
            entities[msg.sender].name = _name;
            entities[msg.sender].location = _location;
            entities[msg.sender].dob = _dob;
        }
        
    function registerDoctor(
        string memory _name,
        string memory _location,
        string memory _dob,
        SurgeryDomains _speciality,
        uint32 performanceRate,
        bool _certification
        ) public{
            require(entities[msg.sender].role!=Role.Doctor,"Already in database");
            entities[msg.sender].role = Role.Doctor;
            entities[msg.sender].name = _name;
            entities[msg.sender].location = _location;
            entities[msg.sender].dob = _dob;
            entities[msg.sender].speciality = _speciality;
            entities[msg.sender].surgerySuccessful = 0;
            entities[msg.sender].surgeryUnsuccessful = 0;
            entities[msg.sender].performanceRate = performanceRate;
            entities[msg.sender].isCertified = _certification;
    }
    
    function surgeryResult(address doctor, SurgeryResult _result) onlyPatient public{
        if(_result == SurgeryResult.successful){
            entities[doctor].surgerySuccessful+=1;
        } else {
            entities[doctor].surgeryUnsuccessful+=1;
        }
    }
    
    function performanceRateUpdate(address _doctor) public{
        entities[_doctor].performanceRate = entities[_doctor].surgerySuccessful /(entities[_doctor].surgerySuccessful + entities[_doctor].surgeryUnsuccessful);
    }
    
    function certified(address _doctor, SurgeryDomains surgerytype) view public returns(bool){
        require(entities[_doctor].speciality == surgerytype);
        require(entities[_doctor].surgenRecommended != RecommendType.not );
        require(entities[_doctor].isCertified);
        return true;
    }
    
    function updateRcommended(address doctor) public{
        if(entities[doctor].performanceRate > 9){
            entities[doctor].surgenRecommended = RecommendType.strongly;
            
        }
        else if(entities[doctor].performanceRate > 8){
            entities[doctor].surgenRecommended = RecommendType.normal;
            
        }
        else{
            entities[doctor].surgenRecommended = RecommendType.not;
            
        }
    }
    
    function payFees(uint fees, address patient) onlyPatient public { 
        require(patient.balance >= fees);
        patient.transfer(fees);
    }
    
    function addMedicine(uint _id, string memory _name, uint _amount) onlyStaff public{
        require(medicines[_id].id!=_id, "Already in database");
        medicines[_id].id = _id;
        medicines[_id].name = _name;
        medicines[_id].stock = _amount;
    }
    
    function medicineDistribution(uint _id, uint _amount) public{
        require(medicines[_id].stock >= _amount,"Insufficient stock");
        medicines[_id].stock -= _amount;   
    }
    
    
    function addMedicineStock(uint _id, uint _amount) public{
        medicines[_id].stock += _amount;
    }
}


 
