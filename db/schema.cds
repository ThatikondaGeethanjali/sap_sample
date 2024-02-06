namespace com.satinfotech.practice;
//using { managed,cuid } from '@sap/cds/common';
entity Student{
    @title:'Student Id'
    key studentid:String(10);
    @title:'First Name'
    first_name:String(30) @mandatory;
    @title:'Last Name'
    last_name:String(30) @mandatory;
    @title:'Email Id'
    email_id:String(50) @mandatory;
    @title:'Pan number'
    pan_num:String(15) @mandatory;
    dob:Date @mandatory;
    @title:'Age'
    virtual age :Integer @Core.Computed;
}