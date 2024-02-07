const cds = require('@sap/cds');

function calcAge(dob) {
    const today = new Date();
    const birthDate = new Date(Date.parse(dob));
    let age = today.getFullYear() - birthDate.getFullYear();
    const m = today.getMonth() - birthDate.getMonth();
    
    if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
        age--;
    }

    return age;
}

module.exports = cds.service.impl(function () {

    const { Student } = this.entities();

    this.on(['READ'], Student, async(req) => {
        results = await cds.run(req.query);
        if(Array.isArray(results)){
            results.forEach(element => {
             element.age=calcAge(element.dob);
             element.gender = getDisplayGender(element.gender);
 
            });
        }else{
            results.age=calcAge(results.dob);
            results.gender = getDisplayGender(results.gender);
        }
        
        return results;
    });

    function getDisplayGender(genderCode) {
        if (genderCode === 'M') {
            return 'Male';
        } else if (genderCode === 'F') {
            return 'Female';
        } else {
            // Add additional cases if needed
            return 'Unknown';
        }
    }

    
    /*this.on('READ',Gender,async(req)=>{
        genders=[
            {"code":"F","Description":"Female"},
            {"code":"M","Description":"Male"}
        ]
        genders.$count=genders.length;
        return genders ;
    })*/

    this.before(['CREATE'], Student, async(req) => {

        age=calcAge(req.data.dob);
        if(age<18 || age>45){
            req.error({'code':'WRONGDOB',message:'Student not the right age for school:'+age,target:'dob'});
        }

        let query1 = SELECT.from(Student).where({ref:["email_id"]}, "=", {val: req.data.email_id});
        result = await cds.run(query1);
        if (result.length >0) {
            req.error({'code': 'STEMAILEXISTS',message:'Student with such email already exists',target:"email_id"});
        }
        let query2 = SELECT.from(Student).where({ref:["pan_num"]}, "=", {val: req.data.pan_num});
        result = await cds.run(query2);
        if (result.length >0) {
            req.error({'code': 'STPANEXISTS',message:'Student with such pan already exists',target:"pan_num"});
        }
    });

     // Before Update Operation for Student
     this.before(['UPDATE'], Student, async (req) => {
        const { email_id, studentid } = req.data;
        if (email_id) {
            const query = SELECT.from(Student).where({ email_id: email_id }).and({ studentid: { '!=': studentid } });
            const result = await cds.run(query);
            if (result.length > 0) {
                req.error({ code: 'STEMAILEXISTS', message: 'Student with such email already exists', target: 'email_id' });
            }
        }
    });
});