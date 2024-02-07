using { com.satinfotech.practice as db} from '../db/schema';


service practice{
    entity Student as projection on db.Student;
}
annotate practice.Student with @odata.draft.enabled;


annotate practice.Student with {
    first_name      @assert.format: '^[a-zA-Z]{2,}$';
    last_name      @assert.format: '^[a-zA-Z]{2,}$';    
    email_id     @assert.format: '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    pan_num     @assert.format:'[A-Z]{5}[0-9]{4}[A-Z]{1}$'
}

annotate practice.Student with @(
    UI.LineItem: [
        {
            $Type : 'UI.DataField',
            Value : studentid
        },
        {
            $Type : 'UI.DataField',
            Label:'Gender',
            Value : gender
        },
        {
            $Type : 'UI.DataField',
            Value : first_name
        },
        {
            $Type : 'UI.DataField',
            Value : last_name
        },
        {
            $Type : 'UI.DataField',
            Value : email_id
        },
        {
            $Type : 'UI.DataField',
            Value : pan_num
        },
        {
            $Type : 'UI.DataField',
            Value : dob
        },
        {
            $Type : 'UI.DataField',
            Value : age
        },

    ],
    UI.SelectionFields: [ first_name , last_name, email_id, pan_num],       
);

annotate practice.Student with @(
    UI.FieldGroup #StudentInformation : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : studentid,
            },
            {
            $Type : 'UI.DataField',
            Label:'Gender',
            Value : gender
             },
            {
                $Type : 'UI.DataField',
                Value : first_name,
            },
            {
                $Type : 'UI.DataField',
                Value : last_name,
            },
            {
                $Type : 'UI.DataField',
                Value : email_id,
            },
            {
                $Type : 'UI.DataField',
                Value : pan_num,
            },
            {
                $Type : 'UI.DataField',
                Value : dob,
            },
          
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'StudentInfoFacet',
            Label : 'Student Information',
            Target : '@UI.FieldGroup#StudentInformation',
        },
    ],
    
);

annotate StudentDB.Student with {
    gender @(     
        Common.ValueListWithFixedValues: true,
        Common.ValueList : {
            Label: 'Genders',
            CollectionPath : 'Gender',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : gender,
                    ValueListProperty : 'code'
                },
               
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'Description'
                }
            ]
        }
    );
}